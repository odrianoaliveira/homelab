
resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"

    labels = {
      "app.kubernetes.io/part-of" = "platform"
      "env"                       = "homelab"
    }
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [
    kubernetes_namespace_v1.cert_manager
  ]

  name       = "cert-manager"
  namespace  = kubernetes_namespace_v1.cert_manager.metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.19.2"

  timeout       = 600
  wait          = true
  wait_for_jobs = true
  atomic        = true

  values = [
    yamlencode({
      installCRDs = true
    })
  ]
}

