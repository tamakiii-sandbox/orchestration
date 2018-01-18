#--------------------------------------------------------------
# VPC
#--------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "${var.CIDR_BLOCK}"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags {
    Name = "${var.name}"
  }
}

#--------------------------------------------------------------
# Security Group - default
#--------------------------------------------------------------
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
  }
}

#--------------------------------------------------------------
# Subnet
#--------------------------------------------------------------
resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_a"]}"
  availability_zone = "${var.AWS_AZ_ALPHA}"

  tags {
    Name = "${var.name}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_c"]}"
  availability_zone = "${var.AWS_AZ_CHARLIE}"

  tags {
    Name = "${var.name}-public-c"
  }
}

#--------------------------------------------------------------
# Internet Gateway
#--------------------------------------------------------------
resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-public"
  }
}

#--------------------------------------------------------------
# Route Table
#--------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}
resource "aws_route_table_association" "public_a" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_a.id}"
}
resource "aws_route_table_association" "public_c" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_c.id}"
}

#--------------------------------------------------------------
# Key Pair
#--------------------------------------------------------------
resource "aws_key_pair" "developer" {
  key_name   = "symfony-4.0-developer.pem"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4XkmsvrZ/8UUXFyqB6JcClRLVXa0bgfPScj4ueMgFvNrVmUJyZsIUnoBAg+8o8ZU/MsWNH/M94TY/3ryFFEmuSC8FQjGVuGAhivil/9IBaPauV7ihNAQcGy6dSe5LmEP+qjMaGJavds93pJXcANmvhodvFSgXfvga80RdJ4pMjX7bPCYnzjCCwA1Eht4e2Y6hKCPrX2Khq6pHPEc3bjRQ8Ut8MBnHzPzq/iPH6rT8+HhfJN81fuwXqWqzarY9+4u1zN+P3akIXPNJ3yoir6aKWFOHlOdGBhRIlVThjiExRsrdhM+wEqLAlz3R67whkQtK/PsNrZrm2WE0pmvVxB6awo6LZqX2afxfRoSMw3Ay+tIIwRlAEDrGhQ3GsW0xfNMwe0jbOrHWfzFqas35QEH8+0s9xzffnarLq6VOU7J8FQ+SfPjFmFRHGmy3M0whGPLAk9zjpq7rzAqo7YfjzSe89UGrAIvRYV3Qwa/BPnKXdDKoWjGAP3KUvEfLeCFauv/O7ka+3j9yNxuKmUZp0sVNuIyJ2ds5SkIYpvf32vvmDHY9tDQiCQCYn3xeleImEQF3vfsQ2h6r9Knliag6GNhMEnoBEpzMD12ZfW34Hqn9e9ASJU43hYfjuG+l24xtIccQWMv3gUJSjG9txXb3SETBd+e4yOCKYZFXtWX0LCQYaw== tamakiii"
}

#--------------------------------------------------------------
# Security Group - ALB
#--------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "ALB security group"
  description = "Allow request from internet"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-alb"
  }
}
resource "aws_security_group_rule" "alb_ingress_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.alb.id}"
}
resource "aws_security_group_rule" "alb_egress_all_traffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.alb.id}"
}

#--------------------------------------------------------------
# Security Group - ECS
#--------------------------------------------------------------
resource "aws_security_group" "ecs" {
  name        = "ECS security group"
  description = "Allow ECS ports"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-ecs"
  }
}
resource "aws_security_group_rule" "ecs_egress_all_traffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ecs.id}"
}
resource "aws_security_group_rule" "ecs_ingress_dynamic_ports" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"

  security_group_id = "${aws_security_group.ecs.id}"
  source_security_group_id = "${aws_security_group.alb.id}"
}

#--------------------------------------------------------------
# ALB for ECS
#--------------------------------------------------------------
resource "aws_alb" "ecs" {
  name            = "${var.name}-ecs"
  security_groups = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.alb.id}",
  ]
  subnets         = [
    "${aws_subnet.public_a.id}",
    "${aws_subnet.public_c.id}"
  ]

  enable_deletion_protection = false

  tags {
    Name = "${var.name}-ecs"
  }
}
resource "aws_alb_target_group" "ecs" {
  name     = "${var.name}-ecs"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  tags {
    Application = "${var.name}-ecs"
  }
}
resource "aws_alb_listener" "ecs_http" {
  load_balancer_arn = "${aws_alb.ecs.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs.arn}"
    type             = "forward"
  }
}

#--------------------------------------------------------------
# ECS Cluster
#--------------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
}
resource "aws_cloudwatch_log_group" "ecs_agent" {
  name              = "${var.name}/ecs-agent"
  retention_in_days = 14
}
resource "aws_autoscaling_group" "main" {
  availability_zones        = [
    "${var.AWS_AZ_ALPHA}",
    "${var.AWS_AZ_CHARLIE}",
  ]
  name                      = "${var.name}"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  # desired_capacity          = 4
  # force_delete              = true
  # placement_group           = "${aws_placement_group.test.id}"
  launch_configuration      = "${aws_launch_configuration.main.name}"

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
#
#     notification_metadata = <<EOF
# {
#   "foo": "bar"
# }
# EOF
#
#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  # tag {
  #   key                 = "lorem"
  #   value               = "ipsum"
  #   propagate_at_launch = false
  # }

  vpc_zone_identifier = [
    "${aws_subnet.public_a.id}",
    "${aws_subnet.public_c.id}",
  ]

  default_cooldown    = 150

  lifecycle {
    create_before_destroy = true
    # NOTE: changed automacally by autoscale policy
    ignore_changes        = ["desired_capacity"]
  }
}

