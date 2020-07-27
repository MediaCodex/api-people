resource "aws_iam_role_policy" "cloudwatch" {
  name   = "Cloudwatch"
  role   = var.role
  policy = data.aws_iam_policy_document.cloudwatch.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid = "LogGroup"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }

  statement {
    sid = "WriteLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:eu-central-1:*:log-group:/aws/lambda/${var.name}:*"
    ]
  }
}
