output "sg_default" {
  value = "${aws_security_group.default.id}"
}

output "sg_nat" {
  value = "${aws_security_group.nat.id}"
}

output "sg_web" {
  value = "${aws_security_group.web.id}"
}
