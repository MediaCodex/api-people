resource "aws_lambda_function" "http_index" {
  function_name = "people-http-index"
  role          = aws_iam_role.lambda_http_index.arn

  // handler
  source_code_hash = filebase64sha256("../build/http-index.js.zip")
  filename         = "../build/http-index.js.zip"
  handler          = "lumigo-auto-instrument.handler"

  // runtime
  runtime = "nodejs12.x"
  timeout = "15"
  layers  = [var.lumigo_layer]

  environment {
    variables = {
      LUMIGO_TRACER_TOKEN     = var.lumigo_token
      LUMIGO_ORIGINAL_HANDLER = "http-index.default"
    }
  }

  tags = var.default_tags
}

resource "aws_iam_role" "lambda_http_index" {
  name               = "people-http-index"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

module "lambda_http_index_gateway" {
  source = "./modules/lambda"
  method = "GET"
  path   = "/people"

  function_name       = "people-http-index"
  function_invoke_arn = aws_lambda_function.http_index.invoke_arn

  gateway_id            = data.terraform_remote_state.core.outputs.gateway_id
  gateway_execution_arn = data.terraform_remote_state.core.outputs.gateway_execution
}

/*
 * Permissions
 */
module "lambda_http_index_dynamodb" {
  source = "./modules/iam-dynamodb"
  role   = aws_iam_role.lambda_http_index.id
  table  = aws_dynamodb_table.people.arn
  read   = true
}

module "lambda_http_index_cloudwatch" {
  source = "./modules/iam-cloudwatch"
  role   = aws_iam_role.lambda_http_index.id
  name   = "people-http-index"
}
