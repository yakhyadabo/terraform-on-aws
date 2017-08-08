module "vpc" {
  source = "modules/vpc"
  key_path = "${var.key_path}"
#  access_key = "${var.access_key}" 
#  secret_key = "${var.secret_key}"
  allowed_network = "${var.allowed_network}"
}

module "cfgmt" {
  source = "modules/cfgmt"

  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
}
