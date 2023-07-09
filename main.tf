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