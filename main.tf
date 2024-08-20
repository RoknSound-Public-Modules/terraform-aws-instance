# Description: This file is used to create the AWS resources using Terraform.
resource "aws_instance" "linux" {
  count                   = local.linux_instance ? 1 : 0
  ami                     = data.aws_ssm_parameter.ami.value
  instance_type           = var.instance_type
  disable_api_termination = tobool(var.troubleshoot)
  disable_api_stop        = tobool(var.troubleshoot)
  subnet_id               = var.subnets
  vpc_security_group_ids  = var.security_group_ids
  key_name                = aws_key_pair.deployer.key_name

  tags = {
    Name    = "${var.project_name}"
    Project = var.project_name
  }

  root_block_device {
    volume_size = 80
  }

  depends_on = [
    aws_key_pair.deployer
  ]
}

resource "null_resource" "instance_provisioner" {
  count = local.linux_instance && var.config != null ? 1 : 0
  connection {
    type        = "ssh"
    user        = var.ssh_user.value
    private_key = tls_private_key.ssh.private_key_pem
    host        = self.private_ip
  }

  provisioner "file" {
    source      = var.config.src
    destination = var.config.dest
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.config.dest}",
      "${var.config.script} ${var.config.args}"
    ]
  }

}