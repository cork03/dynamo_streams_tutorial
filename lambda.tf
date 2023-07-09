//lambda bucket
resource "random_pet" "this" {
  prefix = "learn-terraform-functions"
  # -で4単語つないでつくる
  length = 3
}

resource "aws_s3_bucket" "this" {
  bucket = random_pet.this.id
}

# 関数をzipに変換
data "archive_file" "this" {
  type = "zip"

  source_dir  = "${path.module}/lambdaFunctions"
  output_path = "${path.module}/functionsZips/dynamoTrigger.zip"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id

  key    = "dynamoTrigger.zip"
  source = data.archive_file.this.output_path

  //  entity tag(バージョン識別子)
  etag = filemd5(data.archive_file.this.output_path)
}

resource "aws_lambda_function" "dynamo_triggered" {
  function_name = "dynamo_triggered"
  runtime       = "python3.9"
  handler       = "dynamoTrigger.handler"

  s3_bucket = aws_s3_bucket.this.bucket
  s3_key    = aws_s3_object.this.key

  role             = module.this.iam_role_arn
  source_code_hash = data.archive_file.this.output_base64sha256
}

resource "aws_cloudwatch_log_group" "this" {
  //  /aws/lambda/関数名にログを吐く
  name = "/aws/lambda/${aws_lambda_function.dynamo_triggered.function_name}"

  retention_in_days = 30
}
