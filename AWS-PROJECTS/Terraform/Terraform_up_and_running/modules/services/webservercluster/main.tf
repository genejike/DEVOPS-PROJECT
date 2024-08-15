data "terraform_remote_state" "rdsexample" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    =var.db_remote_state_key
    region = "us-east-1"
  }
}


resource "aws_launch_configuration" "terraformer"{
    image_id = var.ami
    instance_type =var.instance_type
    security_groups = [ aws_security_group.terraformer-instance.id ]
    # put the user script in a template file instead of using <<-EOF
    user_data = templatefile("${path.module}/user_data.sh",{
      server_port = var.server_port
      db_address = data.terraform_remote_state.rdsexample.outputs.address
      db_port = data.terraform_remote_state.rdsexample.outputs.port
      server_text =var.server_text
    })
    lifecycle {
      create_before_destroy = true
    }
}



resource "aws_autoscaling_group" "terra" {
    name = var.cluster_name
    launch_configuration = aws_launch_configuration.terraformer.name
    target_group_arns = [ aws_lb_target_group.alb-target.arn ]
    vpc_zone_identifier  = data.aws_subnets.default.ids
    health_check_type = "ELB"
    min_size = var.min_size
    max_size = var.max_size
  # Wait for at least this many instances to pass health checks before
  # considering the ASG deployment complete
    # min_elb_capacity = var.min_size
    # use instance refresh to roll out changes to the asg
    instance_refresh {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = 50
      }
    }
    tag {
      key = "Name"
      value = "${var.cluster_name}-alb"
      propagate_at_launch = true
    }
     dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags:
      key => upper(value)
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
    # lifecycle {
    #   create_before_destroy = true
    # }
    
    
}
# it is  used when you do code refactoring like changing  names of resources so terraform
 # doesnt delete the old one and create a new one rather it treats it the same and just renames it 
# moved {
#   from = aws_instance .terra
#   to = aws_instance .terraform
# }
resource "aws_autoscaling_schedule" "scaling_out_during_business_hours"{
  count = var.enable_autoscaling ? 1 : 0
    autoscaling_group_name = aws_autoscaling_group.terra.name
    scheduled_action_name = "scaling_out_during_business_hours"
    min_size = 1
    max_size = 2
    desired_capacity = 2
    recurrence = "0 9 * * *"
  
}
resource "aws_autoscaling_schedule" "scale_in_at_night"{
  count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "scale_in_at_night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"
    autoscaling_group_name = aws_autoscaling_group.terra.name
  
}

resource "aws_lb" "terraformer" {
    name = "${var.cluster_name}-alb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb.id]
  
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.terraformer.arn
    port = local.http_port
    protocol = "HTTP"
# By default to return a simple 404 page 
    default_action {
      type = "fixed-response"
    fixed_response {
      
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
    }
  
}

resource "aws_security_group" "alb" {
   name = "${var.cluster_name}alb"
  
}

resource "aws_vpc_security_group_ingress_rule" "terraformer-alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = local.all_ips
  from_port         = local.http_port
  ip_protocol       = local.tcp_protocol
  to_port           = local.http_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = local.all_ips
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}

resource "aws_lb_target_group" "alb-target" {
  name        = "${var.cluster_name}-alb"
  target_type = "instance"  # Correct target type
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }


}
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
      path_pattern {
        
        values = [ "*" ]
    }
    }
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb-target.arn
    }
  
}
