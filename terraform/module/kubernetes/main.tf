terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

locals {
  talos_noddes = {
    "talos-01" = {
      target_node = "pve"
    }
    "talos-02" = {
      target_node = "pve"
    }
    "talos-03" = {
      target_node = "pve"
    }
  }
}

resource "proxmox_vm_qemu" "talos" {
  for_each = local.talos_noddes

  name        = each.key
  target_node = each.value.target_node

  disks {
    ide {
      ide0 {
        cdrom {
          iso = "metal-adm64.iso"
        }
      }
      ide1 {
        disk {
          storage = "local-lvm"
          size    = "100G"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "e1000"
    bridge = "vmbr0"
  }
}
