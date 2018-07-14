variable "region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "vpc_id" {
  default     = "vpc-XXXXXXXX"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "subnet_ids" {
  description = "Ids of the sunbets used to run the worker nodes"
  type        = "list"
}
