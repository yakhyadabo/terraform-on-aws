output "id" {
  value = "${aws_instance.bastion.id}"
}

output "name" {
  value = "${aws_instance.bastion.name}"
}

output "ip" {
  value = "${aws_instance.bastion.public_ip}"
}
