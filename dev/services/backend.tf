terraform {
  backend "s3" {
    bucket  = "terraform-remote-state-zeta-dev"
    key     = "dev/services.tfstate"
    region  = "us-west-2"
    encrypt = "true"
  }
}
