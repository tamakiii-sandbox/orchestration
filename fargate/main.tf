########################################
# Backend
########################################
terraform {
  backend "s3" {
    region = "ap-northeast-1"
    bucket = "terraform.tamakiii.com"
    key = "orchestration/fargate/terraform.tfstate"
  }
}

########################################
# Provider
########################################
provider "aws" {
  version = "~> 1.7"
  profile = "${var.profile}"
  region = "${var.region}"
}
