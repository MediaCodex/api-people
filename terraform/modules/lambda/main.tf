resource "aws_lambda_permission" "default" {
  statement_id  = "AllowGatewayV2Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.gateway_execution_arn}/${var.stage}/${var.method}/${local.path}"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id                 = var.gateway_id
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = var.function_invoke_arn

  lifecycle {
    // https://github.com/terraform-providers/terraform-provider-aws/pull/13062
    ignore_changes = [passthrough_behavior]
  }
}

// with auth
resource "aws_apigatewayv2_route" "with_auth" {
  count              = var.authorizer_id != null ? 1 : 0
  api_id             = var.gateway_id
  route_key          = "${var.method} /${local.path}"
  target             = "integrations/${aws_apigatewayv2_integration.default.id}"
  authorizer_id      = var.authorizer_id
  authorization_type = "JWT"
}

// without auth
resource "aws_apigatewayv2_route" "without_auth" {
  count     = var.authorizer_id == null ? 1 : 0
  api_id    = var.gateway_id
  route_key = "${var.method} /${local.path}"
  target    = "integrations/${aws_apigatewayv2_integration.default.id}"
}
