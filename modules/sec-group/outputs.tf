output "sg_default" {
  value = "${aws_security_group.default.id}"
}

output "sg_nat" {
  value = "${aws_security_group.nat.id}"
}

output "sg_web" {
  value = "${aws_security_group.web.id}"
}

output "public_elb_sec_group" {
  value = "${aws_security_group.public_elb.id}"
}
