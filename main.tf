module "vpc" {
  source = "modules/vpc"
  key_path = "${var.key_path}"
#  access_key = "${var.access_key}" 
#  secret_key = "${var.secret_key}"
  allowed_network = "${var.allowed_network}"

#  vpc_cidr = "${var.vpc_cidr}"
}

module "cfgmt" {
  source = "modules/cfgmt"
  # Wait for resources and associations to be created
  # depends_on = [
  #     #"${data.terraform_remote_state.vpc.vpc_id}"
  #      "${aws_vpc.test.id}"
  #     # "${aws_alb_target_group.app.arn}"
  # ]
  depends_on = ["${module.vpc.id}"]
  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.vpc.public_network_id}"
}
