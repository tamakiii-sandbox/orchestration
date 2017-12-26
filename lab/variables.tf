variable "profile" {
  default = "tamakiii"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "az" {
  type = "map"
  default {
    a = "ap-northeast-1a"
    c = "ap-northeast-1c"
  }
}

variable "subnet_cidr" {
  type = "map"
  default {
    a = "10.0.1.0/24"
    c = "10.0.3.0/24"
  }
}

variable "ami" {
  default = "ami-56bd0030"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {}
variable "certificate_arn" {}
