resource "aws_route_table_association" "a" {
  subnet_id = "${aws_subnet.a.id}"
  route_table_id = "${aws_route_table.public.id}"

  depends_on = ["aws_subnet.a", "aws_route_table.public"]
}

resource "aws_route_table_association" "c" {
  subnet_id = "${aws_subnet.c.id}"
  route_table_id = "${aws_route_table.public.id}"

  depends_on = ["aws_subnet.c", "aws_route_table.public"]
}
