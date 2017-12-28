########################################
# Variables
########################################
variable "name" {
  default = "tfawsecs"
}
variable "profile" {
  default = "tamakiii"
}
variable "region" {
  default = "ap-northeast-1"
}
variable "availability_zones" {
  type = "map"
  default = {
    alpha    = "ap-northeast-1a"
    beta     = "ap-northeast-1b"
    charlie  = "ap-northeast-1c"
    delta    = "ap-northeast-1d"
  }
}
variable "vpc_cidr_block" {
  default = "11.0.0.0/16"
}
variable "subnet_cidr_blocks" {
  type = "map"
  default = {
    alpha    = "11.0.1.0/24"
    beta     = "11.0.2.0/24"
    charlie  = "11.0.3.0/24"
    delta    = "11.0.4.0/24"
  }
}

########################################
# Backend
########################################
terraform {
  backend "s3" {
    region = "ap-northeast-1"
    bucket = "terraform.tamakiii.com"
    key = "orchestration/tf-aws-ecs/terraform.tfstate"
  }
}

########################################
# Provider
########################################
provider "aws" {
  version = "~> 1.6"
  profile = "${var.profile}"
  region = "${var.region}"
}


########################################
# Resources
########################################
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false

  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "alpha" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["alpha"]}"
  cidr_block = "${var.subnet_cidr_blocks["alpha"]}"

  tags {
    Name = "${var.name}-alpha"
  }

  depends_on = ["aws_vpc.main"]
}
resource "aws_subnet" "charlie" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["charlie"]}"
  cidr_block = "${var.subnet_cidr_blocks["charlie"]}"

  tags {
    Name = "${var.name}-charlie"
  }

  depends_on = ["aws_vpc.main"]
}
