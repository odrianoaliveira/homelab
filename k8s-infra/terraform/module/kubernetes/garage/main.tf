
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace_v1" "garage" {
  metadata {
    name = "garage-system"

    labels = {
      "app.kubernetes.io/name"    = "garage"
      "app.kubernetes.io/part-of" = "platform"
      "env"                       = "homelab"
    }
  }
}

resource "helm_release" "garage" {
  name      = "garage"
  namespace = kubernetes_namespace_v1.garage.metadata[0].name
  # https://github.com/deuxfleurs-org/garage/tree/main/script/helm
  repository = "https://garagehq.deuxfleurs.fr/charts/"
  chart      = "garage"
  version    = "0.6.0"

  values = [
    file("${path.module}/values.garage.yaml")
  ]

  timeout = 600
  wait    = true

  depends_on = [
    kubernetes_namespace_v1.garage
  ]
}
