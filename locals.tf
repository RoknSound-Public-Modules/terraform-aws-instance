locals {
  has_secrets           = contains(split(",", data.aws_ssm_parameter.parameter_list.value), "secrets") ? true : false
  _parameter_list       = [for x in toset(split(",", data.aws_ssm_parameter.parameter_list.value)) : issensitive(x) ? tostring(nonsensitive(x)) : tostring(x)]
  parameter_list        = toset(issensitive(local._parameter_list) ? nonsensitive(local._parameter_list) : local._parameter_list)
  secrets_list          = local.has_secrets ? toset(split(",", one(data.aws_ssm_parameter.secrets_list).value)) : toset([])
  nonsensitive_key_list = issensitive(local.secrets_list) ? nonsensitive(local.secrets_list) : local.secrets_list
  linux_instance        = lookup(data.aws_ssm_parameter.params, "ssh_user", { value = "notset" }).value == "notset" ? false : true
  windows_instance      = contains(local.secrets_list, "winrm_credentials") ? true : false
  _goss_profile         = lookup(data.aws_ssm_parameter.params, "goss_profile").value
  goss_profile          = issensitive(local._goss_profile) ? nonsensitive(local._goss_profile) : local._goss_profile
}
