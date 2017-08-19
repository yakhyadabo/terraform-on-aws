output "vpc_id" {
  value = "${module.vpc.id}"
}

output "bastion_ip" {
    value = "${module.vpc.bastion_ip}"
}

# output "bastion_sg" {
#     value = "${module.vpc.bastion_sg}"
# }

output "gateway_id" {
  value = "${module.vpc.gateway}"
}

output "private_network_id" {
  value = "${module.vpc.private_network_id}"
}

output "public_network_id" {
  value = "${module.vpc.public_network_id}"
}

output "public_elb_sec_group" {
  value = "${module.sec-group.public_elb_sec_group}"
}

output "bastion_host_ssh" {
  value = "${module.sec-group.bastion_host_ssh}"
}

