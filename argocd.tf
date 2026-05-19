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

# Argo CD Applications через локальный Helm-чарт (обход OpenAPI-проверки до появления CRD).
resource "helm_release" "argocd_applications" {
  for_each = local.argocd_applications

  name      = "${each.key}-application"
  chart     = "${path.module}/charts/argocd-helm-application"
  namespace = "argocd"

  depends_on = [time_sleep.wait_argocd_crds]

  values = [
    yamlencode({
      applicationName          = each.key
      helmChartPath            = each.value.helm_chart_path
      helmchartsRepoUrl        = var.helmcharts_repo_url
      helmchartsTargetRevision = var.helmcharts_target_revision
      k8sNamespace             = each.value.k8s_namespace
      ecrRepositoryUrl         = each.value.ecr_repo_url
      argocdNamespace          = "argocd"
    }),
  ]
}