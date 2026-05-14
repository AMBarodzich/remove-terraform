output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Публичные подсети"
  value       = module.vpc.public_subnets
}

output "ecr_repository_url" {
  description = "URL репозитория ECR"
  value       = module.ecr.repository_url
}

output "github_actions_ecr_access_key_id" {
  description = "Access Key ID для GitHub secret AWS_ACCESS_KEY_ID (IAM user для push в ECR)"
  value       = aws_iam_access_key.github_actions_ecr.id
}

output "github_actions_ecr_secret_access_key" {
  description = "Secret Access Key для GitHub secret AWS_SECRET_ACCESS_KEY. Показывается только при создании; храните в Secrets Manager / GitHub secrets, не коммитьте."
  value       = aws_iam_access_key.github_actions_ecr.secret
  sensitive   = true
}

output "eks_cluster_name" {
  description = "Имя кластера EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "CA data для kubectl"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "configure_kubectl" {
  description = "Команда для kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "argocd_ui_port_forward" {
  description = "Доступ к UI Argo CD (после kubeconfig): порт 8080 → HTTP insecure"
  value       = "kubectl port-forward svc/argocd-server -n argocd 8080:443"
}

output "argocd_initial_admin_password_command" {
  description = "Показать начальный пароль пользователя admin"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d && echo"
}
