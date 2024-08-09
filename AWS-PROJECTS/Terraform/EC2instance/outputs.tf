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