locals {
  argocd_applications = {
    remove-app = {
      helm_chart_path = "remove-app"
      k8s_namespace   = var.remove_app_k8s_namespace
      ecr_repo_url    = module.ecr_remove_app.repository_url
    }
    remove-backend = {
      helm_chart_path = "remove-backend"
      k8s_namespace   = var.remove_backend_k8s_namespace
      ecr_repo_url    = module.ecr_remove_backend.repository_url
    }
  }
}
