provider "aws" {
  region = "${var.region}"
}

module "wordpress_db" {
  source = "../../modules/postgres_rds"
}

