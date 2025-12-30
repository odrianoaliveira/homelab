
resource "proxmox_vm_qemu" "nodes" {
  for_each = var.nodes
  onboot   = true

  name = each.key
  cpu {
    cores = each.value.cpu
  }
  memory      = each.value.memory
  target_node = each.value.target_node

  scsihw = "virtio-scsi-pci"

  disks {
    scsi {
      # Talos OS disk /dev/sda
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
      # Minio disk /dev/sdb
      scsi2 {
        disk {
          size    = "20G"
          storage = "minio-lvm"
          format  = "raw"
        }
      }
    }
  }

  network {
    id      = var.network.interface_id
    model   = var.network.model
    bridge  = var.network.bridge
    macaddr = each.value.mac_address
  }
}
