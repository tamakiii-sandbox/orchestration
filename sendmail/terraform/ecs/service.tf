resource "aws_ecs_task_definition" "main" {
  family                = "${var.name}"
  container_definitions = <<EOT
[
  {
    "name": "php",
    "essential": true,
    "image": "825814182855.dkr.ecr.ap-northeast-1.amazonaws.com/sendmail/php:release",
    "memory": 128,
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group":  "/tamakiii.com/orchestration/${var.name}/php",
        "awslogs-region": "${var.region}"
      }
    }
  }
]
EOT
}

resource "aws_ecs_service" "main" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count   = 1
  /* iam_role        = "${aws_iam_role.ecs_service.arn}" */
  /* depends_on      = ["aws_iam_role_policy.ecs_service"] */

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  # load_balancer {
  #   elb_name       = "${aws_elb.foo.name}"
  #   container_name = "mongo"
  #   container_port = 8080
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }

  lifecycle {
    # INFO: In the future, we support that U can customize
    #       https://github.com/hashicorp/terraform/issues/3116
    ignore_changes = [
      "desired_count",
      "task_definition",
    ]
  }
}
