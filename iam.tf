data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  count              = local.create_instance_role ? 1 : 0
  name               = lookup(var.required_tags, "Name")
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "instance" {
  count  = local.create_instance_role ? 1 : 0
  name   = lookup(var.required_tags, "Name")
  role   = one(aws_iam_role.instance).id
  policy = var.iam_policy
}

resource "aws_iam_instance_profile" "instance" {
  count = local.create_instance_role ? 1 : 0
  name  = lookup(var.required_tags, "Name")
  role  = one(aws_iam_role.instance).name
}
