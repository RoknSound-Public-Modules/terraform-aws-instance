output "linux_instnace" {
  value = local.linux_instance ? aws_instance.linux : []
}

# output "windows_instance" {
#   value = local.windows_instance ? aws_instance.windows : []
# }
