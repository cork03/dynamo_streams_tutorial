data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = ["arn:aws:logs:ap-northeast-1:463196187961:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams"
    ]
    resources = ["*"]
  }
}

module "this" {
  source     = "./modules/iamRole"
  name       = "dynamo_lambda"
  policy     = data.aws_iam_policy_document.this.json
  identifier = "lambda.amazonaws.com"
}
