terraform {
  backend "s3" {
    region = "ap-northeast-1"
    profile = "tamakiii"
    bucket = "terraform.tamakiii.com"
    key = "orchestration/tamakiii.com/terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 1.9"
  region = "${var.region}"
  profile = "${var.profile}"
}
