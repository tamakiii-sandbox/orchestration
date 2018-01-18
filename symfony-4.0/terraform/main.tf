resource "aws_vpc" "main" {
  cidr_block = "${var.CIDR_BLOCK}"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags {
    Name = "${var.name}"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_security_group_rule" "default_ingress" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  security_group_id = "${aws_default_security_group.default.id}"
}

resource "aws_security_group_rule" "default_egress" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  security_group_id = "${aws_default_security_group.default.id}"
}

resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_a"]}"
  availability_zone = "${var.AWS_AZ_ALPHA}"

  tags {
    Name = "${var.name}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_c"]}"
  availability_zone = "${var.AWS_AZ_CHARLIE}"

  tags {
    Name = "${var.name}-public-c"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public_a" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_a.id}"
}

resource "aws_route_table_association" "public_c" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_c.id}"
}
