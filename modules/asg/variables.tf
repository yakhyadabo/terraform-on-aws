# variable "access_key" {
#     description = "AWS access key."
# }
# 
# variable "secret_key" {
#     description = "AWS secret key."
# }

variable "region" {
    description = "The AWS region to create things in."
    default = "us-west-2"
}

variable "key_name" {
    description = "Name of the keypair to use in EC2."
    default = "terraform"
}
 
# variable "key_path" {
#     description = "Path to your private key."
#     default = "~/.ssh/id_rsa"
# }
# 

variable "centos7_amis" {
    description = "CentOS 7 AMIs"
    default = {
        us-east-1 = "ami-96a818fe"
        us-west-1 = "ami-6bcfc42e"
        us-west-2 = "ami-0c2aba6c"
        eu-west-1 =  "ami-e4ff5c93"
        ap-southeast-1 = "ami-aea582fc"
        ap-southeast-2 = "ami-bd523087"
        ap-northeast-1 = "ami-89634988"
        sa-east-1 = "ami-bf9520a2"
    }
}

variable "vpc_id" {description =  "VPC ID" }
variable "subnet_id" {description =  "SUBNET ID"}
variable "sg_web" {description =  "Web Security Group"}

variable "min_instances_size" {description = "minimum running instances"}
variable "max_instances_size" {description = "maximum running instances"}

variable "public_elb_sec_group" {description = "Public ELB Security Group" }
variable "bastion_host_ssh_sec_group" {description = "Security Group that allows SSH from bastion host" }
