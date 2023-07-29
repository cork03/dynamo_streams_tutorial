resource "aws_dynamodb_table" "dynamo_streams" {
  //partition key
  hash_key       = "UserId"
  name           = "dynamo_streams"
  read_capacity  = 1
  write_capacity = 1

  // ストリームの有効化
  stream_enabled = true
  //  更新されたItemから渡すデータを設定する
  stream_view_type = "NEW_IMAGE"

  // テーブルカラム
  attribute {
    name = "UserId"
    type = "N"
  }
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn  = aws_dynamodb_table.dynamo_streams.stream_arn
  function_name     = module.dynamo_stream_lambda.lambda_arn
  starting_position = "LATEST"

  maximum_retry_attempts = 3

  destination_config {
    on_failure {
      destination_arn = aws_sqs_queue.this.arn
    }
  }
}

//lambda bucket
resource "random_pet" "this" {
  prefix = "learn-terraform-functions"
  # -で4単語つないでつくる
  length = 3
}

resource "aws_s3_bucket" "this" {
  bucket = random_pet.this.id
}

module "dynamo_stream_lambda" {
  source        = "./modules/lambda"
  source_file   = "${path.module}/lambdaFunctions/dynamoTrigger.py"
  output_path   = "${path.module}/functionsZips/dynamoTrigger.zip"
  s3_bucket_id  = aws_s3_bucket.this.id
  s3_object_key = "dynamoTrigger.zip"
  function_name = "dynamoTriggered"
  handler       = "dynamoTrigger.handler"
  lambda_variables = {
    SNS_TOPIC_ARN = aws_sns_topic.https.arn
  }
  lambda_iam_arn = module.dynamo_lambda_role.iam_role_arn
  layers = []
}

module "api_gateway_lambda" {
  source        = "./modules/lambda"
  source_file   = "${path.module}/lambdaFunctions/apiGatewayLambda.py"
  output_path   = "${path.module}/functionsZips/apiGatewayLambda.zip"
  s3_bucket_id  = aws_s3_bucket.this.id
  s3_object_key = "apiGatewayLambda.zip"
  function_name = "apiGatewayLambda"
  handler       = "apiGatewayLambda.handler"
  lambda_variables = {}
  lambda_iam_arn = module.api_gateway_lambda_role.iam_role_arn
  layers = ["arn:aws:lambda:ap-northeast-1:770693421928:layer:Klayers-p39-requests:15"]
}
