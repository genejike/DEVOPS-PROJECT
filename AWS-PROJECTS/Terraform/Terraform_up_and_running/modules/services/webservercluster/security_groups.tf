resource "aws_security_group" "terraformer-instance" {
  name        = "${var.cluster_name}-terraformer-instance"
  description = "Allow terraformer-instance inbound traffic and all outbound traffic"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "terraformer-instance"
  }
}

resource "aws_vpc_security_group_ingress_rule" "terraformer-instance" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = local.all_ips
  from_port         = var.server_port
  ip_protocol       = local.tcp_protocol
  to_port           = var.server_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraformer-instance.id
  cidr_ipv4         = local.all_ips
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}