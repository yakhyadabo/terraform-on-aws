##
# VPC
##
resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.test.id}"
}
