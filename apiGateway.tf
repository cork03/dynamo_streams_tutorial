//ベースリソース
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "serverless_api"
  protocol_type = "HTTP"
}
//stage設定
resource "aws_apigatewayv2_stage" "lambda_api" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  name   = "lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda_api.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}
//統合設定
resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  integration_uri = module.api_gateway_lambda.lambda_invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}
//ルーティング設定
resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  route_key = "POST /api_gw"
  target = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_cloudwatch_log_group" "lambda_api" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_api.name}"

  retention_in_days = 30
}
//外部のリソースがlambdaにアクセスするための設定
resource "aws_lambda_permission" "api_gw" {
  action = "lambda:InvokeFunction"
  function_name = module.api_gateway_lambda.lambda_function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}



