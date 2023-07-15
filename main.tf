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
  function_name     = aws_lambda_function.dynamo_triggered.arn
  starting_position = "LATEST"

  maximum_retry_attempts = 3

  destination_config {
    on_failure {
      destination_arn = aws_sqs_queue.this.arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "retry" {
  event_source_arn = aws_sqs_queue.this.arn
  function_name = aws_lambda_function.dynamo_triggered.arn
}
