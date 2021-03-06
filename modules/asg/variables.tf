variable "vpc_id" {
  default     = "vpc-XXXXXXXX"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "private_subnet_ids" {
  description = "Ids of the private sunbets used to run ASG"
  type        = "list"
}

variable "public_subnet_ids" {
  description = "Ids of the public sunbets used by the LB"
  type        = "list"
}

variable "bastion_cidrs" {
  description = "Cidrs of the bastion hosts"
  type        = "list"
}

# variable "access_key" {
#     description = "AWS access key."
# }
# 
# variable "secret_key" {
#     description = "AWS secret key."
# }

variable "region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

variable "key_name" {
  description = "Name of the keypair to use in EC2."
  default     = "terraform"
}

# variable "key_path" {
#     description = "Path to your private key."
#     default = "~/.ssh/id_rsa"
# }
# 

variable "allowed_network" {
  description = "The CIDR of network that is allowed to access the bastion host"
}

variable "elb_suffix" {
  description = "ELB Suffix"
}

variable "min_instances_size" {
  description = "minimum running instances"
  default     = "3"
}

variable "max_instances_size" {
  description = "maximum running instances"
  default     = "3"
}

variable "server_port" {
  description = "Port exposed by ELB"
  default     = "8080"
}
