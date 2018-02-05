provider "aws" {
  region = "${var.region}"
}

module "internal" {
  source = "../../modules/asg"
  allowed_network = "${var.allowed_network}"

  min_instances_size = 4
  max_instances_size = 4

  # server_port = 8080
  elb_suffix                 = "internal"
}
