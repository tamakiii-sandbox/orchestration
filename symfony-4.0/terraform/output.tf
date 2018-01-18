output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "details" {
  value = <<EOT
  ${aws_vpc.main.tags.Name}:
    id: ${aws_vpc.main.id}
    cidr_block: ${aws_vpc.main.cidr_block}

  ${aws_default_security_group.default.tags.Name}:
    id: ${aws_default_security_group.default.id}
    description:
EOT
}
