resource "aws_dynamodb_table" "people" {
  name         = "people"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "slug"
    type = "S"
  }

  global_secondary_index {
    name               = "slug"
    hash_key           = "slug"
    projection_type    = "ALL"
  }

  tags = var.default_tags
}