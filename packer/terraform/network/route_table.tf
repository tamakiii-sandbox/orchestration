resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.name}"
  }
}
resource "aws_route_table_association" "alpha" {
  subnet_id = "${aws_subnet.alpha.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "charlie" {
  subnet_id = "${aws_subnet.charlie.id}"
  route_table_id = "${aws_route_table.public.id}"
}
