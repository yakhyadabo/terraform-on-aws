output "vpc_id" {
  value = "${module.vpc.id}"
}

output "gateway_id" {
  value = "${module.vpc.gateway}"
}
