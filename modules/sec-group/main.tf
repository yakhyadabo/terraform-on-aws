/* Default security group */
resource "aws_security_group" "default" {
  name = "default-sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${var.vpc_id}"

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

resource "aws_security_group" "public_elb" {
  name = "terraform-cfgmt-elb"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nat" {
  name = "nat-sg"
  description = "Allow access from allowed_network to SSH/Consul, and NAT internal traffic"
  vpc_id = "${var.vpc_id}"

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
  vpc_id = "${var.vpc_id}"

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
