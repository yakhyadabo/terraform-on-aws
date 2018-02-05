data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "terraform-remote-state-zeta-dev"
    key = "dev/vpc.tfstate"    
    region = "us-west-2"
  }
}

resource "aws_launch_configuration" "cfgmt" {
  connection {
    user        = "centos"
    private_key = "${var.key_path}"
  }

  key_name        = "${var.key_name}"
  image_id        = "${lookup(var.centos7_amis, var.region)}"
  instance_type   = "t2.micro"
  user_data       = "${file("${path.module}/cloud-config/app.yml")}"
  security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.web.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cfgmt" {
  launch_configuration = "${aws_launch_configuration.cfgmt.id}"

  target_group_arns = ["${aws_lb_target_group.web_server.arn}"]

  vpc_zone_identifier   = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
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
  subnets         = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]

  tags = {
    Name      = "Load Balancer"
    Terraform = true
  }
}

resource "aws_lb_target_group" "web_server" {
  port     = "${var.server_port}"
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

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
