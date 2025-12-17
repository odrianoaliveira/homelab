# this module creates Talos VMs on Proxmox for Kubernetes cluster

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.9"
    }
  }
}

locals {
  network = {
    bridge      = "vmbr0"
    interface   = "ens18"
    nameservers = ["1.1.1.1", "1.0.0.1"]
  }

  talos_nodes = {
    "talos-01" = {
      cpu         = 4
      memory      = 8192
      target_node = "pve"
      static_ip   = "192.168.8.141"
      mac_address = "02:AD:BE:EF:00:01"
      role        = "controlplane"
    }
    "talos-02" = {
      cpu         = 2
      memory      = 4096
      target_node = "pve"
      static_ip   = "192.168.8.142"
      mac_address = "02:AD:BE:EF:00:02"
      role        = "worker"
    }
    "talos-03" = {
      name        = "talos-03"
      cpu         = 2
      memory      = 4096
      target_node = "pve"
      static_ip   = "192.168.8.143"
      mac_address = "02:AD:BE:EF:00:03"
      role        = "worker"
    }
  }

  talos_network_patches = {
    for k, v in local.talos_nodes :
    k => yamlencode({
      machine = {
        network = {
          hostname = k
          interfaces = [{
            interface = local.network.interface
            dhcp      = true
          }]
          nameservers = local.network.nameservers
        }
      }
    })
  }

  controlplane_nodes = [
    for k, v in local.talos_nodes : v.static_ip if v.role == "controlplane"
  ]
  worker_nodes = [
    for k, v in local.talos_nodes : v.static_ip if v.role == "worker"
  ]
  cluster_endpoint = "https://${local.controlplane_nodes[0]}:6443" # replace ${} with actual control plane IP
}

resource "proxmox_vm_qemu" "talos" {
  for_each = local.talos_nodes

  name = each.key
  cpu {
    cores = each.value.cpu
  }
  memory      = each.value.memory
  target_node = each.value.target_node

  scsihw = "virtio-scsi-pci"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "40G"
          storage = "k8s-lvm"
          format  = "raw"
        }
      }
      scsi1 {
        cdrom {
          iso = "local:iso/talos-amd64.iso"
        }
      }
    }
  }

  network {
    id      = 0
    model   = "virtio"
    bridge  = local.network.bridge
    macaddr = each.value.mac_address
  }
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "this" {
  for_each = local.talos_nodes

  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = each.value.role == "controlplane" ? "controlplane" : "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    local.talos_network_patches[each.key]
  ]
}

resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [proxmox_vm_qemu.talos]

  for_each = {
    for k, v in local.talos_nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.static_ip
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_vm_qemu.talos]
  for_each = {
    for k, v in local.talos_nodes :
    k => v
    if v.role == "worker"
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.static_ip
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  for_each = {
    for k, v in local.talos_nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = each.value.static_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  for_each = {
    for k, v in local.talos_nodes :
    k => v
    if v.role == "controlplane"
  }

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = each.value.static_ip
}
