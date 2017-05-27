output "id" {
  value = "${aws_vpc.test.id}"
}

output "gateway" {
  value = "${aws_internet_gateway.gateway.id}"
}

output "bastion" {
    value = "${aws_instance.bastion.public_ip}"
}
