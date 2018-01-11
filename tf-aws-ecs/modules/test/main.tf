variable "name" {
  description = "VPC name"
}
variable "cidr_block" {
  description = ""
  default = "10.0.0.0/0"
}
variable "instance_tenancy" {
  description = ""
  default = "default"
}
variable "enable_dns_support" {
  description = ""
  default = true
}
variable "enable_dns_hostnames" {
  description = ""
  default = true
}
variable "enable_classiclink" {
  description = ""
  default = false
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"

  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_classiclink = "${var.enable_classiclink}"

  tags {
    Name = "${var.name}"
  }
}
