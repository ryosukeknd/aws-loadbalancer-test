resource "aws_instance" "ec2_instance" {
  ami = "${var.ec2_ami}"
  instance_type = "t4g.nano"
  subnet_id = var.ec2_subnet_id
  vpc_security_group_ids = var.ec2_security_groups
  associate_public_ip_address = true
  availability_zone = var.ec2_az
  root_block_device {
    volume_size = 100
  }
  user_data = file("./script/user_data.sh")
}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}
