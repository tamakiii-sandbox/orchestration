#--------------------------------------------------------------
# AWS
#--------------------------------------------------------------
variable "AWS_REGION" {}
variable "AWS_AZ_ALPHA" {}
variable "AWS_AZ_CHARLIE" {}

#--------------------------------------------------------------
# config.hcl
#--------------------------------------------------------------
variable "CIDR_BLOCK" {
  type = "string"
}
variable "CIDR_BLOCKS" {
  type = "map"
}

#--------------------------------------------------------------
# General
#--------------------------------------------------------------
variable "name" {
  default = "symfony-4.0"
}
