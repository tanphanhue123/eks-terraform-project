resource "aws_iam_group" "main" {
  name = var.iam_group_name
  path = "/"
}

resource "aws_iam_group_policy_attachment" "aws_managed_policy" {
  count = length(var.aws_managed_policy_arn)

  group      = aws_iam_group.main.name
  policy_arn = element(var.aws_managed_policy_arn, count.index)
}

resource "aws_iam_group_policy" "custom_policy" {
  count = var.iam_custom_policy != null ? 1 : 0

  name   = "${var.iam_group_name}-policy"
  group  = aws_iam_group.main.name
  policy = var.iam_custom_policy
}

resource "aws_iam_group_membership" "main" {
  name  = "${var.iam_group_name}-group-membership"
  users = var.user_attachments
  group = aws_iam_group.main.name
}
