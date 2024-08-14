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