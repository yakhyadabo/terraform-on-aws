variable "vpc_id" {
  default     = "vpc-XXXXXXXX"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "subnet_ids" {
  description = "Ids of the sunbets"
  type        = "list"
}

variable "zone_id" {
  description = "Zone ID of Route53"
}
