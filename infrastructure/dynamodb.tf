resource "aws_dynamodb_table" "main" {
  count = var.lambda_var_save_to_ddb ? 1 : 0

  name         = local.name_prefix
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "password"

  attribute {
    name = "password"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}
