resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_helm_chart_version
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 900

  values = [
    yamlencode({
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
  create_duration = "45s"
  depends_on      = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_application_remove_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "remove-app"
      namespace = helm_release.argocd.namespace
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.helmcharts_repo_url
        path           = "remove-app"
        targetRevision = var.helmcharts_target_revision
        helm = {
          values = yamlencode({
            image = {
              repository = module.ecr.repository_url
              tag          = var.remove_app_image_tag
            }
          })
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.remove_app_k8s_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }

  field_manager = "terraform"
  depends_on    = [time_sleep.wait_argocd_crds]
}
