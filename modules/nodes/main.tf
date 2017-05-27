# Create a bastion host to allow SSH in to the test network.
# Connections are only allowed from ${var.allowed_network}
# This box also acts as a NAT for the private network
##

##
# Remote state of VPC
##
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "terraform-remote-state-for-bastion"
        key = "vpc/terraform.tfstate"
        region = "us-west-2"
    }
}

resource "aws_security_group" "node" {
    name = "node"
    description = "node ....."
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

    ingress {
        from_port = 53
        to_port = 53
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 53
        to_port = 53
        protocol = "udp"
        self = true
    }
    ingress {
        from_port = 8300
        to_port = 8302
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 8301
        to_port = 8302
        protocol = "udp"
        self = true
    }
    ingress {
        from_port = 8400
        to_port = 8400
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 8500
        to_port = 8500
        protocol = "tcp"
        self = true
    }
}

resource "aws_instance" "node" {
    connection {
        user = "ec2-user"
        key_file = "${var.key_path}"
    }
    ami = "${lookup(var.amazon_amis, var.region)}"
    instance_type = "t2.micro"
    count = 3
    key_name = "${var.key_name}"
    security_groups = [
        "${data.terraform_remote_state.vpc.bastion_sg}",
        "${aws_security_group.node.id}"
    ]
    subnet_id =  "${data.terraform_remote_state.vpc.private_network_id}"
    private_ip = "10.0.1.1${count.index}"
    tags = {
        Name = "node-${count.index}"
        subnet = "private"
        role = "dns"
        environment = "test"
    }
#    user_data = "${file(\"files/consul/cloud-init.txt\")}"
}
