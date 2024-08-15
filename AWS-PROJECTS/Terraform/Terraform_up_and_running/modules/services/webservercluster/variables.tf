variable "server_port" {
    description ="The port the server will use for http requests"
    type = number 
    default = 8080
}
# variable "alb_port" {
#     description ="The port the server will use for http requests"
#     type = number 
#     default = 80
# }
variable "cluster_name" {
    description = "the name to use for all cluster resources"
    type = string
  
}
variable "db_remote_state_bucket" {
description = "The name of s3 bucket for the database's remote"
type = string  
}
variable "db_remote_state_key" {
  description = "path for database remote state in s3"
  type = string
}
variable "instance_type" {
    description = "type of ec2 instance"
    type = string
  
}
variable "min_size" {
    description = "minimum number of ec2 in asg"
    type = number
  
}
variable "max_size" {
    description = "max number of ec2 instance in ASG"
    type = number
  
}
variable "custom_tags"{
    description = "custom tags to set on the instances in the asg"
    type = map(string)
    default = {}
  
}
variable "enable_autoscaling" {
    description = "if set to true , enable autoscaling"
    type = bool
  
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-04a81a99f5ec58529"
}

variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "Hello, World"
}