data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["${var.name}"]
  }
}

data "aws_subnet" "alpha" {
  vpc_id = "${data.aws_vpc.main.id}"

  filter {
    name = "tag:Name"
    values = ["${var.name}-alpha"]
  }
}

data "aws_subnet" "charlie" {
  vpc_id = "${data.aws_vpc.main.id}"

  filter {
    name = "tag:Name"
    values = ["${var.name}-charlie"]
  }
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.main.id}"

  filter {
    name = "tag:Name"
    values = ["${var.name}"]
  }
}

data "aws_security_group" "ecs" {
  vpc_id = "${data.aws_vpc.main.id}"

  filter {
    name = "tag:Name"
    values = ["${var.name}-ecs"]
  }
}
