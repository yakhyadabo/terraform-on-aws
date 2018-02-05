output "vpc_id" {
  value = "${module.vpc.id}"
}

output "bastion_ip" {
  value = "${module.vpc.bastion_ip}"
}

output "gateway_id" {
  value = "${module.vpc.gateway}"
}

output "private_subnet_ids" {
  value = "${module.vpc.private_subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.vpc.public_subnet_ids}"
}
