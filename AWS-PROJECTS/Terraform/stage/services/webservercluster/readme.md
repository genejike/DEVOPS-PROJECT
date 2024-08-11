## Launching a simple web server and a cluster of web servers with terraporm on Aws 

- create an Iam user on aws and generate your access keys 
- update your .aws/config files with your iam credintials or alternatively you can export the files locally but note that if you close your text editor you will have to run the export command again. you can also use the aws configure to update your configuration file
- Now your connected to aws ,ensure terraform is installed on your system and type terraform to confirm
- create a folder and create your main.tf 
- Head over to [Hashicorp developer docs](https://registry.terraform.io/providers/hashicorp) and select aws as the provider 
- select the use provider button and paste into your main.tf

```h
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
```
### [Creating the aws instance resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

[Creating the aws security group ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

- click the link above to see sample data on creating a simple webserver and edit as required

```h
resource "aws_instance" "terraformer"{
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.terraformer-instance.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello,world" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    user_data_replace_on_change = true

   
    tags ={
        Name = "terra-instance"
    }
}

resource "aws_security_group" "terraformer-instance" {
  name        = "terraformer-instance"
  description = "Allow terraformer-instance inbound traffic and all outbound traffic"

  tags = {
    Name = "terraformer-instance"
  }
}

resource "aws_vpc_security_group_ingress_rule" "terraformer-instance" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


```



- In your variables.tf file define in 
```h
variable "server_port" {
    description ="The port the server will use for http requests"
    type = number 
    default = 8080
}
```
- Then reference them as var.serverport in the respective places,
from_port and to_port

- I set the default to port 8080 so that the prompt wunt be interactive 

- Create the output.tf file so that you can view the output of the public ip address after its created also for sensitive things make sure to set to true if not it will be printed on the console 

```h
output "public_ip" {
    description = "The public ip address of the web server"
    value = aws_instance.terraformer.public_ip
    sensitive = false
  
}
```
## Deploying a cluster of web servers 
### Creating an autoscaling group 
- use the [aws_launch_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) instead of the aws_instance you used ealier 

- replace the aws_instance block with 
```h
resource "aws_launch_configuration" "terraformer"{
    image_id = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.terraformer-instance.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello,world" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
}

```

- Now create the [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/autoscaling_group)

```t
resource "aws_autoscaling_group" "terra" {
    launch_configuration = aws_launch_configuration.terraformer.terra.id
    min_size = 2
    max_size = 4  
    tag {
      key = "Name"
      value = "terraform_asg_example"
      propagate_at_launch = true
    }
}

```
- Always remember that asg by defaults deletes the old one and creates its replacement  if you change any parameter in your launch configuration .terraform will always try to replace it 
- Therefore set lifecycle settings like create_before_destroy so tf will invert the order it creates it by creating the replacement first and updating any references that was pointing to the old one b4 deleting the old one .
 
```h
    lifecycle {
      create_before_destroy = true
    }
```
- A data source represents a piece of read-only information that is fetched from the provider (in this case, AWS) every time you run Terraform. Adding a data source to your Terraform configurations does not create anything new; it’s just a way to query the provider’s APIs for data and to make that data available to the rest of your Terraform code. Each Terraform provider exposes a variety of data sources. For example, the AWS Provider includes data sources to look up VPC data, subnet data, AMI IDs, IP address ranges, the current user’s identity, and much more

- This helps to reference existing configuration so we can use it 
eg
```h
data "aws_vpc" "default" {
    default = true
  
}
data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
  
}
``` 
now we can reference it in our aws_autoscaling_group

```h

resource "aws_security_group" "terraformer-instance" {
  name        = "terraformer-instance"
  description = "Allow terraformer-instance inbound traffic and all outbound traffic"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "terraformer-instance"
  }
}
```
### [Creating an Application load balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) 
- configure your load balancer to handle your asg

```h
resource "aws_lb" "terraformer" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
  
}

```
- configure a [listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) for the Alb 

```h
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

```

- you need to create a specific security group for the alb else it wunt work 

```h
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

```

- you also need the aws_alb to actually use this security group 
- Add the 

```h
security_groups = [aws_security_groups.alb.id] to your aws_alb resource

```
`
### [creating target group for your ASG](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)

```h
resource "aws_lb_target_group" "alb-target" {
  name        = "terraform-asg-example"
  target_type = "instance"
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
```
- how does the target group know the ec2 instances to send requests to 
to do this set the `target_group_arns = aws_lb_target_group.asg.arn ` in the aws_autoscaling_group

```h
resource "aws_autoscaling_group" "terra" {
    launch_configuration = aws_launch_configuration.terraformer.name
    target_group_arns = [ aws_lb_target_group.alb-target.arn ]
    vpc_zone_identifier = [ data.aws_subnets.default.ids ]
    health_check_type = "ELB"
    min_size = 2
    max_size = 4  
    tag {
      key = "Name"
      value = "terraform_asg_example"
      propagate_at_launch = true
    }
    lifecycle {
      create_before_destroy = true
    }
}
``` 
- we also set the health_check_type = "ELB" because by default it is EC2.. this asks the ASG to use the target group health check to determine if an instance is healthy

- ### [creating listener rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) 

```h

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
```
- In the variable.tf file specify

```h
variable "alb_port" {
    description ="The port the server will use for http requests"
    type = number 
    default = 80
}
  
```
- change the port 80 in port section to var.alb_port  

- create your output.tf to display the output file 

```h
output "alb_dns_name" {
    description = "The domain mane  of the web server"
    value = aws_lb.terraformer.dns_name
    sensitive = false
  
}
```


