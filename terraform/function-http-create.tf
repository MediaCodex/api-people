resource "aws_lambda_function" "http_create" {
  function_name = "people-http-create"
  role          = aws_iam_role.lambda_http_create.arn

  // handler
  source_code_hash = filebase64sha256("../build/http-create.js.zip")
  filename         = "../build/http-create.js.zip"
  handler          = "lumigo-auto-instrument.handler"

  // runtime
  runtime = "nodejs12.x"
  timeout = "15"
  layers  = [var.lumigo_layer]

  environment {
    variables = {
      LUMIGO_TRACER_TOKEN     = var.lumigo_token
      LUMIGO_ORIGINAL_HANDLER = "http-create.default"
    }
  }

  tags = var.default_tags
}

resource "aws_iam_role" "lambda_http_create" {
  name               = "people-http-create"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}


module "lambda_http_create_gateway" {
  source = "./modules/lambda"
  method = "POST"
  path   = "/people"

  function_name       = "people-http-create"
  function_invoke_arn = aws_lambda_function.http_create.invoke_arn

  gateway_id            = data.terraform_remote_state.core.outputs.gateway_id
  gateway_execution_arn = data.terraform_remote_state.core.outputs.gateway_execution

  authorizer_id = data.terraform_remote_state.core.outputs.authorizer
}

/*
 * Permissions
 */
module "lambda_http_create_dynamodb" {
  source = "./modules/iam-dynamodb"
  role   = aws_iam_role.lambda_http_create.id
  table  = aws_dynamodb_table.people.arn
  write  = true
  read   = true
}

module "lambda_http_create_cloudwatch" {
  source = "./modules/iam-cloudwatch"
  role   = aws_iam_role.lambda_http_create.id
  name   = "people-http-create"
}
