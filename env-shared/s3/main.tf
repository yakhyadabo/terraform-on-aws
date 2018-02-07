provider "aws" {
  region = "${var.region}"
}

# create an s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucket_name}-dev"
  force_destroy = "true"

  versioning {
    enabled = "${var.versioning}"
  }

  tags {
    application   = "${var.application}"
    environment   = "${var.environment}"
  }
}
