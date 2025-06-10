locals {
  content_type = { #https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
    "us-east-1"      = "316112463485"
    "us-east-2"      = "646659390643"
    "us-west-1"      = "166987590008"
    "us-west-2"      = "758058086616"
    "ap-south-1"     = "162588757376"
    "ap-northeast-2" = "526946625049"
    "ap-southeast-2" = "454640832652"
    "ap-northeast-1" = "406045910587"
    "eu-central-1"   = "537503971621"
    "eu-west-1"      = "357557129151"
    "eu-west-2"      = "146838936955"
    "eu-north-1"     = "453420244670"
  }
  inspector_region_id = lookup(local.content_type, var.region, null)
}

resource "aws_sns_topic_policy" "inspector_policy" {
  count = var.service == "inspector" ? 1 : 0

  arn = aws_sns_topic.sns_topic.arn
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "__custom_policy_ID",
      "Statement" : [
        {
          "Sid" : "_inspector_service_access_ID",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${local.inspector_region_id}:root"
          },
          "Action" : [
            "SNS:Subscribe",
            "SNS:Receive",
            "SNS:Publish"
          ],
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
