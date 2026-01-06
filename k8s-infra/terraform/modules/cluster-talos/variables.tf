
variable "network" {
  type = object({
    interface   = string
    nameservers = list(string)
  })
  default = {
    interface   = "ens18"
    nameservers = ["1.1.1.1", "1.0.0.1"]
  }
}

variable "nodes" {
  type = map(object({
    ip            = string
    role          = string
    install_disk  = string
    storage_disks = list(string)
  }))

  validation {
    condition     = alltrue([for n in values(var.nodes) : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", n.ip))])
    error_message = "ip must be a valid IPv4 address."
  }

  validation {
    condition     = alltrue([for n in values(var.nodes) : contains(["controlplane", "worker"], n.role)])
    error_message = "role must be one of: controlplane, worker."
  }
}

variable "cluster_name" {
  type = string
}

variable "enable_disk_patch" {
  description = "Enable disk patch for VMs (not needed for bare metal)"
  type        = bool
  default     = true
}

variable "enable_network_patch" {
  description = "Enable network patch for specific interface configuration"
  type        = bool
  default     = true
}

variable "install_disk" {
  description = "Where to install the Talos OS disk (e.g., /dev/nvme0n1, /dev/sda)"
  type        = string
}

variable "extra_disks" {
  description = "Additional disks to configure on the machine"
  type = list(object({
    device = string
    wipe   = bool
  }))
}
