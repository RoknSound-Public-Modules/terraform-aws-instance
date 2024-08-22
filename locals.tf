locals {
  linux_instance       = var.ssh_user == null ? false : true
  windows_instance     = var.windows_instance
  iam_instance_profile = var.iam_instance_profile == null ? aws_iam_instance_profile.instance.name : var.iam_instance_profile
  create_instance_role = var.iam_instance_profile == null ? true : false
}
