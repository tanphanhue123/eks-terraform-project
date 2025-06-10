module "ecr_app" {
  source = "../../../modules/ecr"
  #basic
  env     = var.env
  project = var.project

  #ecr
  ecr_name = "chatapp"
  ecr_lifecycle_policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 10,
          "description" : "Keep last 5 images untagged",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "imageCountMoreThan",
            "countNumber" : 5
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 20,
          "description" : "Keep last 5 images tagged",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : [
              var.project
            ],
            "countType" : "imageCountMoreThan",
            "countNumber" : 5
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 30,
          "description" : "Keep last 40 images any",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : 40
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}
