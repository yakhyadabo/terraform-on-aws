provider "aws" {
  region = "${var.region}"
}

module "iam_user" {
  source = "../../modules/iam"

  pgp_key = "keybase:yakhyadabo"

  password_reset_required = true

  password_length = "12"
}
