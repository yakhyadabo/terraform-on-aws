variable "bucket_name" {
  description = "Name of the bucket"
}

variable "versioning" {
  description = "Enable versioning"
  default = true
}

variable "environment" {
  description = "Environment"
  default = "DEV"
}

variable "application" {
  description = "Application"
  default = "Zeta Workshop"
}

variable "region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}
