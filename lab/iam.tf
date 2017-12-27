# resource "aws_iam_role" "ecs" {
#   name = "lab-ar-ecs"
#   assume_role_policy = "${file("policies/assume-role/ecs.json")}"
# }
#
# resource "aws_iam_policy_attachment" "ecs" {
#   name = "lab-iam-policy-attach-ecs"
#   roles = ["${aws_iam_role.ecs.name}"]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }
#
# resource "aws_iam_policy_attachment" "ecs" {
#   name = "ecs-service-role-attach"
#   roles = ["${aws_iam_role.ecs.name}"]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
# }

resource "aws_iam_role" "instance" {
  name = "lab-ecs-role"
  force_detach_policies = true
  assume_role_policy = "${file("policies/assume-role/ecs.json")}"
}

resource "aws_iam_role" "service" {
  name = "lab-ecs-service-role"
  assume_role_policy = "${file("policies/assume-role/ec2.json")}"
}

resource "aws_iam_role_policy_attachment" "instance" {
  role = "${aws_iam_role.instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "lab-ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.instance.name}"
}



# resource "aws_iam_instance_profile" "service" {
#   name = "lab-ecs-service-instance-profile"
#   role = "${aws_iam_role.service.name}"
#
#   depends_on = ["aws_iam_role.service"]
# }
#
# resource "aws_iam_role_policy" "ecs" {
#   name = "lab-ecs-policy"
#   role = "${aws_iam_role.ecs.name}"
#   policy = "${var.container_iam_role_policy}"
# }
#
# resource "aws_iam_role_policy_attachment" "instance_policy" {
#   count = "${length(var.instance_policy_arns)}"
#
#   role       = "${aws_iam_role.app_instance.name}"
#   policy_arn = "${element(var.instance_policy_arns, count.index)}"
#
#   depends_on = ["aws_iam_role.app_instance"]
# }
