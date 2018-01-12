resource "aws_instance" "bastion" {
    connection {
        user = "centos"
        # key_file = "${var.key_path}"
        private_key = "${var.key_path}"
    }
    ami = "${lookup(var.centos7_amis, var.region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    security_groups = [
        "${var.sg_default}",
        "${var.sg_nat}"
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


 provisioner "remote-exec" {
    inline = [
      "echo net.ipv4.ip_forward = 1 | sudo tee -a /etc/sysctl.conf",
      "sudo sysctl -p",
      "sudo yum -y install firewalld",
      "sudo systemctl start firewalld && sudo systemctl enable firewalld",
      "sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o ens160 -j MASQUERADE",
      "sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i ens192 -o ens160 -j ACCEPT",
      "sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i ens160 -o ens192 -m state --state RELATED,ESTABLISHED -j ACCEPT",
      "sudo firewall-cmd --reload"
    ]
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

