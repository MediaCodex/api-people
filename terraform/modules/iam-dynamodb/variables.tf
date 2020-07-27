variable "role" {
  type        = string
  description = "ARN of IAM role to attach the policy to"
}

variable "table" {
  type        = string
  description = "ARN of DynamoDB table"
}

variable "read" {
  type        = bool
  description = "Allow reading of items from the table"
  default     = false
}

variable "write" {
  type        = bool
  description = "Allow writing items to the table"
  default     = false
}

variable "delete" {
  type        = bool
  description = "Allow deletion of items from the table"
  default     = false
}