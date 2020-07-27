locals {
  path = trimprefix(var.path, "/")
}

variable "gateway_id" {
  type        = string
  description = "ApiGatewayV2 ID"
}

variable "gateway_execution_arn" {
  type        = string
  description = "ApiGatewayV2 Execution ARN"
}

variable "function_name" {
  type        = string
  description = "Name of lambda function"
}

variable "function_invoke_arn" {
  type        = string
  description = "Invoke ARN for lambda function"
}

variable "authorizer_id" {
  type        = string
  description = "ApiGatewayV2Authorizer ID"
  default     = null
}

variable "stage" {
  type        = string
  description = "Name of ApiGatewayV2 Stage"
  default     = "v1"
}

variable "method" {
  type        = string
  description = "HTTP method"
  default     = "GET"
}

variable "path" {
  type = string
}