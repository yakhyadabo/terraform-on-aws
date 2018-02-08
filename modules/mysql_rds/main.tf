resource "aws_db_instance" "mysql" {
  name                    = "wordpress"
  identifier              = "wordpress"
  username                = "wordpress"
  password                = "password"
  port                    = 3306
  allocated_storage       = 10                                # gigabytes
  db_subnet_group_name    = "${aws_db_subnet_group.mysql.id}"
  backup_retention_period = 7                                 # in days
  engine                  = "mysql"
  engine_version          = "5.7.19"
  instance_class          = "db.r3.large"
  multi_az                = false

  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true                               # you should always do this
  storage_type           = "gp2"
  vpc_security_group_ids = ["${aws_security_group.mysql.id}"]
}

resource "aws_route53_record" "mysql-db" {
  zone_id = "${var.zone_id}"
  name    = "wordpress.db.zeta.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.mysql.address}"]
}

resource "aws_security_group" "mysql" {
  name        = "wordpress"
  vpc_id      = "${var.vpc_id}"
  description = "RDS mysql servers (terraform-managed)"

  # Only mysql in
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "wordpress"
  subnet_ids = ["${var.subnet_ids}"]
}
