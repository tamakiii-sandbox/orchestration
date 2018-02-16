terraform {
  backend "s3" {
    bucket = "terraform.tamakiii.com"
    key    = "orchestration/symfony-4.0"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  version = "~> 1.7"
  region = "ap-northeast-1"
  profile = "tamakiii"
}
