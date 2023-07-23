resource "aws_sns_topic" "this" {
  name = "MyTopic"
}

resource "aws_sns_topic_subscription" "this" {
  endpoint  = "inocennce1215@icloud.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.this.arn
}

resource "aws_sns_topic" "https" {
  name = "https"
}

resource "aws_sns_topic_subscription" "https" {
  endpoint  = "${aws_apigatewayv2_stage.lambda_api.invoke_url}/api_gw"
  protocol  = "https"
  topic_arn = aws_sns_topic.https.arn
  endpoint_auto_confirms = true
}