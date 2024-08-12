data "terraform_remote_state" "rdsexample" {
  backend = "s3"

  config = {
    bucket = "ketbuc678989797"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "aws_launch_configuration" "terraformer"{
    image_id = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.terraformer-instance.id ]
    # put the user script in a template file instead of using <<-EOF
    user_data = templatefile("user_data.sh",{
      server_port = var.server_port
      db_address = data.terraform_remote_state.rdsexample.outputs.address
      db_port = data.terraform_remote_state.rdsexample.outputs.port
    })
    lifecycle {
      create_before_destroy = true
    }
}



resource "aws_autoscaling_group" "terra" {
    launch_configuration = aws_launch_configuration.terraformer.name
    target_group_arns = [ aws_lb_target_group.alb-target.arn ]
    vpc_zone_identifier  = data.aws_subnets.default.ids
    health_check_type = "ELB"
    min_size = 1
    max_size = 2
    tag {
      key = "Name"
      value = "terraform_asg_example"
      propagate_at_launch = true
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_lb" "terraformer" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb.id]
  
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.terraformer.arn
    port = var.alb_port
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
   name = "terraform-example-alb"
  
}

resource "aws_vpc_security_group_ingress_rule" "terraformer-alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.alb_port
  ip_protocol       = "tcp"
  to_port           = var.alb_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_lb_target_group" "alb-target" {
  name        = "terraform-asg-example"
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
