resource "aws_instance" "windows" {
  count                   = local.windows_instance ? 1 : 0
  ami                     = data.aws_ssm_parameter.ami.value
  instance_type           = lookup(data.aws_ssm_parameter.params, "instance_type").value
  disable_api_termination = true
  subnet_id               = lookup(data.aws_ssm_parameter.params, "subnets").value
  vpc_security_group_ids  = split(",", lookup(data.aws_ssm_parameter.params, "security_group_ids").value)
  key_name                = aws_key_pair.deployer.key_name

  tags = {
    Name    = "${var.project_name}"
    Project = var.project_name
  }

  root_block_device {
    volume_size = 80
  }

  connection {
    type     = "winrm"
    user     = jsondecode(lookup(data.aws_secretsmanager_secret_version.secret_version, "winrm_credentials").secret_string).username
    password = jsondecode(lookup(data.aws_secretsmanager_secret_version.secret_version, "winrm_credentials").secret_string).password
    host     = self.private_dns
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir %TEMP%\\goss"
    ]
  }

  provisioner "file" {
    source      = "${var.goss_directory}/goss-files"
    destination = "%TEMP%\\goss\\goss-files"
  }

  provisioner "file" {
    source      = "${var.goss_directory}/dependencies"
    destination = "%TEMP%\\goss\\dependencies"
  }

  provisioner "local-exec" {
    command = "echo ${data.aws_ssm_parameter.ami.value} > tf_ami_id.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "%TEMP%\\goss\\dependencies/goss -g %TEMP%\\goss\\goss-files\\${lookup(data.aws_ssm_parameter.params, "goss_profile").value}.yaml validate"
    ]
  }

  provisioner "local-exec" {
    command = "rm tf_ami_id.txt"
  }

  depends_on = [
    aws_key_pair.deployer
  ]
}
