##
# VPC
##
resource "aws_vpc" "test" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.test.id}"
}
