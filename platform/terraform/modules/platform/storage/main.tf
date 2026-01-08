
locals {
  values = [
    <<-EOT
    lvmd:
      deviceClasses:
        - name: garage
          volume-group: vg_garage
          default: true
    EOT
  ]
}

resource "kubernetes_namespace_v1" "storage" {
  metadata {
    name = "topolvm-storage"

    labels = {
      "app.kubernetes.io/part-of"                  = "platform"
      "env"                                        = "homelab"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/enforce"         = "privileged"
      "pod-security.kubernetes.io/audit"           = "privileged"
      "pod-security.kubernetes.io/warn"            = "privileged"
    }
  }
}

resource "helm_release" "topolvm" {
  depends_on = [
    kubernetes_namespace_v1.storage
  ]

  name       = "topolvm"
  namespace  = kubernetes_namespace_v1.storage.metadata[0].name
  repository = "https://topolvm.github.io/topolvm"
  chart      = "topolvm"
  version    = "15.8.0"

  timeout       = 600
  wait          = true
  wait_for_jobs = true
  atomic        = true

  values = local.values
}
