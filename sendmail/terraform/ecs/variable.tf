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
variable "availability_zones" {
  type = "map"
}
variable "ec2_key_pair_name" {
  type = "string"
}
