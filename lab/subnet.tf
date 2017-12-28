resource "aws_subnet" "a" {
  vpc_id = "${aws_vpc.lab.id}"
  availability_zone = "${var.az["a"]}"
  cidr_block = "${var.subnet_cidr["a"]}"

  tags {
    Name = "lab-subnet-a"
  }

  depends_on = ["aws_vpc.lab"]
}

resource "aws_subnet" "c" {
  vpc_id = "${aws_vpc.lab.id}"
  availability_zone = "${var.az["c"]}"
  cidr_block = "${var.subnet_cidr["c"]}"

  tags {
    Name = "lab-subnet-c"
  }

  depends_on = ["aws_vpc.lab"]
}
