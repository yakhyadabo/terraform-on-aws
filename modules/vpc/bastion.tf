resource "aws_instance" "bastion" {
  count     = "${var.az_count}"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"

  connection {
    user        = "centos"
    private_key = "${var.key_path}"
  }

  ami      = "${data.aws_ami.centos7.id}"

  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.bastion.id}",
  ]

  # source_dest_check - (Optional) Controls if traffic is routed to the instance when the destination address does not match 
  # the instance. Used for NAT or VPNs. Defaults true.

  source_dest_check = false
  tags = {
    Name        = "bastion"
    subnet      = "dmz"
    role        = "bastion"
    environment = "test"
  }
}

data "aws_ami" "centos7" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
