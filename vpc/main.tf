module "vpc" {
  source = "../modules/vpc"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
