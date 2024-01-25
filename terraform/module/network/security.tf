#################################################
# for EC2
#################################################
resource "aws_security_group" "ec2_instance_security_group" {
  vpc_id = var.vpc_id
}
# allow inbound ssh connection : "instance connect endpoint" and "EC2 instance"
resource "aws_vpc_security_group_ingress_rule" "ec2_instance_security_group_inbound" {
  security_group_id = aws_security_group.ec2_instance_security_group.id
  referenced_security_group_id = aws_security_group.iec_security_group_for_iec.id
  ip_protocol = "TCP"
  from_port = 22
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "ec2_instance_security_group_inbound_http" {
  security_group_id = aws_security_group.ec2_instance_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port = 8080
  to_port = 8080
}

output "security_group_id_for_ec2" {
  value = aws_security_group.ec2_instance_security_group.id
}

#################################################
# for instance connect endpoint
#################################################
resource "aws_security_group" "iec_security_group_for_iec" {
  vpc_id = var.vpc_id
}

# allow outbound ssh connection : "instance connect endpoint" and "EC2 instance"
resource "aws_vpc_security_group_egress_rule" "ice_security_group_outbound" {
  security_group_id = aws_security_group.iec_security_group_for_iec.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port = 22
  to_port = 22
}

output "security_group_id_for_iec" {
  value = aws_security_group.iec_security_group_for_iec.id
}

#################################################
# for Application Load Balancer
#################################################
resource "aws_security_group" "alb_security_group" {
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "alb_security_outbound" {
  security_group_id = aws_security_group.alb_security_group.id
  referenced_security_group_id = aws_security_group.ec2_instance_security_group.id
  ip_protocol = "TCP"
  from_port = 8080
  to_port = 8080
}

resource "aws_vpc_security_group_ingress_rule" "alb_security_inbound" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port = 80
  to_port = 80
}

output "security_group_id_for_alb" {
  value = aws_security_group.alb_security_group.id
}
