variable "allowed_network" {
  description = "The CIDR of network that is allowed to access the bastion host"
}

variable "region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "key_name" {
  description = "Name of the keypair to use in EC2."
  default     = "terraform"
}

variable "key_path" {
  description = "Path to your private key."
  default     = "~/.ssh/id_rsa"
}

## variable "sg_default" {
##   description = "Default Security Group"
## }
## 
## variable "sg_nat" {
##   description = "Nat Security Group"
## }

