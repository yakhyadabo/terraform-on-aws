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
# Remote state of Bastion
##
data "terraform_remote_state" "bastion" {
    backend = "s3"
    config {
        bucket = "terraform-remote-state-for-bastion"
        key = "bastion/terraform.tfstate"
        region = "us-west-2"
    }
}

##
# Private
##

resource "aws_subnet" "private" {
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    cidr_block = "10.0.1.0/24"
}

resource "aws_route_table" "private" {
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${data.terraform_remote_state.bastion.bastion_id}"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
