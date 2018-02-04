output "vpc_id" {
  value = "${module.vpc.id}"
}

output "bastion_ip" {
  value = "${module.vpc.bastion_ip}"
}

output "gateway_id" {
  value = "${module.vpc.gateway}"
}

output "private_network_ids" {
  value = "${module.vpc.private_network_ids}"
}

output "public_network_ids" {
  value = "${module.vpc.public_network_ids}"
}
