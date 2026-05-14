aws_region          = "us-east-1"
project_name        = "lesson23"
cluster_version     = "1.35"
ecr_repository_name = "lesson23-app"

argocd_helm_chart_version  = "9.5.14"
# Чарт remove-app: https://github.com/AMBarodzich/remove-helmcharts (ветка main, path remove-app/)
helmcharts_target_revision = "main"
remove_app_k8s_namespace     = "remove-app"
remove_app_image_tag         = "latest"
