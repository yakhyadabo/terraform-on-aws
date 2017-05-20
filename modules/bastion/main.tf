##
# Create a bastion host to allow SSH in to the test network.
# Connections are only allowed from ${var.allowed_network}
# This box also acts as a NAT for the private network
##

resource "aws_security_group" "bastion" {
    name = "bastion"
    description = "Allow access from allowed_network to SSH/Consul, and NAT internal traffic"
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

    # SSH
    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.allowed_network}" ]
        self = false
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.allowed_network}" ]
    }

#    # Consul
#    ingress = {
#        from_port = 8500
#        to_port = 8500
#        protocol = "tcp"
#        cidr_blocks = [ "${var.allowed_network}" ]
#        self = false
#    }

    # NAT
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [
            "${aws_subnet.public.cidr_block}",
            "${aws_subnet.private.cidr_block}"
        ]
        self = false
    }
}

resource "aws_security_group" "allow_bastion" {
    name = "allow_bastion_ssh"
    description = "Allow access from bastion host"
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
        self = false
    }
}

resource "aws_instance" "bastion" {
    connection {
        user = "ec2-user"
        key_file = "${var.key_path}"
    }
    ami = "${lookup(var.amazon_nat_amis, var.region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    security_groups = [
        "${aws_security_group.bastion.id}"
    ]
    subnet_id = "${aws_subnet.dmz.id}"
    associate_public_ip_address = true
    source_dest_check = false
#   user_data = "${file(\"files/bastion/cloud-init.txt\")}"
    tags = {
        Name = "bastion"
        subnet = "dmz"
        role = "bastion"
        environment = "test"
    }
}
