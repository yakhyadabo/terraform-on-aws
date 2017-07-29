/* Default security group */
resource "aws_security_group" "default" {
    name = "default-sg"
    description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
    vpc_id = "${aws_vpc.test.id}"

    ingress {
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      self        = true
    }
   
    egress {
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      self        = true
    }
    
    tags { 
      Name = "default-sg" 
    }
}

resource "aws_security_group" "nat" {
    name = "nat-sg"
    description = "Allow access from allowed_network to SSH/Consul, and NAT internal traffic"
    vpc_id = "${aws_vpc.test.id}"

    # SSH
    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.allowed_network}"]
        self = false
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.allowed_network}"]
    }

    ingress {
      from_port = 1194
      to_port   = 1194
      protocol  = "udp"
      cidr_blocks = ["${var.allowed_network}"]
    }

    egress {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["${var.allowed_network}"]
    }

    egress {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = ["${var.allowed_network}"]
    }

    tags { 
      Name = "nat-sg" 
    }

}

/* Security group for the web */
resource "aws_security_group" "web" {
  name = "web-sg"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.test.id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  tags { 
    Name = "web-sg" 
  }
}

resource "aws_instance" "bastion" {
    connection {
        user = "ec2-user"
    }
    ami = "${lookup(var.centos7_amis, var.region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    security_groups = [
        "${aws_security_group.default.id}",
        "${aws_security_group.nat.id}"
    ]
    subnet_id = "${aws_subnet.dmz.id}"
    # associate_public_ip_address = true

# source_dest_check - (Optional) Controls if traffic is routed to the instance when the destination address does not match 
# the instance. Used for NAT or VPNs. Defaults true.

    source_dest_check = false
#   user_data = "${file(\"files/bastion/cloud-init.txt\")}"
    tags = {
        Name = "bastion"
        subnet = "dmz"
        role = "bastion"
        environment = "test"
    }

# provisioner "remote-exec" {
#    inline = [
#      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
#      "echo 1 > /proc/sys/net/ipv4/conf/all/forwarding",
#      /* Install docker */ 
#      "curl -sSL https://get.docker.com/ubuntu/ | sudo sh",
# #     /* Initialize open vpn data container */
# #     "sudo mkdir -p /etc/openvpn",
# #     "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
# #     /* Generate OpenVPN server config */
# #     "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr} -u udp://${aws_instance.nat.public_ip}"
#    ]
#  }
}

