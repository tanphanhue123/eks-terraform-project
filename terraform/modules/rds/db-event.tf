resource "aws_db_event_subscription" "aurora_event" {
  count = var.aurora_event != null ? 1 : 0

  name             = "${var.project}-${var.env}-${var.name}-event"
  source_ids       = [aws_rds_cluster.aurora_cluster.id]
  source_type      = var.aurora_event.source_type
  event_categories = var.aurora_event.event_categories
  sns_topic        = var.aurora_event.sns_topic_arn
}
