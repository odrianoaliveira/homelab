
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace_v1" "minio_tf_state" {
  metadata {
    name = "minio-tf-state"

    labels = {
      "app.kubernetes.io/name"    = "minio-tf-state"
      "app.kubernetes.io/part-of" = "platform"
      "env"                       = "homelab"
    }
  }
}

resource "kubernetes_manifest" "minio_tenant" {
  manifest = yamldecode(file("${path.module}/minio-tenant.yaml"))
}
