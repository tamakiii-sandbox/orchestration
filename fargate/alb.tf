resource "aws_alb" "main" {
  name     = "main"
  internal = false
  security_groups = [
    "${aws_default_security_group.fargate.id}",
    "${aws_security_group.web.id}"
  ]
  subnets = [
    "${aws_subnet.public_alpha.id}",
    "${aws_subnet.public_charlie.id}"
  ]

  # access_logs {
  #   bucket = "${var.name}"
  #   prefix = "alb"
  # }

  idle_timeout = 400

  tags {
    Name = "main"
    Group = "${var.name}"
  }
}


resource "aws_alb_target_group" "main" {
  name        = "main"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.main.id}"
  target_type = "ip"

  tags {
    Name = "main"
    Group = "${var.name}"
  }
}
resource "aws_alb_listener" "main_http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.main.arn}"
    type             = "forward"
  }
}

resource "aws_cloudwatch_log_group" "fargate" {
  name = "awslogs-${var.name}-nginx-log"
}
