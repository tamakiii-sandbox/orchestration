
data "aws_route53_zone" "tamakiiicom" {
  name = "tamakiii.com."
}

data "aws_alb" "first_run" {
  arn = "arn:aws:elasticloadbalancing:ap-northeast-1:825814182855:loadbalancer/app/ECS-first-run-alb/c12fe661deb6a009"
}

data "aws_alb_target_group" "first_run" {
  arn = "arn:aws:elasticloadbalancing:ap-northeast-1:825814182855:targetgroup/sample-webapp-target-group/af9f6226558c60c8"
}

resource "aws_route53_record" "tamakiiicom_aws" {
  zone_id = "${data.aws_route53_zone.tamakiiicom.zone_id}"
  name    = "aws.tamakiii.com"
  type    = "CNAME"
  ttl     = 300
  records = ["${data.aws_alb.first_run.dns_name}"]
}

resource "aws_acm_certificate" "tamakiiicom" {
  domain_name       = "tamakiii.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "aws.tamakiii.com"
  ]
}

resource "aws_route53_record" "tamakiiicom_cert_validation" {
  count   = "${length(aws_acm_certificate.tamakiiicom.domain_validation_options)}"
  zone_id = "${data.aws_route53_zone.tamakiiicom.id}"

  name    = "${lookup(aws_acm_certificate.tamakiiicom.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.tamakiiicom.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.tamakiiicom.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "tamakiiicom" {
  certificate_arn         = "${aws_acm_certificate.tamakiiicom.arn}"
  validation_record_fqdns = ["${aws_route53_record.tamakiiicom_cert_validation.*.fqdn}"]
}

resource "aws_alb_listener" "tamakiiicom_https" {
  load_balancer_arn = "${data.aws_alb.first_run.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.tamakiiicom.arn}"
  certificate_arn   = "${aws_acm_certificate_validation.tamakiiicom.certificate_arn}"

  default_action {
    target_group_arn = "${data.aws_alb_target_group.first_run.arn}"
    type             = "forward"
  }
}
