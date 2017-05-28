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
variable "amazon_amis" {
    description = "Amazon Linux AMIs"
    default = {
        us-west-2 = "ami-b5a7ea85"
    }
}
