resource "aws_route53_zone" "main" {
  name    = "zeta.com"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route53_record" "main-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "zeta.com"
  type    = "NS"
  ttl     = 30

  records = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]

  depends_on = ["aws_route53_zone.main"]
}
