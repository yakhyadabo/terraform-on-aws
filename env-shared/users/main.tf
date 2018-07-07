provider "aws" {
  region = "${var.region}"
}

module "iam_user" {
  source = "../../modules/iam"

  pgp_key = "keybase:test"

  password_reset_required = false
}
