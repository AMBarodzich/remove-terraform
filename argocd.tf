resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_helm_chart_version
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  atomic           = true
  timeout          = 1200
  skip_crds        = false

  values = [
    yamlencode({
      crds = {
        install = true
        keep    = true
      }
      configs = {
        params = {
          "server.insecure" = "true"
        }
      }
    }),
  ]

  depends_on = [module.eks]
}

resource "time_sleep" "wait_argocd_crds" {
  create_duration = "90s"
  depends_on      = [helm_release.argocd]
}

# Application Argo CD через локальный Helm-чарт (обход OpenAPI-проверки kubernetes_manifest до появления CRD).
resource "helm_release" "remove_app_argocd_application" {
  name      = "remove-app-application"
  chart     = "${path.module}/charts/remove-app-application"
  namespace = "argocd"

  depends_on = [time_sleep.wait_argocd_crds]

  values = [
    yamlencode({
      helmchartsRepoUrl        = var.helmcharts_repo_url
      helmchartsTargetRevision = var.helmcharts_target_revision
      removeAppK8sNamespace    = var.remove_app_k8s_namespace
      ecrRepositoryUrl         = module.ecr.repository_url
      removeAppImageTag        = var.remove_app_image_tag
      argocdNamespace          = "argocd"
    }),
  ]
}
