provider "aws" {
  region = "${var.region}"
}

module "iam-user" {
  source     = "../../../modules/iam"

}
