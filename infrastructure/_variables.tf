# General
variable "project" {
  type        = string
  description = "The project name."
  default     = "pwdgen"
}

variable "env" {
  type        = string
  description = "The environment name."
  default     = "prod"
}


# AWS
variable "region" {
  type        = string
  description = "The main AWS region."
  default     = "eu-central-1"
}


# Lambda
variable "lambda_var_str_length" {
  type        = number
  description = "The length of each string in password."
  default     = 8
}

variable "lambda_var_str_count" {
  type        = number
  description = "Number of strings in password."
  default     = 4
}

variable "lambda_var_save_to_ddb" {
  type        = bool
  description = "Whether to save the generated passwords to the DynamoDB table."
  default     = true
}

variable "lambda_var_ttl" {
  type        = number
  description = "Time to live for generated passwords in DynamoDB table in seconds."
  default     = 3600 # 1h
}
