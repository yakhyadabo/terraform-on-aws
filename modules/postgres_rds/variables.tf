variable "vpc_id" {  
  default = "vpc-XXXXXXXX"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "private-db1_cidr" {
  default     = "10.0.11.0/24"
  description = "Your AZ"
}

variable "private-db2_cidr" {
  default     = "10.0.12.0/24"
  description = "Your AZ"
}

variable "az_1" {
  default     = "us-west-2a"
  description = "Your Az1, use AWS CLI to find your account specific"
}

variable "az_2" {
  default     = "us-west-2b"
  description = "Your Az2, use AWS CLI to find your account specific"
}


# variable "subnets_ids" {  
#   type = "list"
#   description = "The public subnets of our RDS VPC rds-vpc."
# }

# variable "rds_public_private-dbgroup" {  
#   default = "default-vpc-XXXXXXXX"
#   description = "Apparently the group name, according to the RDS launch wizard."
# }
