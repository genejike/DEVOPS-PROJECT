resource "aws_security_group" "terraformer-instance" {
  name        = "terraformer-instance"
  description = "Allow terraformer-instance inbound traffic and all outbound traffic"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "terraformer-instance"
  }
}

resource "aws_vpc_security_group_ingress_rule" "terraformer-instance" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.server_port
  ip_protocol       = "tcp"
  to_port           = var.server_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}