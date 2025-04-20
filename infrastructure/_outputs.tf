output "lambda_function_url" {
  value = module.lambda.lambda_function_url
}

output "bash_alias" {
  value = "alias pwdgen='awscurl --region ${var.region} --service lambda ${module.lambda.lambda_function_url}'"
}
