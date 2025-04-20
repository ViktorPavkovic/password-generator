locals {
  account_id = data.aws_caller_identity.current.account_id

  name_prefix = "${var.project}-${var.env}"
}
