variable "profile" {
  type = "string"
  default = "tamakiii"
}
variable "region" {
  type = "string"
  default = "ap-northeast-1"
}
variable "name" {
  type = "string"
}
variable "vpc_cidr_block" {
  type = "string"
}
variable "availability_zones" {
  type = "map"
}
variable "subnet_cidr_blocks" {
  type = "map"
}
