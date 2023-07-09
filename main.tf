resource "aws_dynamodb_table" "dynamo_streams" {
  //partition key
  hash_key = "UserId"
  name = "dynamo_streams"
  read_capacity = 1
  write_capacity = 1

  // テーブルカラム
  attribute {
    name = "UserId"
    type = "N"
  }
}