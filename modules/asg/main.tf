# Nat SG : 
resource "aws_security_group" "cfgmt_nat" {
    name = "cfgmt_nat"
    description = "Config management ....."
    vpc_id = "${var.vpc_id}"

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

resource "aws_launch_configuration" "cfgmt" {
    connection {
        user = "centos"
        key_file = "${var.key_path}"
    }

    key_name = "${var.key_name}"
    image_id = "${lookup(var.centos7_amis, var.region)}"
    instance_type = "t2.micro"
    user_data = "${file("cloud-config/app.yml")}"
    security_groups = [ "${aws_security_group.cfgmt_nat.id}", "${var.sg_web}" ]

    lifecycle {
        create_before_destroy = true
    }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "cfgmt" {
  launch_configuration = "${aws_launch_configuration.cfgmt.id}"
  # availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers = ["${aws_elb.cfgmt.name}"]
  vpc_zone_identifier = ["${var.subnet_id}"]

  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "terraform-asg-cfgmt"
    propagate_at_launch = true
  }
}

resource "aws_elb" "cfgmt" {
  name = "terraform-asg-cfgmt"
  security_groups = ["${var.public_elb_sec_group}"]
  # availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets = ["${var.subnet_id}"]
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
    # target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    # instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}
