# Docker installation startup file
data "template_file" "docker_install" {
  template = "${file("${path.module}/script/user_data.sh")}"

  # vars {
  #   # username = "${var.username}"
  #   # password = "${var.password}"
  # }
}

data "aws_ami" "centos7" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_launch_configuration" "cfgmt" {
  connection {
    user        = "centos"
    private_key = "${var.key_path}"
  }

  key_name      = "${var.key_name}"
  image_id      = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
  user_data     = "${data.template_file.docker_install.rendered}"

  security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.web.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cfgmt" {
  launch_configuration = "${aws_launch_configuration.cfgmt.id}"

  target_group_arns = ["${aws_lb_target_group.web_server.arn}"]

  vpc_zone_identifier = ["${var.private_subnet_ids}"]
  min_size            = "${var.min_instances_size}"
  max_size            = "${var.max_instances_size}"

  tag {
    key                 = "Name"
    value               = "terraform-asg-cfgmt"
    propagate_at_launch = true
  }
}

resource "aws_lb" "web_server" {
  security_groups = ["${aws_security_group.lb.id}"]
  subnets         = ["${var.public_subnet_ids}"]

  tags = {
    Name      = "Load Balancer"
    Terraform = true
  }
}

resource "aws_lb_target_group" "web_server" {
  port     = "${var.server_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    Name = "Web Target Group"

    # Name = "${var.name} Web Target Group"
    Terraform = true
  }
}

resource "aws_lb_listener" "web_server" {
  load_balancer_arn = "${aws_lb.web_server.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web_server.arn}"
    type             = "forward"
  }
}
