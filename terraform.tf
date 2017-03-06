provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "bastion" {
  ami = "ami-2d39803a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

 tags {
    Name = "bastion"
  }
}


resource "aws_security_group" "bastion" {
  name = "terraform-bastion-sg"
  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}


variable "ssh_port" {
  description = "The port the server will use for HTTP requests"
  default = 22

}

output "bastion_ip" {
    value = "${aws_instance.bastion.public_ip}"
}
