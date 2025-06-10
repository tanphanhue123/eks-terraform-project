###################
# Verify Domain
###################
resource "aws_ses_domain_identity" "ses_domain_identity" {
  domain = var.ses_domain_identity
}

###################
# Verification Records
###################
#1. TXT Record
resource "aws_route53_record" "ses_verification_txt_record" {
  zone_id = var.route53_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain_identity.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain_identity.verification_token]
}

#2. DKIM Record
resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = aws_ses_domain_identity.ses_domain_identity.domain
}

resource "aws_route53_record" "ses_verification_dkim_record" {
  count = 3

  zone_id = var.route53_zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.ses_domain_identity.id}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

###################
# Verify Email
###################
resource "aws_ses_email_identity" "ses_email_identity" {
  for_each = toset(var.ses_email_identities)

  email = each.value
}
