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
  source = "modules/cfgmt"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
  sg_web = "${module.sec-group.sg_web}"
}

module "sec-group" {
  source = "modules/sec-group"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
  allowed_network = "${var.allowed_network}"
}
