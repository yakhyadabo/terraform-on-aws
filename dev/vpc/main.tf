provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source   = "../../modules/vpc"
  key_path = "${var.key_path}"

  #  access_key = "${var.access_key}" 
  #  secret_key = "${var.secret_key}"
  allowed_network = "${var.allowed_network}"
}
