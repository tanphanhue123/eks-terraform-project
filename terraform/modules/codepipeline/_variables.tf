#modules/codepipeline/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#codepipeline
variable "codepipeline" {
  description = "All configuration to Provides a CodePipeline."
  type = object({
    name     = string
    role_arn = string
    artifact_store = object({
      bucket_id   = string
      kms_key_arn = optional(string, null)
      region      = optional(string, null)
    })
    stages = list(object({
      name = string
      actions = list(object({
        version          = number
        run_order        = number
        category         = string #Approval, Build, Deploy, Invoke, Source and Test.
        name             = string
        provider         = string
        input_artifacts  = optional(list(string), null)
        output_artifacts = optional(list(string), null)
        namespace        = optional(string, null)
        role_arn         = optional(string, null)
        region           = optional(string, null)
        configuration    = optional(map(any), {})
      }))
    }))

  })
}

#codepipeline-notification-rule
variable "codepipeline_notification_rule" {
  description = "Provides a CodeStar Notifications Rule for CodePipeline."
  default     = null
  type = object({
    status      = optional(string, "ENABLED")
    detail_type = optional(string, "FULL")
    event_type_ids = optional(list(string),
      [
        #Stage execution
        "codepipeline-pipeline-stage-execution-resumed",
        #Pipeline execution
        "codepipeline-pipeline-pipeline-execution-failed",
        "codepipeline-pipeline-pipeline-execution-canceled",
        "codepipeline-pipeline-pipeline-execution-started",
        "codepipeline-pipeline-pipeline-execution-succeeded",
        "codepipeline-pipeline-pipeline-execution-superseded"
      ]
    )
    sns_topic_arn = string
  })
}
