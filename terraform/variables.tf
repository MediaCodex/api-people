locals {
  environment = "${lookup(var.environments, terraform.workspace, "dev")}"
}

variable "environments" {
  type = map(string)
  default = {
    development = "dev"
    production  = "prod"
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Common resource tags for all resources"
  default = {
    Service = "people"
  }
}

variable "terraform_state" {
  type = map(string)
  default = {
    bucket = "arn:aws:s3:::terraform-state-mediacodex"
    dynamo = "arn:aws:dynamodb:eu-central-1:939514526661:table/terraform-state-lock"
  }
}

variable "lumigo_layer" {
  type    = string
  default = "arn:aws:lambda:eu-central-1:114300393969:layer:lumigo-node-tracer:80"
}

variable "lumigo_token" {
  type    = string
  default = ""
}
