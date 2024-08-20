resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_pet" "keyname" {
  keepers = {
    ami_id = data.aws_ssm_parameter.ami.value
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deployer-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_secretsmanager_secret" "ssh_key" {
  count = tobool(lookup(data.aws_ssm_parameter.params, "troubleshoot").value) ? 1 : 0
  name  = "/image-pipeline/${var.project_name}/ssh-private-key-${random_pet.keyname.id}"
}

resource "aws_secretsmanager_secret_version" "ssh_key" {
  count         = tobool(lookup(data.aws_ssm_parameter.params, "troubleshoot").value) ? 1 : 0
  secret_id     = one(aws_secretsmanager_secret.ssh_key).id
  secret_string = tls_private_key.ssh.private_key_pem
}
