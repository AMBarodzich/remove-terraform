resource "aws_iam_user" "github_actions_ecr" {
  name = "${var.project_name}-github-ecr-ci"
  path = "/"

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_user_policy" "github_actions_ecr_push" {
  name = "ecr-push"
  user = aws_iam_user.github_actions_ecr.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "GetAuthToken"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "PushImages"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
        ]
        Resource = [
          module.ecr_remove_app.repository_arn,
          module.ecr_remove_backend.repository_arn,
        ]
      },
    ]
  })
}

resource "aws_iam_access_key" "github_actions_ecr" {
  user = aws_iam_user.github_actions_ecr.name
}
