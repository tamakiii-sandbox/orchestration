data "aws_route53_zone" "tamakiiicom" {
  name = "tamakiii.com."
}

resource "aws_route53_record" "spf_tamakiiicom" {
    zone_id = "${data.aws_route53_zone.tamakiiicom.id}"
    name    = "spf.tamakiii.com"
    type    = "TXT"
    ttl     = "60"
    records = ["v=spf1 ip4:54.250.57.192/32"]
}
