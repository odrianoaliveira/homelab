locals {
  storage_disks = [
    {
      device = "/dev/sdb"
    }
  ]

  install_disk = "/dev/sda"

  flux_path = "platform/fluxcd/dev"
}

module "infra" {
  source = "../../modules/proxmox"

  network = {
    interface_id = 0
    bridge       = "vmbr0"
    model        = "virtio"
  }

  nodes = {
    "talos-01" = {
      cpu         = 4
      memory      = 8192
      target_node = "pve"
      static_ip   = "192.168.8.141"
      mac_address = "02:AD:BE:EF:00:01"
    }
    "talos-02" = {
      cpu         = 2
      memory      = 4096
      target_node = "pve"
      static_ip   = "192.168.8.142"
      mac_address = "02:AD:BE:EF:00:02"
    }
    "talos-03" = {
      cpu         = 2
      memory      = 4096
      target_node = "pve"
      static_ip   = "192.168.8.143"
      mac_address = "02:AD:BE:EF:00:03"
    }
  }
}

module "cluster" {
  depends_on   = [module.infra]
  source       = "../../modules/cluster-talos"
  cluster_name = "homelab"

  nodes = {
    "talos-01" = {
      ip            = module.infra.nodes["talos-01"].ip
      role          = "controlplane"
      install_disk  = local.install_disk
      storage_disks = local.storage_disks
    }
    "talos-02" = {
      ip            = module.infra.nodes["talos-02"].ip
      role          = "worker"
      install_disk  = local.install_disk
      storage_disks = local.storage_disks
    }
    "talos-03" = {
      ip            = module.infra.nodes["talos-03"].ip
      role          = "worker"
      install_disk  = local.install_disk
      storage_disks = local.storage_disks
    }
  }
}

module "cert_manager" {
  depends_on = [module.cluster]
  source     = "../../modules/platform/cert-manager"
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# export TF_VAR_github_token="***"
# terraform apply
module "gitops" {
  depends_on = [module.cluster]
  source     = "../../modules/gitops"

  github_org        = "odrianoaliveira"
  github_repository = "homelab"
  github_token      = var.github_token
  flux_private_key  = tls_private_key.flux.private_key_pem
  flux_public_key   = tls_private_key.flux.public_key_openssh
  flux_path         = local.flux_path
}

module "cluster_postconfig" {
  depends_on = [module.cluster]
  source     = "../../modules/cluster-talos-postconfig"
}

module "storage" {
  depends_on = [
    module.cluster_postconfig,
    module.cert_manager
  ]

  source = "../../modules/platform/storage"
}
