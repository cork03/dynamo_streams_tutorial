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
    resources = ["${module.dynamo_stream_lambda.cloudwatch_log_group_arn}:*"]
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

  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [aws_sns_topic.https.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    resources = [aws_sqs_queue.this.arn]
  }
}

module "dynamo_lambda_role" {
  source     = "./modules/iamRole"
  name       = "dynamo_lambda"
  policy     = data.aws_iam_policy_document.this.json
  identifier = "lambda.amazonaws.com"
}

//apiGatewayLambda
data "aws_iam_policy_document" "apiGatewayLambda" {
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
    resources = ["${module.api_gateway_lambda.cloudwatch_log_group_arn}:*"]
  }
}

module "api_gateway_lambda_role" {
  source     = "./modules/iamRole"
  name       = "api_gateway_lambda"
  policy     = data.aws_iam_policy_document.apiGatewayLambda.json
  identifier = "lambda.amazonaws.com"
}