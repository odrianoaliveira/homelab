
module "cluster" {
  source       = "../../modules/cluster-talos"
  cluster_name = "prod-homelab"

  enable_network_patch           = false
  enable_workers_on_controlplane = true

  nodes = {
    "talos-01" = {
      ip            = "192.168.8.242"
      role          = "controlplane"
      install_disk  = "/dev/nvme0n1"
      storage_disks = []
    }
    "talos-02" = {
      ip            = "192.168.8.162"
      role          = "worker"
      install_disk  = "/dev/sdb"
      storage_disks = []
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
}

#module "cluster_postconfig" {
#  depends_on = [module.cluster]
#  source     = "../../modules/cluster-talos-postconfig"
#}

#module "storage" {
#  depends_on = [
#    module.cluster_postconfig,
#    module.cert_manager
#  ]
#
#  source = "../../modules/platform/storage"
#}
