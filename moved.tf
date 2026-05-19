moved {
  from = helm_release.remove_app_argocd_application
  to   = helm_release.argocd_applications["remove-app"]
}

moved {
  from = module.ecr
  to   = module.ecr_remove_app
}

moved {
  from = module.ecr_backend
  to   = module.ecr_remove_backend
}

moved {
  from = helm_release.argocd_applications["terraform-backend"]
  to   = helm_release.argocd_applications["remove-backend"]
}
