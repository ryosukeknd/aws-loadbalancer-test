data "aws_caller_identity" "self" { }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

module "ec2" {
  count = 4

  source = "./module/ec2"

  ec2_ami = "ami-082b947c0f239bcd0"
  ec2_subnet_id = module.vpc.private_subnets[count.index % 2]
  ec2_az = module.vpc.azs[count.index % 2]
  ec2_security_groups = [
    module.network.security_group_id_for_ec2
  ]
  vpc_id = module.vpc.vpc_id
}

module "network" {
  source = "./module/network"

  vpc_id = module.vpc.vpc_id
  iec_private_subnet = module.vpc.private_subnets[0]
}

module "elb" {
  source = "./module/elb"

  vpc_id = module.vpc.vpc_id
  nlb_subnets = module.vpc.public_subnets
  nlb_target_ec2_list = module.ec2.*.ec2_instance_id
  alb_security_groups = [module.network.security_group_id_for_alb]
  alb_subnets = module.vpc.private_subnets
  alb_target_ec2_list = module.ec2.*.ec2_instance_id
}
