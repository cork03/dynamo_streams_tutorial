resource "aws_sns_topic" "https" {
  name = "https"
}

resource "aws_sns_topic_subscription" "https" {
  endpoint = "${aws_apigatewayv2_stage.lambda_api.invoke_url}/api_gw"
  protocol = "https"
  topic_arn = aws_sns_topic.https.arn
  endpoint_auto_confirms = true
  delivery_policy = <<EOF
  {
    "healthyRetryPolicy": {
      "minDelayTarget": 1,
      "maxDelayTarget": 60,
      "numRetries": 50,
      "numNoDelayRetries": 3,
      "numMinDelayRetries": 2,
      "numMaxDelayRetries": 35,
      "backoffFunction": "exponential"
    },
    "throttlePolicy": {
      "maxReceivesPerSecond": 10
    },
    "requestPolicy": {
      "headerContentType": "application/json"
    }
  }
  EOF
}