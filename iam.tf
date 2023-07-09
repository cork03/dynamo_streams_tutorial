data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [data.aws_iam_policy.this.policy]
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
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
