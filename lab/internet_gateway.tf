resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.lab.id}"

  tags {
    Name = "lab-igw"
  }

  depends_on = ["aws_vpc.lab"]
}
