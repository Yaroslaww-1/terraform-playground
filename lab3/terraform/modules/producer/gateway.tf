resource "aws_apigatewayv2_api" "producer_gateway" {
  name          = "producer_gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "producer_gateway" {
  api_id = aws_apigatewayv2_api.producer_gateway.id

  name        = "producer_gateway_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.producer_gateway_logs.arn

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
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "producer_gateway_integration" {
  api_id = aws_apigatewayv2_api.producer_gateway.id

  integration_uri    = aws_lambda_function.producer_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "producer_gateway_integration" {
  api_id = aws_apigatewayv2_api.producer_gateway.id

  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.producer_gateway_integration.id}"
}

resource "aws_cloudwatch_log_group" "producer_gateway_logs" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.producer_gateway.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "producer_gateway_logs" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.producer_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.producer_gateway.execution_arn}/*/*"
}
