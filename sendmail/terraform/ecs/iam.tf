resource "aws_iam_role" "ecs_instance" {
  name                  = "${aws_ecs_cluster.main.name}-ecs-instance-role"
  force_detach_policies = true
  path                  = "/tamakiii.com/orchestration/${aws_ecs_cluster.main.name}/ecs-instance-role/"

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

# resource "aws_iam_role" "ecs_service" {
#   name                  = "${var.name}-ecs-service-role"
#   path                  = "/tamakiii.com/orchestration/sendmail/${var.name}/ecs-service-role/"
#   force_detach_policies = true
#   assume_role_policy    = <<EOT
# {
#   "Version": "2008-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ecs.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOT
# }
# 
# resource "aws_iam_role_policy" "ecs_service" {
#   name   = "${var.name}-ecs-service-policy"
#   role   = "${aws_iam_role.ecs_service.name}"
#   policy = <<EOT
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:Describe*",
#         "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#         "elasticloadbalancing:DeregisterTargets",
#         "elasticloadbalancing:Describe*",
#         "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#         "elasticloadbalancing:RegisterTargets"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOT
# }
