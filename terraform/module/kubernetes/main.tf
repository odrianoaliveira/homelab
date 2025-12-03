# this module creates Talos VMs on Proxmox for Kubernetes cluster

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

locals {
  talos_nodes = {
    "talos-01" = {
      cpu         = "4"
      memory      = "8192"
      target_node = "pve"
    }
    "talos-02" = {
      cpu         = "2"
      memory      = "4096"
      target_node = "pve"
    }
    "talos-03" = {
      name        = "talos-03"
      cpu         = "2"
      memory      = "4096"
      target_node = "pve"
    }
  }
}

resource "proxmox_vm_qemu" "talos" {
  for_each = local.talos_nodes

  name = each.key
  cpu {
    cores = each.value.cpu
  }
  memory      = each.value.memory
  target_node = each.value.target_node

  # SCSI controller (melhor para Talos)
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
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
}
