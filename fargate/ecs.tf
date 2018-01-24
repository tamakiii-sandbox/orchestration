resource "aws_ecs_cluster" "fargate" {
  name = "${var.name}"
}

data "template_file" "ecs_task" {
  template = "${ file("template/task_definition.json") }"

  vars {
    name       = "${var.name}"
    aws_region = "${var.region}"
    aws_id     = "${var.aws_id}"
  }
}

resource "aws_ecs_task_definition" "fargate" {
  family                   = "fargate"
  container_definitions    = "${data.template_file.ecs_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  # execution_role_arn       = "arn:aws:iam::${var.aws_id}:role/ecsAdminRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_id}:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "nginx" {
  name = "fargate"
  cluster = "${aws_ecs_cluster.fargate.id}"
  task_definition = "${aws_ecs_task_definition.fargate.arn}"
  desired_count = 2
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.main.id}"
    container_name = "nginx"
    container_port = 80
  }

  network_configuration {
    subnets = [
      "${aws_subnet.public_alpha.id}",
      "${aws_subnet.public_charlie.id}"
    ]

    security_groups = [
      "${aws_default_security_group.fargate.id}",
      "${aws_security_group.web.id}"
    ]

    # assign_public_ip = "ENABLED"
  }
}
