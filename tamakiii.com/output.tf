
output "overview" {
  value = <<EOT

  Route53:
    - tamakiii.com
      zone_id: ${data.aws_route53_zone.tamakiiicom.zone_id}

EOT
}
