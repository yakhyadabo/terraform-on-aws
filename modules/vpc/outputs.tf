output "id" {
  value = "${aws_vpc.test.id}"
}

output "gateway" {
  value = "${aws_internet_gateway.gateway.id}"
}

output "bastion_ips" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}

output "bastion_cidrs" {
  value = ["${aws_subnet.dmz.*.cidr_block}"]
}

# output "bastion_sg"{
#   value = "${aws_security_group.bastion.id}"
#   #value = "${aws_security_group.allow_bastion.id}"
# }

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}
