# output "public_ip" {
#     description = "The public ip address of the web server"
#     value = aws_instance.terraformer.public_ip
#     sensitive = false
  
# }
output "alb_dns_name" {
    description = "The domain mane  of the web server"
    value = aws_lb.terraformer.dns_name
    sensitive = false
  
}
output "asg_name" {
    value = aws_autoscaling_group.terra.name
    description = "The name of the auto scaling group"
}
output "alb_security_group_id" {
    value = aws_security_group.alb.id
    description = "ID of security group attached to the load bablancer"
  
}