resource "aws_autoscaling_group" "service" {
  name = "lab-asg-service"
  launch_configuration = "${aws_launch_configuration.service.name}"
  availability_zones = ["${var.az["a"]}", "${var.az["c"]}"]
  vpc_zone_identifier = ["${aws_subnet.a.id}", "${aws_subnet.c.id}"]
  # load_balancers = ["${aws_alb.service.name}"]
  min_size = 1
  max_size = 4
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tag = {
    key = "Name"
    value = "lab-asg-service"
    propagate_at_launch = true
  }

  depends_on = ["aws_launch_configuration.service"]
}

# resource "aws_autoscaling_policy" "cluster_scale_out" {
#   name                   = "${var.name_prefix}-instance-scale_out-cpu_high"
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "${var.cluster_scale_out_adjustment}"
#   cooldown               = "${var.cluster_cooldown}"
#   autoscaling_group_name = "${var.asg_name}"
# }

