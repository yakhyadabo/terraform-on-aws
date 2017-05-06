resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-remote-state-for-bastion"
  
  versioning {
    enabled = true
  }
  
  lifecycle {
    prevent_destroy = true
  }

}
