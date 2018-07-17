provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "terraform-remote-state-zeta-dev"
    key    = "dev/vpc.tfstate"
    region = "us-west-2"
  }
}

module "eks" {
  source          = "../../modules/eks"

  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids  = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
}
