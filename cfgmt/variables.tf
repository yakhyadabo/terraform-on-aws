# variable "access_key" {
#     description = "AWS access key."
# 
# }
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
