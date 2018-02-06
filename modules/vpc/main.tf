data "aws_availability_zones" "available" {}

##
# VPC
##
resource "aws_vpc" "test" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${aws_vpc.test.id}"
  route_table_ids = ["${aws_route_table.public.*.id}"]
  service_name    = "com.amazonaws.us-west-2.s3"

  policy = <<POLICY
  {
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
  }
  POLICY
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.test.id}"
}

##
# DMZ
##

resource "aws_subnet" "dmz" {
  vpc_id                  = "${aws_vpc.test.id}"
  count  = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.test.cidr_block, 8, count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "dmz" {
  vpc_id = "${aws_vpc.test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "dmz" {
  count  = "${var.az_count}"
  # subnet_id      = "${aws_subnet.dmz.id}"
  subnet_id      = "${element(aws_subnet.dmz.*.id, count.index)}"
  route_table_id = "${aws_route_table.dmz.id}"
}

##
# Public
##

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.test.id}"
  count  = "${var.az_count}"

  cidr_block              = "${cidrsubnet(aws_vpc.test.cidr_block, 8, count.index + 2)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

##
# Private
##

resource "aws_subnet" "private" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.test.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.test.cidr_block, 8, count.index + 4)}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
}

resource "aws_eip" "nat_gateway_ip" {
  count = "${var.az_count}"
  vpc   = true

  tags {
    #  Name = "${var.name} NAT Gateway IP"
    Terraform = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = "${var.az_count}"

  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat_gateway_ip.*.id, count.index)}"

  tags {
    Terraform = true

    # Name = "${var.name} NAT Gateway"
  }

  depends_on = ["aws_internet_gateway.gateway"]
}

# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.test.id}"
  count  = "${var.az_count}"

  # tags { 
  #   Name = "${var.env}_private_subnet_route_table_${count.index}"
  # }
  depends_on = ["aws_vpc.test"]
}

resource "aws_route_table_association" "private" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}

# add a nat gateway to each private subnet's route table
resource "aws_route" "private_nat_gateway_route" {
  count                  = "${var.az_count}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gateway.*.id, count.index)}"
}
