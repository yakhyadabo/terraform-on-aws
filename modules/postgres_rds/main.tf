data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "terraform-remote-state-zeta-dev"
    key = "dev/vpc.tfstate"    
    region = "us-west-2"
  }
}

resource "aws_db_instance" "wordpress" {
  name                    = "wordpress"
  identifier              = "wordpress"
  username                = "wordpress"
  password                = "badpassword"
  port                    = 5432
  allocated_storage       = 256                                         # gigabytes
  db_subnet_group_name    = "${aws_db_subnet_group.wordpress-pgsql.id}"
  backup_retention_period = 7                                           # in days
  engine                  = "postgres"
  engine_version          = "9.5.4"
  instance_class          = "db.r3.large"
  multi_az                = false

  #  parameter_group_name     = "mydbparamgroup1" # if you have tuned it
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true                               # you should always do this
  storage_type           = "gp2"
  vpc_security_group_ids = ["${aws_security_group.mydb1.id}"]
}

resource "aws_route53_zone" "internal" {
  name   = "internal.com"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_route53_record" "internal-ns" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "internal.com"
  type    = "NS"
  ttl     = 30

  records = [
    "${aws_route53_zone.internal.name_servers.0}",
    "${aws_route53_zone.internal.name_servers.1}",
    "${aws_route53_zone.internal.name_servers.2}",
    "${aws_route53_zone.internal.name_servers.3}",
  ]

  depends_on = ["aws_route53_zone.internal"]
}

resource "aws_route53_record" "wordpress-db" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "db.internal.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.wordpress.address}"]
}

resource "aws_security_group" "mydb1" {
  name = "mydb1"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "RDS postgres servers (terraform-managed)"

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.201.0/24"] ## Bation host IP
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "wordpress-pgsql" {
  name       = "wordpress-pgsql"
  subnet_ids = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
}
