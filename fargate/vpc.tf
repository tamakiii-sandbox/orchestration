resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.name}"
    Group = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
    Group = "${var.name}"
  }
}

resource "aws_subnet" "public_alpha" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${ lookup(var.subnet_cidr_blocks, "alpha") }"
  availability_zone = "${ lookup(var.availability_zones, "alpha") }"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-alpha"
    Group = "${var.name}"
  }
}
resource "aws_subnet" "public_charlie" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${ lookup(var.subnet_cidr_blocks, "charlie") }"
  availability_zone = "${ lookup(var.availability_zones, "charlie") }"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-charlie"
    Group = "${var.name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.name}"
    Group = "${var.name}"
  }
}

resource "aws_route_table_association" "public_alpha" {
  subnet_id = "${aws_subnet.public_alpha.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route_table_association" "public_charlie" {
  subnet_id = "${aws_subnet.public_charlie.id}"
  route_table_id = "${aws_route_table.main.id}"
}
