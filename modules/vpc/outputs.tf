output "id" {
  value = "${aws_vpc.test.id}"
}

output "gateway" {
  value = "${aws_internet_gateway.gateway.id}"
}
