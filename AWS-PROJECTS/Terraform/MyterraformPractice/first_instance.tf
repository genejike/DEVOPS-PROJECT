provider "aws"{
    region = "us-east-2"
}
resource "aws_instance" "intro"{
    ami = "ami-04cb4ca688797756f"
    instance_type = "t2.micro"
    availability_zone = "us-east-1d"
    key_name = "PBL2"
    tags ={
        Name = "terra-instance"
    }
}