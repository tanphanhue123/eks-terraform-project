# Create ECR
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project}-${var.env}-${var.ecr_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.ecr_name}"
  }
}

# Lifecycle policy for ECR
resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = var.ecr_lifecycle_policy
}
