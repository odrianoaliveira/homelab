resource "kubernetes_namespace_v1" "garage" {
  metadata {
    name = "garage"
  }
}

resource "helm_release" "topolvm" {
  name             = "topolvm"
  repository       = "https://topolvm.github.io/topolvm"
  chart            = "topolvm"
  namespace        = "topolvm-system"
  create_namespace = true

  values = [
    <<-EOT
    admissionWebhook:
      enabled: false
    node:
      lvmdConfigmap:
        device-classes:
          - name: garage
            volume-group: vg_garage
            type: linear
    EOT
  ]
}


resource "helm_release" "garage" {
  depends_on = [
    kubernetes_namespace_v1.garage,
    helm_release.topolvm
  ]

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

resource "kubernetes_storage_class_v1" "garage_topolvm" {
  metadata {
    name = "garage-topolvm"
  }

  storage_provisioner = "topolvm.io"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Delete"

  parameters = {
    "topolvm.io/device-class"   = "garage"
    "csi.storage.k8s.io/fstype" = "ext4"
  }
}
