
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
    ip           = string
    role         = string
    install_disk = string
    storage_disks = list(object({
      device = string
    }))
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

variable "enable_network_patch" {
  description = "Enable network patch for specific interface configuration"
  type        = bool
  default     = true
}

variable "enable_workers_on_controlplane" {
  description = "Enable workers on controlplane node"
  type        = bool
  default     = false
}

