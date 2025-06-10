resource "aws_sns_topic_policy" "cloudwatch_policy" {
  count = var.service == "cloudwatch" ? 1 : 0

  arn = aws_sns_topic.sns_topic.arn
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "__custom_policy_ID",
      "Statement" : [
        {
          "Sid" : "_events_service_access_ID",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "events.amazonaws.com"
          },
          "Action" : "SNS:Publish",
          "Resource" : aws_sns_topic.sns_topic.arn,
        },
        {
          "Sid" : "__default_statement_ID",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "*"
          },
          "Action" : [
            "SNS:Subscribe",
            "SNS:SetTopicAttributes",
            "SNS:RemovePermission",
            "SNS:Receive",
            "SNS:Publish",
            "SNS:ListSubscriptionsByTopic",
            "SNS:GetTopicAttributes",
            "SNS:DeleteTopic",
            "SNS:AddPermission"
          ],
          "Resource" : aws_sns_topic.sns_topic.arn,
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceOwner" : data.aws_caller_identity.current.account_id
            }
          }
        }
      ]
    }
  )
}
