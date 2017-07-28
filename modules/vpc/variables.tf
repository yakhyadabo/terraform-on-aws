variable "allowed_network" {
    description = "The CIDR of network that is allowed to access the bastion host"
}

variable "region" {
    description = "The AWS region to create things in."
    default = "us-west-2"
}

variable "key_name" {
    description = "Name of the keypair to use in EC2."
    default = "terraform"
}

variable "key_path" {
    description = "Path to your private key."
    default = "~/.ssh/id_rsa"
}

variable "amazon_nat_amis" {
    description = "Amazon Linux NAT AMIs"
    default = {
        us-west-2 = "ami-bb69128b"
    }
}
