provider "aws" {
  region = "ap-south-1" # Mumbai region
}


module "vpc" {
  source = "./vpc"
  #my_ip  = var.my_ip
}

module "iam" {
  source = "./iam"
}

module "ec2" {
  source                            = "./ec2"
  subnet_id                         = module.vpc.subnet_id
  jenkins_security_group_id         = module.vpc.jenkins_security_group_id
  dev_server_security_group_id      = module.vpc.dev_server_security_group_id
  prod_server_security_group_id     = module.vpc.prod_server_security_group_id
  monitor_server_security_group_id  = module.vpc.monitor_server_security_group_id
  iam_instance_profile              = module.iam.instance_profile
  public_key_path                  = var.public_key_path
}