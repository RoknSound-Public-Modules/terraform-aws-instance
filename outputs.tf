
output "linux_ssh" {
  value = templatefile("$(path.module)/ssh", {
    secret_id = aws_secretsmanager_secret.ssh_key[0].id,
    key_name  = aws_key_pair.deployer.key_name,
  })
}

output "linux_hosts" {
  value = local.linux_instance ? var.enable_public_ip ? aws_instance.linux[*].public_ip : aws_instance.linux[*].private_ip : []
}
