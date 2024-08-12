variable "server_port" {
    description ="The port the server will use for http requests"
    type = number 
    default = 8080
}
variable "alb_port" {
    description ="The port the server will use for http requests"
    type = number 
    default = 80
}