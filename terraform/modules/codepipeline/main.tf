resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline"
  role_arn = var.codepipeline.role_arn

  artifact_store {
    location = var.codepipeline.artifact_store.bucket_id
    type     = "S3"

    dynamic "encryption_key" {
      for_each = var.codepipeline.artifact_store.kms_key_arn != null ? [1] : []

      content {
        id   = var.codepipeline.artifact_store.kms_key_arn
        type = "KMS"
      }
    }
    region = var.codepipeline.artifact_store.region
  }

  dynamic "stage" {
    for_each = var.codepipeline.stages

    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.actions

        content {
          owner            = "AWS"
          version          = action.value.version
          run_order        = action.value.run_order
          category         = action.value.category
          name             = action.value.name
          provider         = action.value.provider
          input_artifacts  = action.value.input_artifacts
          output_artifacts = action.value.output_artifacts
          namespace        = action.value.namespace
          role_arn         = action.value.role_arn
          region           = action.value.region
          configuration    = action.value.configuration
        }
      }
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline"
  }
}

resource "aws_codestarnotifications_notification_rule" "codepipeline_notification_rule" {
  count = var.codepipeline_notification_rule != null ? 1 : 0

  name           = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline-notification-rule"
  resource       = aws_codepipeline.codepipeline.arn
  status         = var.codepipeline_notification_rule.status
  detail_type    = var.codepipeline_notification_rule.detail_type
  event_type_ids = var.codepipeline_notification_rule.event_type_ids

  target {
    address = var.codepipeline_notification_rule.sns_topic_arn
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline-notification-rule"
  }
}
