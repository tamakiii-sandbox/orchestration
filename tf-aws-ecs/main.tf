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
    alpha    = "11.0.0.0/24"
    beta     = "11.0.1.0/24"
    charlie  = "11.0.2.0/24"
    delta    = "11.0.3.0/24"
  }
}

variable "key_pair" { type = "map" }

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
# VPC
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

########################################
# Subnets
########################################
resource "aws_subnet" "alpha" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["alpha"]}"
  cidr_block = "${var.subnet_cidr_blocks["alpha"]}"

  tags {
    Name = "${var.name}-alpha"
  }
}
resource "aws_subnet" "charlie" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["charlie"]}"
  cidr_block = "${var.subnet_cidr_blocks["charlie"]}"

  tags {
    Name = "${var.name}-charlie"
  }
}

########################################
# Route table
########################################
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}"
  }
}
resource "aws_route_table_association" "alpha" {
  subnet_id = "${aws_subnet.alpha.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "charlie" {
  subnet_id = "${aws_subnet.charlie.id}"
  route_table_id = "${aws_route_table.public.id}"
}

########################################
# Internet gateway
########################################
resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
  }
}

########################################
# Security group
########################################
resource "aws_security_group" "ecs" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${var.name}-ecs"
  description = "ECS Allowed Ports"

  ingress {
    protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-ecs"
  }
}

########################################
# Application load balancer
########################################
resource "aws_alb" "main" {
  name = "${var.name}"
  internal = false

  security_groups = [
    "${aws_security_group.ecs.id}"
  ]

  subnets = [
    "${aws_subnet.alpha.id}",
    "${aws_subnet.charlie.id}",
  ]

  enable_deletion_protection = false
}
resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.main.arn}"
    type = "forward"
  }
}
resource "aws_alb_target_group" "main" {
  name = "${var.name}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"

  health_check {
    path = "/"
    interval = 30
    healthy_threshold = 5
    unhealthy_threshold = 2
  }

  tags {
    Application = "${var.name}"
  }
}
