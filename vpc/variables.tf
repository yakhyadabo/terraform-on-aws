# variable "access_key" {
#     description = "AWS access key."
# }
# 
# variable "secret_key" {
#     description = "AWS secret key."
# }
# 
variable "allowed_network" {
    description = "The CIDR of network that is allowed to access the bastion host"
}

variable "key_path" {
    description = "Path to your private key."
    default = "~/.ssh/id_rsa"
}
