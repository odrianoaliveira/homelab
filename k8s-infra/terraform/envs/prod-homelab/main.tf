
module "cluster" {
  source       = "../../modules/cluster-talos"
  cluster_name = "prod-homelab"

  enable_disk_patch    = false
  enable_network_patch = false

  install_disk = "/dev/nvme0n1"
  extra_disks  = []

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
