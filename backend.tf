terraform {
  backend "s3" {
   bucket = "terraform-remote-state-zeta"
   key = "dev/terraform.tfstate"
   region = "us-west-2"
   encrypt = "true"
 }
}
