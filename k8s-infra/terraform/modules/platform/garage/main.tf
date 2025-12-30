resource "kubernetes_namespace_v1" "garage" {
  metadata {
    name = "garage"
  }
}

resource "helm_release" "garage" {
  depends_on = [kubernetes_namespace_v1.garage]

  name      = "garage"
  namespace = kubernetes_namespace_v1.garage.metadata[0].name
  chart     = abspath("${path.module}/../../../../../vendor/garage/script/helm/garage")
  version   = "0.9.1"

  values = [
    file("${path.module}/values.yaml")
  ]

  timeout = 600
  wait    = true
}
