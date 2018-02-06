variable "access_key" {
  description = "AWS access key."
}

variable "secret_key" {
  description = "AWS secret key."
}

variable "region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}
