resource "aws_instance" "controller" {
  ami                  = "ami-083495c25079d8368"
  instance_type        = "t2.micro"
  availability_zone    = "${var.availability_zones["charlie"]}"
  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}"
  ]

  subnet_id            = "${data.aws_subnet.charlie.id}"
  key_name             = "${var.ec2_key_pair_name}"
  # user_data            = "${data.template_file.ecs_instance_user_data.rendered}"
  # iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"

  associate_public_ip_address          = true
  instance_initiated_shutdown_behavior = "terminate"

  tags {
    Name = "${var.name}-controller"
  }
}
