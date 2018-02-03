resource "aws_launch_configuration" "cfgmt" {
  connection {
    user        = "centos"
    private_key = "${var.key_path}"
  }

  key_name        = "${var.key_name}"
  image_id        = "${lookup(var.centos7_amis, var.region)}"
  instance_type   = "t2.micro"
  user_data       = "${file("cloud-config/app.yml")}"
  security_groups = ["${var.bastion_host_ssh_sec_group}", "${var.sg_web}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cfgmt" {
  launch_configuration = "${aws_launch_configuration.cfgmt.id}"

  #_load_balancers = ["${aws_elb.cfgmt.name}"]
  target_group_arns = ["${aws_lb_target_group.web_server.arn}"]

  # vpc_zone_identifier = ["${var.elb_subnets}"]
  vpc_zone_identifier = ["${var.subnet_ids}"]
  min_size            = "${var.min_instances_size}"
  max_size            = "${var.max_instances_size}"

  tag {
    key                 = "Name"
    value               = "terraform-asg-cfgmt"
    propagate_at_launch = true
  }
}

resource "aws_lb" "web_server" {
  security_groups = ["${var.public_elb_sec_group}"]
  subnets         = ["${var.elb_subnets}"]

  tags = {
    Name      = "Load Balancer"
    Terraform = true
  }
}

resource "aws_lb_target_group" "web_server" {
  # port = 80
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

# resource "aws_elb" "cfgmt" {
#   name = "terraform-asg-${var.elb_suffix}"
#   security_groups = ["${var.public_elb_sec_group}"]
#   # subnets = ["${var.subnet_id}"]
#   subnets = ["${var.elb_subnets}"]
#   # availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
# 
#   health_check {
#     healthy_threshold = 5
#     unhealthy_threshold = 10
#     timeout = 5
#     interval = 40
#     target = "HTTP:${var.server_port}/"
#   }
# 
#   listener {
#     lb_port = 80
#     lb_protocol = "http"
# 
#     instance_port = "${var.server_port}"
#     instance_protocol = "http"
#   }
# 
#   ## listener {
#   ##   lb_port = 443
#   ##   lb_protocol = "https"
#   ##   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
# 
#   ##   instance_port = "${var.server_port}"
#   ##   instance_protocol = "http"
#   ## }
# }