resource "aws_launch_configuration" "main" {
  name_prefix                 = "${aws_ecs_cluster.main.name}-"
  image_id                    = "ami-72f36a14"
  instance_type               = "t2.micro"

  security_groups             = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.ecs.id}",

  ]
  key_name                    = "${aws_key_pair.developer.key_name}"
  ebs_optimized               = false

  iam_instance_profile        = "${aws_iam_instance_profile.ecs_instance.name}"
  user_data                   = "${data.template_file.ecs_cluster_user_data.rendered}"
  associate_public_ip_address = true
  enable_monitoring           = true

  # NOTE: Currently no-support to customizing block device(s)
  #       - OS specified image_id is not always using /dev/xvdcz as docker storage
  #       - As a workaround, creates the ami that it is customizing to the block device mappings
  #root_block_device {}
  #ebs_block_device  { device_name = "/dev/xvdcz" }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ecs_cluster_user_data" {
  template = "${file("template/user_data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.main.name}"
  }
}

#--------------------------------------------------------------
# IAM - ECS
#--------------------------------------------------------------
resource "aws_iam_role" "ecs_instance" {
  name                  = "${aws_ecs_cluster.main.name}-ecs-instance-role"
  force_detach_policies = true

  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  # http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
  role       = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  depends_on = ["aws_iam_role.ecs_instance"]
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name       = "${aws_ecs_cluster.main.name}-ecs-instance-profile"
  role       = "${aws_iam_role.ecs_instance.name}"

  depends_on = ["aws_iam_role.ecs_instance"]
}

#--------------------------------------------------------------
# Auto Scaling - Cluster
#--------------------------------------------------------------
# resource "aws_autoscaling_notification" "ok" {
#   group_names   = ["${aws_autoscaling_group.main.name}"]
#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#   ]
#   topic_arn     = "${var.autoscale_notification_ok_topic_arn}"
# }

# resource "aws_autoscaling_notification" "ng" {
#   count         = "${var.autoscale_notification_ng_topic_arn != "" ? 1 : 0}"
#
#   group_names   = ["${aws_autoscaling_group.main.name}"]
#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
#   ]
#   topic_arn     = "${var.autoscale_notification_ng_topic_arn}"
# }

resource "aws_autoscaling_policy" "scale_out" {
  name                      = "${aws_ecs_cluster.main.name}-ECSCluster-ScaleOut"
  autoscaling_group_name    = "${aws_autoscaling_group.main.name}"
  scaling_adjustment        = 1
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  name                      = "${aws_ecs_cluster.main.name}-ECSCluster-ScaleIn"
  autoscaling_group_name    = "${aws_autoscaling_group.main.name}"
  scaling_adjustment        = -1
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_reservation_high" {
  alarm_name          = "${aws_ecs_cluster.main.name}-ECSCluster-CPUReservation-High"
  alarm_description   = "${aws_ecs_cluster.main.name} scale-out pushed by cpu-reservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  treat_missing_data  = "notBreaching"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }

  # ok_actions          = ["${compact(var.scale_out_ok_actions)}"]
  alarm_actions       = [
    "${aws_autoscaling_policy.scale_out.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpu_reservation_low" {
  alarm_name          = "${aws_ecs_cluster.main.name}-ECSCluster-CPUReservation-Low"
  alarm_description   = "${aws_ecs_cluster.main.name} scale-in pushed by cpu-reservation-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }

  # ok_actions          = ["${compact(var.scale_in_ok_actions)}"]
  alarm_actions       = [
    "${aws_autoscaling_policy.scale_in.arn}",
  ]
}

#--------------------------------------------------------------
# Auto Scaling - Cluster
#--------------------------------------------------------------
data "template_file" "ecs_service_task_definitions" {
  # http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
  template = "${file("template/task_definitions.json")}"

  vars {
    region = "${var.AWS_REGION}"
  }
}

resource "aws_ecs_task_definition" "container" {
  family                = "${var.name}"
  container_definitions = "${data.template_file.ecs_service_task_definitions.rendered}"
}

resource "aws_ecs_service" "main" {
  name                               = "${var.name}-${var.name}"
  cluster                            = "${aws_ecs_cluster.main.id}"
  task_definition                    = "${aws_ecs_task_definition.container.arn}"
  desired_count                      = 2
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  iam_role                           = "${aws_iam_role.ecs_service.arn}"

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs.arn}"
    container_name = "httpd"
    container_port = 80
  }

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

resource "aws_iam_role" "ecs_service" {
  name                  = "${var.name}-ecs-service-role"
  path                  = "/"
  force_detach_policies = true
  assume_role_policy    = <<EOT
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "ecs_service" {
  name   = "${var.name}-ecs-service-policy"
  role   = "${aws_iam_role.ecs_service.name}"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_cloudwatch_log_group" "httpd" {
  name              = "symfony-40/container/httpd"
  retention_in_days = 14
}
