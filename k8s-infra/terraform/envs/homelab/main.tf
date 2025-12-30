
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
  depends_on        = [module.infra]
  source            = "../../modules/cluster-talos"
  cluster_name      = "homelab"
  garage_mount_path = "/var/mnt/garage"

  nodes = {
    "talos-01" = {
      ip   = module.infra.nodes["talos-01"].ip
      role = "controlplane"
    }
    "talos-02" = {
      ip   = module.infra.nodes["talos-02"].ip
      role = "worker"
    }
    "talos-03" = {
      ip   = module.infra.nodes["talos-03"].ip
      role = "worker"
    }
  }
}


# Garage depends upon the cluster being up.
# Since it requires PV with node affinity to worker nodes.
# To list all talos nodes:
# kubectl get nodes --selector='!node-role.kubernetes.io/control-plane' -o wide
#
module "garage" {
  depends_on   = [module.cluster]
  source       = "../../modules/platform/garage"
  worker_nodes = ["talos-l9f-oxd", "talos-y14-zq1"] # set the worker nodes hostnames here, details above
  # After set them, run `terraform apply -var="deploy_garage=true"`
  # 
  for_each = var.deploy_garage ? { enabled = true } : {}
}
