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
variable "vpc_cidr_block" {
  default = "13.0.0.0/16"
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
