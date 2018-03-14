resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = "0"
    to_port = "0"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Name = "${var.name}"
  }
}
resource "aws_security_group" "ecs" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${var.name}-ecs"
  description = "ECS Allowed Ports"

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-ecs"
  }
}
// resource "aws_security_group_rule" "ecs_dinamic_ports" {
//   security_group_id = "${aws_security_group.ecs.id}"
//   type = "ingress"
//   protocol = "tcp"
//   from_port = 0
//   to_port = 65535
//   source_security_group_id = "${aws_security_group.alb.id}"
// }
// resource "aws_security_group" "alb" {
//   vpc_id = "${aws_vpc.main.id}"
//   name = "${var.name}-alb"
//   description = "ALB security group"
//
//   ingress {
//     protocol = "tcp"
//     from_port = 80
//     to_port = 80
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//
//   egress {
//     protocol = -1
//     from_port = 0
//     to_port = 0
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//
//   tags {
//     Name = "${var.name}-alb"
//   }
// }
