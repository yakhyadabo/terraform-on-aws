##
# Remote state of VPC
##
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "terraform-remote-state-zeta"
        key = "vpc/terraform.tfstate"
        region = "${var.region}"
    }
}

/* Security group for the web */
resource "aws_security_group" "cfgmt_web" {
  name = "cfgmt_web"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

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
    Name = "web-airpair-example" 
  }
}

# Nat SG : 
resource "aws_security_group" "cfgmt_nat" {
    name = "cfgmt_nat"
    description = "Config management ....."
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"


  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["10.0.201.0/24"]
  }

  ingress {
    from_port = 1194
    to_port   = 1194
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags { 
    Name = "nat-airpair-example" 
  }
}

resource "aws_instance" "cfgmt" {
    connection {
        user = "centos"
        key_file = "${var.key_path}"
    }
    ami = "${lookup(var.centos7_amis, var.region)}"
    instance_type = "t2.micro"
    user_data = "${file("cloud-config/app.yml")}"
   # user_data = <<-EOF
   #           #!/bin/bash -v
   #           sudo yum install epel-release
   #           sudo yum install ansible > /tmp/ansible.log
   #           EOF
    count = 1
    key_name = "${var.key_name}"
    security_groups = [
       # "${data.terraform_remote_state.vpc.bastion_sg}",
        "${aws_security_group.cfgmt_nat.id}",
        "${aws_security_group.cfgmt_web.id}"
    ]
    subnet_id =  "${data.terraform_remote_state.vpc.public_network_id}"
    private_ip = "10.0.0.10"
    tags = {
        Name = "cfgmt"
        subnet = "public"
        role = "dns"
        environment = "test"
    }

}
