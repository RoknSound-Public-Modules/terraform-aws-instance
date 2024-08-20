data "aws_ssm_parameter" "parameter_list" {
  name = "/image-pipeline/${var.project_name}/parameters"
}

data "aws_ssm_parameter" "secrets_list" {
  count = local.has_secrets ? 1 : 0
  name  = "/image-pipeline/${var.project_name}/secrets"
}

data "aws_ssm_parameter" "params" {
  for_each = toset(local.parameter_list)
  name     = "/image-pipeline/${var.project_name}/${each.value}"
}

data "aws_ssm_parameter" "ami" {
  name = "/image-pipeline/${var.project_name}/ami"
}

data "aws_secretsmanager_secret" "secrets" {
  for_each = local.nonsensitive_key_list
  name     = "/image-pipeline/${var.project_name}/${each.key}"
}

data "aws_secretsmanager_secret_version" "secret_version" {
  for_each = tomap({
    for secret in local.nonsensitive_key_list :
    secret => lookup(data.aws_secretsmanager_secret.secrets, secret).id
  })
  secret_id = each.value
}