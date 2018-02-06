terraform {
  backend "s3" {
    bucket  = "terraform-remote-state-zeta-dev"
    key     = "dev/app.tfstate"
    region  = "us-west-2"
    encrypt = "true"
  }
}
