module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = local.name_prefix
  description   = "Random password generator"

  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"]
  source_path   = "./../src/main.py"

  # Environment variables
  environment_variables = {
    SAVE_TO_DDB = var.lambda_var_save_to_ddb
    DDB_TABLE   = var.lambda_var_save_to_ddb ? aws_dynamodb_table.main[0].name : null

    STR_LENGTH = var.lambda_var_str_length
    STR_COUNT  = var.lambda_var_str_count
    TTL        = var.lambda_var_ttl
  }

  # IAM Policy
  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:PutItem"],
      resources = ["arn:aws:dynamodb:${var.region}:${local.account_id}:table/${local.name_prefix}"]
    }
  }

  # Lambda function URL
  create_lambda_function_url = true
  authorization_type         = "AWS_IAM"

  # Logs
  cloudwatch_logs_retention_in_days = 3
}
