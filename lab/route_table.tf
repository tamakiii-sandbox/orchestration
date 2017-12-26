resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.lab.id}"

  tags {
    Name = "lab-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  depends_on = ["aws_internet_gateway.public"]
}
