resource "aws_alb" "service" {
  name = "lab-alb-service"
  security_groups = ["${aws_security_group.main.id}"]
  subnets = ["${aws_subnet.a.id}", "${aws_subnet.c.id}"]
  internal = false
  enable_deletion_protection = false

  # access_logs {
  #   bucket = "${aws_s3_bucket.alb_log.bucket}"
  # }
}

resource "aws_alb_target_group" "service" {
  # count = 2
  # name = "lab-tg-${count.index+1}"
  name = "lab-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.lab.id}"

  # health_check {
  #   interval            = 30
  #   path                = "/index.html"
  #   port                = 80
  #   protocol            = "HTTP"
  #   timeout             = 5
  #   unhealthy_threshold = 2
  #   matcher             = 200
  # }
}

resource "aws_alb_listener" "service-http" {
  load_balancer_arn = "${aws_alb.service.arn}"
  port = 80
  protocol = "HTTP"

  "default_action" {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type = "forward"
  }
}

# resource "aws_security_group" "service" {
#   name        = ""
#   description = ""
#   vpc_id      = ""
# 
#   ingress {
#     protocol    = "icmp"
#     from_port   = 8
#     to_port     = 0
#     cidr_blocks = []
# }

resource "aws_alb_listener" "service-https" {
  load_balancer_arn = "${aws_alb.service.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type = "forward"
  }
}

# resource "aws_alb_target_group_attachment" "service" {
#   count  = 2
#   target_group_arn = "${element(aws_alb_target_group.service.*.arn, count.index)}"
#   target_id = "${element(aws_spot_instance_request.web.*.spot_instance_id, count.index)}"
#   port = 80
# }


# resource "aws_alb" "service" {
#   name = "lab-alb-service"
#   internal = false
#   availability_zones = ["${var.az["a"]}", "${var.az["c"]}"]
# 
#   listener {
#     instance_port      = 443
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "${var.ssl_certificate_id}"
#   }
# 
#   tags {
#     Name = "lab-alb-service"
#   }
# }
# 
# resource "aws_load_balancer_policy" "service" {
#   load_balancer_name = "${aws_elb.service.name}"
#   policy_name        = "lab-ca-pubkey-policy"
#   policy_type_name   = "PublicKeyPolicyType"
# 
#   policy_attribute = {
#     name  = "PublicKey"
#     value = "${file("wu-tang-pubkey")}"
#   }
# }
