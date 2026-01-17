
locals {
  cluster_endpoint = "https://${var.nodes["talos-01"].ip}:6443"

  # Talos factory schematic with iscsi-tools and util-linux-tools extensions required by Longhorn
  schematic_id    = "613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245"
  talos_version   = "v1.12.1"
  installer_image = "factory.talos.dev/installer/${local.schematic_id}:${local.talos_version}"

  enable_workers_controlplane_patch = var.enable_workers_on_controlplane != true ? null : yamlencode(
    {
      cluster = {
        allowSchedulingOnControlPlanes : true
      }
    }
  )

  network_patch = var.enable_network_patch ? yamlencode({
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
  }) : null

  longhorn_deps = yamlencode({
    machine = {
      install = {
        image = local.installer_image
      }
      kubelet = {
        extraMounts = [
          {
            destination = "/var/lib/longhorn"
            type        = "bind"
            source      = "/var/lib/longhorn"
            options = [
              "bind",
              "rshared",
              "rw"
            ]
          }
        ]
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
    yamlencode({
      machine = {
        install = {
          disk = each.value.install_disk
          wipe = true
        }
      }
    }),
    yamlencode({
      machine = {
        disks = each.value.storage_disks
      }
    }),
    local.enable_workers_controlplane_patch,
    local.network_patch,
    local.longhorn_deps
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
