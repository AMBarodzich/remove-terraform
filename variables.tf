variable "aws_region" {
  type        = string
  description = "Регион AWS для провайдера и ресурсов. Должен совпадать с region в backend S3 (см. versions.tf)."
}

variable "project_name" {
  type        = string
  description = "Префикс имён ресурсов"
}

variable "cluster_version" {
  type        = string
  description = "Версия Kubernetes для EKS (<major>.<minor>, например 1.35)"
}

variable "ecr_repository_name" {
  type        = string
  description = "Имя репозитория ECR"
}

variable "argocd_helm_chart_version" {
  type        = string
  description = "Версия Helm-чарта argo-cd (https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)"
}

variable "helmcharts_repo_url" {
  type        = string
  description = "HTTPS URL репозитория с Helm-чартами (чарт remove-app в подкаталоге remove-app/). По умолчанию: https://github.com/AMBarodzich/remove-helmcharts"
  default     = "https://github.com/AMBarodzich/remove-helmcharts"
}

variable "helmcharts_target_revision" {
  type        = string
  description = "Ветка или тег в helmcharts_repo_url для Argo CD Application"
}

variable "remove_app_k8s_namespace" {
  type        = string
  description = "Namespace в кластере для деплоя remove-app"
}

