resource "aws_eip" "lb" {
  instance = "${aws_instance.controller.id}"
  vpc      = true
}

