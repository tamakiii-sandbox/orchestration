
output "overview" {
  value = <<EOT

  Route53:
    - tamakiii.com
      zone_id: ${data.aws_route53_zone.tamakiiicom.zone_id}
    - certificate_validation
      resource_record_name: ${aws_acm_certificate.tamakiiicom.domain_validation_options.0.resource_record_name}

  ALB:
    - ${data.aws_alb.first_run.arn}
      name: ${data.aws_alb.first_run.name}
      dns_name: ${data.aws_alb.first_run.dns_name}

EOT
}
