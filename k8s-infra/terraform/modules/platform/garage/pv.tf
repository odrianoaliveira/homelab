resource "kubernetes_persistent_volume" "garage_pv" {
  depends_on = [kubernetes_storage_class.garage_local]
  for_each   = toset(var.nodes)

  metadata {
    name = "garage-pv-${each.value}"
  }

  spec {
    capacity = {
      storage = "20Gi"
    }

    persistent_volume_source {
      local {
        path = "/var/mnt/minio"
      }
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = kubernetes_storage_class.garage_local.metadata[0].name

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = [each.value]
          }
        }
      }
    }
  }
}
