/* Default security group */
resource "aws_security_group" "default" {
  name        = "default-sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

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

resource "aws_security_group" "public_elb" {
  name   = "terraform-cfgmt-elb"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nat" {
  name        = "nat-sg"
  description = "Allow access from allowed_network to SSH and NAT internal traffic"
  vpc_id      = "${var.vpc_id}"

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

# Bation SG : 
resource "aws_security_group" "bastion_host_ssh" {
  name        = "bastion_host_ssh"
  description = "Security Group that alows SSH from bastion host"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.201.0/24"] ## Bation host IP
  }

  ## ingress { # OpenVPN
  ##   from_port = 1194 
  ##   to_port   = 1194
  ##   protocol  = "udp"
  ##   cidr_blocks = ["0.0.0.0/0"]
  ## }

  egress {
    from_port   = 80            ## Enable curl http
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080                       ## Test connections //TODO Remove
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }
  egress {
    from_port   = 443           ## Enable curl httpS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "nat-airpair-example"
  }
}

/* Security group for the web */
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web that allows web traffic from internet"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8080                       # HTTP
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  ingress {
    from_port   = 443                        ## WEB over SSL (HTTPS)
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  tags {
    Name = "web-sg"
  }
}
