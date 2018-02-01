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

## module "cfgmt" {
##   source = "modules/asg"
## 
##   vpc_id = "${module.vpc.id}"
##   subnet_id = "${module.vpc.public_network_id}"
##   elb_subnets = ["${module.vpc.public_network_id}"]
##   sg_web = "${module.sec-group.sg_web}"
## 
##   # min_instances_size = 5
##   # max_instances_size = 10
##   # server_port = 8080
##   # public_elb_sec_group = ["${module.sec-group.public_elb_sec_group}", "${module.sec-group.sg_default}"]
##   public_elb_sec_group = ["${module.sec-group.public_elb_sec_group}"]
##   bastion_host_ssh_sec_group = "${module.sec-group.bastion_host_ssh}"
##   elb_suffix = "cfgmt"
## }

module "internal" {
  source = "modules/asg"

  vpc_id = "${module.vpc.id}"
  subnet_ids = ["${module.vpc.private_network_ids}"]
  elb_subnets = ["${module.vpc.public_network_ids}"]
  sg_web = "${module.sec-group.sg_web}"

  min_instances_size = 4
  max_instances_size = 4
  # server_port = 8080
  # public_elb_sec_group = ["${module.sec-group.public_elb_sec_group}", "${module.sec-group.sg_default}"]
  public_elb_sec_group = ["${module.sec-group.public_elb_sec_group}"]
  bastion_host_ssh_sec_group = "${module.sec-group.bastion_host_ssh}"
  elb_suffix = "internal"
}

module "sec-group" {
  source = "modules/sec_group"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_ids}"
  allowed_network = "${var.allowed_network}"
}


# module "wordpress_db" {
#   source = "modules/postgres_rds"
# 
#   vpc_id = "${module.vpc.id}"
# }
