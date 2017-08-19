resource "aws_launch_configuration" "cfgmt" {
    connection {
        user = "centos"
        key_file = "${var.key_path}"
    }

    key_name = "${var.key_name}"
    image_id = "${lookup(var.centos7_amis, var.region)}"
    instance_type = "t2.micro"
    user_data = "${file("cloud-config/app.yml")}"
    security_groups = [ "${var.bastion_host_ssh_sec_group}", "${var.sg_web}" ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "cfgmt" {
  launch_configuration = "${aws_launch_configuration.cfgmt.id}"
  load_balancers = ["${aws_elb.cfgmt.name}"]
  vpc_zone_identifier = ["${var.subnet_id}"]
  min_size = "${var.min_instances_size}"
  max_size = "${var.max_instances_size}"
  tag {
    key = "Name"
    value = "terraform-asg-cfgmt"
    propagate_at_launch = true
  }
}

resource "aws_elb" "cfgmt" {
  name = "terraform-asg-cfgmt"
  security_groups = ["${var.public_elb_sec_group}"]
  subnets = ["${var.subnet_id}"]
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}
