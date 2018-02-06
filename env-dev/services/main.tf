provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "terraform-remote-state-zeta-dev"
    key = "dev/vpc.tfstate"    
    region = "us-west-2"
  }
}

module "internal" {
  source = "../../modules/asg"
  allowed_network = "${var.allowed_network}"

  min_instances_size = 4
  max_instances_size = 4

  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  private_subnet_ids = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
  public_subnet_ids = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
  bastion_cidrs = ["${data.terraform_remote_state.vpc.bastion_cidrs}"]

  # server_port = 8080
  elb_suffix                 = "internal"
}
