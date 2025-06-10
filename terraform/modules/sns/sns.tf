data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "sns_topic" {
  name         = "${var.project}-${var.env}-${var.sns_topic_name}-topic"
  display_name = "${var.sns_topic_name} with ${var.service} policy"

  tags = {
    Service = var.service
  }
}
