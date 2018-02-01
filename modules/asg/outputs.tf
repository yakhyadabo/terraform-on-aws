# output "cfgmt_dns_name" {
#   value = "${aws_elb.cfgmt.dns_name}"
# }

output "lb_dns_name" {
  value = "${aws_lb.web_server.dns_name}"
}
