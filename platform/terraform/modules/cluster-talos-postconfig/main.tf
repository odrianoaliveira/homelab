resource "kubernetes_manifest" "node_lvm_bootstrap" {
  manifest = yamldecode(
    file("${path.module}/lvm/daemonset.yaml")
  )
}
