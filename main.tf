provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "modules/vpc"
  key_path = "${var.key_path}"
#  access_key = "${var.access_key}" 
#  secret_key = "${var.secret_key}"
  allowed_network = "${var.allowed_network}"
  
  sg_default = "${module.sec-group.sg_default}"
  sg_nat = "${module.sec-group.sg_nat}"
}

module "cfgmt" {
  source = "modules/asg"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
  sg_web = "${module.sec-group.sg_web}"

  public_elb_sec_group = "${module.sec-group.public_elb_sec_group}"
  bastion_host_ssh_sec_group = "${module.sec-group.bastion_host_ssh}"
}

module "sec-group" {
  source = "modules/sec-group"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
  allowed_network = "${var.allowed_network}"
}
