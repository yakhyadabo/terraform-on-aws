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

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket = "terraform-remote-state-zeta-dev"
    key    = "dev/dns.tfstate"
    region = "us-west-2"
  }
}

module "wordpress_db" {
  source     = "../../../modules/mysql_rds"
  vpc_id     = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
  zone_id    = "${data.terraform_remote_state.dns.zone_id}"
}
