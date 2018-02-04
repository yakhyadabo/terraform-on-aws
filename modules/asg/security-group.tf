resource "aws_security_group" "lb" {
  name   = "terraform-cfgmt-elb"
  vpc_id = "${data.terraform_remote_state.vpc.id}"

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

# Bation SG : 
resource "aws_security_group" "ssh" {
  name        = "bastion_host_ssh"
  description = "Security Group that alows SSH from bastion host"
  vpc_id = "${data.terraform_remote_state.vpc.id}"

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
  vpc_id = "${data.terraform_remote_state.vpc.id}"

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
