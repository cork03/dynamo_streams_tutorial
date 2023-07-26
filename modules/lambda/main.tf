data "archive_file" "this" {
  type = "zip"

  source_file  = var.source_file
  output_path = var.output_path
}

resource "aws_s3_object" "this" {
  bucket = var.s3_bucket_id

  key    = var.s3_object_key
  source = data.archive_file.this.output_path

  //  entity tag(バージョン識別子)
  etag = filemd5(data.archive_file.this.output_path)
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  runtime       = "python3.9"
  handler       = var.handler

  environment {
    variables = var.lambda_variables
  }

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.this.key

  layers = var.layers

  role             = var.lambda_iam_arn
  source_code_hash = data.archive_file.this.output_base64sha256
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"

  retention_in_days = 30
}
