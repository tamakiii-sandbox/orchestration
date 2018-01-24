########################################
# Variables
########################################
variable "name" {
  default = "fargate"
}
variable "profile" {
  default = "tamakiii"
}
variable "region" {
  default = "us-east-1"
}
variable "aws_id" {
  default = "825814182855"
}
variable "vpc_cidr_block" {
  default = "13.0.0.0/16"
}
variable "availability_zones" {
  type = "map"
  default = {
    alpha    = "us-east-1a"
    beta     = "us-east-1b"
    charlie  = "us-east-1c"
    delta    = "us-east-1d"
  }
}
variable "subnet_cidr_blocks" {
  type = "map"
  default = {
    alpha    = "13.0.0.0/24"
    beta     = "13.0.1.0/24"
    charlie  = "13.0.2.0/24"
    delta    = "13.0.3.0/24"
  }
}
