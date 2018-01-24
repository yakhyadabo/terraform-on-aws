resource "aws_db_instance" "wordpress" {  
  name                     = "wordpress"
  identifier               = "wordpress"
  username                 = "wordpress"
  password                 = "badpassword"
  port                     = 5432
  allocated_storage        = 256 # gigabytes
  db_subnet_group_name     = "${aws_db_subnet_group.wordpress-pgsql.id}"
  backup_retention_period  = 7   # in days
  engine                   = "postgres"
  engine_version           = "9.5.4"
  instance_class           = "db.r3.large"
  multi_az                 = false
  #  parameter_group_name     = "mydbparamgroup1" # if you have tuned it
  publicly_accessible      = false
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
}

resource "aws_security_group" "mydb1" {  
  name = "mydb1"
  
  description = "RDS postgres servers (terraform-managed)"
  vpc_id = "${var.vpc_id}"
  
  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "wordpress-pgsql" {
  name = "wordpress-pgsql"
  subnet_ids = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnet_1_cidr}"
  availability_zone = "${var.az_1}"

  tags {
    Name = "main_subnet1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnet_2_cidr}"
  availability_zone = "${var.az_2}"

  tags {
    Name = "main_subnet2"
  }
}
