
locals {
  cluster_endpoint = "https://${var.nodes["talos-01"].ip}:6443"

  disk_patch = yamlencode({
    machine = {
      disks = [
        {
          device = "/dev/sdb"
        }
      ]
    }
  })

  network_patch = yamlencode({
    machine = {
      network = {
        interfaces = [
          {
            interface = "ens18"
            dhcp      = true
          }
        ]
        nameservers = ["1.1.1.1", "1.0.0.1"]
      }
    }
  })
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "this" {
  for_each = var.nodes

  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = each.value.role
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = compact([
    local.disk_patch,
    local.network_patch
  ])
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each = {
    for k, v in var.nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.ip
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = {
    for k, v in var.nodes :
    k => v
    if v.role == "worker"
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.ip
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  for_each = {
    for k, v in var.nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = each.value.ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  for_each = {
    for k, v in var.nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = each.value.ip
}

resource "local_sensitive_file" "kubeconfig" {
  content         = one(values(talos_cluster_kubeconfig.this)).kubeconfig_raw
  filename        = pathexpand("~/.kube/config")
  file_permission = "0600"
}

resource "kubernetes_manifest" "node_lvm_bootstrap" {
  depends_on = [local_sensitive_file.kubeconfig]

  manifest = yamldecode(
    file("${path.module}/lvm-bootstrap/daemonset.yaml")
  )

  lifecycle {
    ignore_changes = [
      object.metadata.annotations
    ]
  }
}
