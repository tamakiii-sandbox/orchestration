resource "aws_launch_configuration" "service" {
  name_prefix = "lab-lc-service-"
  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.main.id}"]
  associate_public_ip_address = 0
  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_security_group.main"]
}
