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
