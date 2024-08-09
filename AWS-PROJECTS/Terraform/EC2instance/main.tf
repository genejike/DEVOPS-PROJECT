provider "aws"{
    region = "us-east-1"
}
resource "aws_instance" "terraformer"{
    ami = "ami-04cb4ca688797756f"
    instance_type = "t2.micro"
    tags ={
        Name = "terra-instance"
    }
}