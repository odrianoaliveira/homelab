resource "kubernetes_persistent_volume_claim" "garage" {
  depends_on = [kubernetes_persistent_volume.garage_pv]

  metadata {
    name      = "garage-pvc"
    namespace = kubernetes_namespace_v1.garage.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = kubernetes_storage_class.garage_local.metadata[0].name
  }
}
