
resource "kubernetes_storage_class" "garage_local" {
  metadata {
    name = "garage-local"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
}
