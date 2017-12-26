resource "aws_security_group" "main" {
  vpc_id = "${aws_vpc.lab.id}"
  name = "lab-sg"

  ingress {
    protocol = "tcp"
    from_port = "80"
    to_port = "80"
  }

  ingress {
    protocol = "tcp"
    from_port = "443"
    to_port = "443"
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "lab-sg-main"
  }
}
