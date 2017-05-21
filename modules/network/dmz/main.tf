##
# Remote state of VPC
##
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "terraform-remote-state-for-bastion"
        key = "vpc/terraform.tfstate"
        region = "us-west-2"
    }
}

##
# DMZ
##

resource "aws_subnet" "dmz" {
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    cidr_block = "10.0.201.0/24"
}

resource "aws_route_table" "dmz" {
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${data.terraform_remote_state.vpc.gateway_id}"
    }
}

resource "aws_route_table_association" "dmz" {
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}
