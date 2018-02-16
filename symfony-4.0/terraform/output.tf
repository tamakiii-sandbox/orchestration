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

  Internet Gateway:
    ${aws_internet_gateway.public.tags.Name}
      id: ${aws_internet_gateway.public.id}

  Route Table:
    ${aws_route_table.public.tags.Name}:
      id: ${aws_route_table.public.id}
      association:
        - ${aws_route_table_association.public_a.id}
        - ${aws_route_table_association.public_c.id}

  Subnet:
    ${aws_subnet.public_a.tags.Name}:
      id: ${aws_subnet.public_a.id}
      cidr_block: ${aws_subnet.public_a.cidr_block}
      availability_zone: ${aws_subnet.public_a.availability_zone}
    ${aws_subnet.public_c.tags.Name}:
      id: ${aws_subnet.public_c.id}
      cidr_block: ${aws_subnet.public_c.cidr_block}
        availability_zone: ${aws_subnet.public_c.availability_zone}

EOT
}
