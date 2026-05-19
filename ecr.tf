# Два репозитория ECR: образы для Argo CD Applications remove-app и remove-backend.

module "ecr_remove_app" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.4.0"

  repository_name                 = var.ecr_remove_app_repository_name
  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images when count exceeds 30"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
    Service = "remove-app"
  }
}

module "ecr_remove_backend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.4.0"

  repository_name                 = var.ecr_remove_backend_repository_name
  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images when count exceeds 30"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
    Service = "remove-backend"
  }
}
