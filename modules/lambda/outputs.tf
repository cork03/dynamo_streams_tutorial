output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}
