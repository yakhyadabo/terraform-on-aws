resource "aws_db_instance" "postgres" {
  name                    = "postgres"
  identifier              = "postgres"
  username                = "postgres"
  password                = "password"
  port                    = 5432
  allocated_storage       = 256                                         # gigabytes
  db_subnet_group_name    = "${aws_db_subnet_group.postgres-pgsql.id}"
  backup_retention_period = 7                                           # in days
  engine                  = "postgres"
  engine_version          = "9.5.4"
  instance_class          = "db.r3.large"
  multi_az                = false

  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true                               # you should always do this
  storage_type           = "gp2"
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
}

resource "aws_route53_record" "postgres-db" {
  zone_id = "${var.zone_id}"
  name    = "app.db.zeta.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.postgres.address}"]
}

resource "aws_security_group" "postgres" {
  name = "postgres"
  vpc_id = "${var.vpc_id}"
  description = "RDS postgres servers (terraform-managed)"

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { ## TODO : Remove
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

resource "aws_db_subnet_group" "postgres-pgsql" {
  name       = "postgres-pgsql"
  subnet_ids = ["${var.subnet_ids}"]
}
