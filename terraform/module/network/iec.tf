# create "instance connect endpoint"
resource "aws_ec2_instance_connect_endpoint" "ec2_ice" {
  subnet_id = var.iec_private_subnet
  security_group_ids = [
    aws_security_group.iec_security_group_for_iec.id
  ]
}
