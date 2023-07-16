resource "aws_sns_topic" "this" {
  name = "MyTopic"
}

resource "aws_sns_topic_subscription" "this" {
  endpoint  = "inocennce1215@icloud.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.this.arn
}