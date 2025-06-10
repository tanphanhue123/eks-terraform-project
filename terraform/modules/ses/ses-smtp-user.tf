#Using SMTP to Send Email with Amazon SES
resource "aws_iam_user" "ses_smtp_user" {
  count = var.ses_smtp_user != null ? 1 : 0

  name          = var.ses_smtp_user.name
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_policy" "ses_smtp_user_policy" {
  count = var.ses_smtp_user != null ? 1 : 0

  name   = "AmazonSesSendingAccess-for-${aws_iam_user.ses_smtp_user[0].name}"
  user   = aws_iam_user.ses_smtp_user[0].name
  policy = var.ses_smtp_user.policy
}

resource "aws_iam_access_key" "ses_smtp_user_iam_access_key" {
  count = var.ses_smtp_user != null ? 1 : 0

  user = aws_iam_user.ses_smtp_user[0].name
}
