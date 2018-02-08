/* Default security group */
resource "aws_security_group" "default" {
  name        = "default-sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${aws_vpc.test.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags {
    Name = "default-sg"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow access from allowed_network to SSH and NAT internal traffic"
  vpc_id      = "${aws_vpc.test.id}"

  # SSH
  ingress = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
    self        = false
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  ## ingress { ## OpenVPN
  ##   from_port = 1194
  ##   to_port   = 1194
  ##   protocol  = "udp"
  ##   cidr_blocks = ["${var.allowed_network}"]
  ## }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }
  egress {
    from_port   = 5432          ## Postgres RDS
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }
  tags {
    Name = "nat-sg"
  }
}
