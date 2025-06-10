resource "aws_iam_user" "main" {
  for_each = toset(var.iam_users)

  name          = each.key
  path          = "/"
  force_destroy = true
}
