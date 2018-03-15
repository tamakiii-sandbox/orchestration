resource "aws_ecr_repository" "php" {
  name = "${var.name}/php"
}

