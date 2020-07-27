resource "aws_lambda_function" "http_update" {
  function_name = "people-http-update"
  role          = aws_iam_role.lambda_http_update.arn

  // handler
  source_code_hash = filebase64sha256("../build/http-update.js.zip")
  filename         = "../build/http-update.js.zip"
  handler          = "lumigo-auto-instrument.handler"

  // runtime
  runtime = "nodejs12.x"
  timeout = "15"
  layers  = [var.lumigo_layer]

  environment {
    variables = {
      LUMIGO_TRACER_TOKEN     = var.lumigo_token
      LUMIGO_ORIGINAL_HANDLER = "http-update.default"
    }
  }

  tags = var.default_tags
}

resource "aws_iam_role" "lambda_http_update" {
  name               = "people-http-update"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}


module "lambda_http_update_gateway" {
  source = "./modules/lambda"
  method = "PUT"
  path   = "/people/{id}"

  function_name       = "people-http-update"
  function_invoke_arn = aws_lambda_function.http_update.invoke_arn

  gateway_id            = data.terraform_remote_state.core.outputs.gateway_id
  gateway_execution_arn = data.terraform_remote_state.core.outputs.gateway_execution

  authorizer_id = data.terraform_remote_state.core.outputs.authorizer
}

/*
 * Permissions
 */
module "lambda_http_update_dynamodb" {
  source = "./modules/iam-dynamodb"
  role   = aws_iam_role.lambda_http_update.id
  table  = aws_dynamodb_table.people.arn
  write  = true
  read   = true
}

module "lambda_http_update_cloudwatch" {
  source = "./modules/iam-cloudwatch"
  role   = aws_iam_role.lambda_http_update.id
  name   = "people-http-update"
}
