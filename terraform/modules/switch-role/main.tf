resource "aws_iam_role" "iam_role" {
  name               = var.switch_role_name
  description        = var.switch_role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "aws_managed_policy" {
  count = length(var.aws_managed_policy_arn)

  role       = aws_iam_role.iam_role.name
  policy_arn = element(var.aws_managed_policy_arn, count.index)
}

resource "aws_iam_role_policy" "iam_custom_policy" {
  count = var.iam_custom_policy != null ? 1 : 0

  name   = var.switch_role_name
  role   = aws_iam_role.iam_role.id
  policy = var.iam_custom_policy.template
}
