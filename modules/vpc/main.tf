##
# VPC
##
resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_vpc_endpoint" "private-s3" {
    vpc_id = "${aws_vpc.test.id}"
    route_table_ids = ["${aws_route_table.public.id}"]
    service_name = "com.amazonaws.us-west-2.s3"
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
    vpc_id = "${aws_vpc.test.id}"
    cidr_block = "10.0.201.0/24"
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
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}

##
# Public
##

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.test.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    # availability_zone = "us-west-2a"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.test.id}"
    route {
        cidr_block = "0.0.0.0/0"
        # instance_id = "${aws_instance.bastion.id}"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

##
# Private
##

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.test.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    # availability_zone = "us-west-2a"
}

## resource "aws_route_table" "private" {
##     vpc_id = "${aws_vpc.test.id}"
##     route {
##         cidr_block = "0.0.0.0/0"
##         instance_id = "${aws_instance.bastion.id}"
##     }
## }

resource "aws_eip" "nat_eip" {
  # count    = "${length(split(",", var.public_ranges))}"
  count    = "${length(split(",", "10.0.0.0/24"))}"
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  # count = "${length(split(",", var.public_ranges))}"
  count = "${length(split(",", "10.0.0.0/24"))}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.gateway"]
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}


# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.test.id}"
  # count = "${length(compact(split(",", var.private_ranges)))}"
  count = "${length(compact(split(",", "10.0.1.0/24")))}"
 # tags { 
 #   Name = "${var.env}_private_subnet_route_table_${count.index}"
 # }
}

# add a nat gateway to each private subnet's route table
resource "aws_route" "private_nat_gateway_route" {
  # count = "${length(compact(split(",", var.private_ranges)))}"
  count = "${length(compact(split(",", "10.0.1.0/24")))}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on = ["aws_route_table.private"]
  nat_gateway_id = "${element(aws_nat_gateway.nat_gw.*.id, count.index)}"
}
