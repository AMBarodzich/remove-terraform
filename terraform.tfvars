aws_region          = "us-east-1"
project_name        = "lesson23"
cluster_version     = "1.35"
# Два ECR — по одному на микросервис (имена = ECR_REPOSITORY в GitHub Actions каждого репо).
ecr_remove_app_repository_name     = "lesson23-app"
ecr_remove_backend_repository_name = "lesson23-remove-backend"

argocd_helm_chart_version  = "9.5.14"
# Чарты: https://github.com/AMBarodzich/remove-helmcharts (ветка main)
helmcharts_target_revision   = "main"
remove_app_k8s_namespace     = "remove-app"
remove_backend_k8s_namespace = "remove-backend"
