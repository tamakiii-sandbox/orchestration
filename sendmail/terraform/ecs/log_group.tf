resource "aws_cloudwatch_log_group" "php" {
  name              = "/tamakiii.com/orchestration/${var.name}/php"
  retention_in_days = 14
}
