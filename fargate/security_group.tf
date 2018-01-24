resource "aws_default_security_group" "fargate" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-default"
    Group = "${var.name}"
  }
}

resource "aws_security_group" "web" {
  name        = "fargate-web"
  description = "Allow request to Web"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "fargate-web"
  }
}
resource "aws_security_group_rule" "web_ingress_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.web.id}"
}
resource "aws_security_group_rule" "web" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.web.id}"
}
