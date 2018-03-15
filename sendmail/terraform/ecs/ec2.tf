resource "aws_instance" "ecs" {
  ami                  = "ami-bb5f13dd"
  instance_type        = "t2.micro"
  availability_zone    = "${var.availability_zones["alpha"]}"
  security_groups      = [
    "${data.aws_security_group.default.id}",
    "${data.aws_security_group.ecs.id}"
  ]

  subnet_id            = "${data.aws_subnet.alpha.id}"
  key_name             = "${var.ec2_key_pair_name}"
  user_data            = "${data.template_file.ecs_instance_user_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"

  associate_public_ip_address          = true
  instance_initiated_shutdown_behavior = "terminate"

  tags {
    Name = "${var.name}"
  }
}

data "template_file" "ecs_instance_user_data" {
  template = "${file("terraform/ecs/template/user_data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.main.name}"
  }
}
