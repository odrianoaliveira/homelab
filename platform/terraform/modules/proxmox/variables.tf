
variable "network" {
  type = object({
    interface_id = number
    bridge       = string
    model        = string
  })
}

variable "nodes" {
  type = map(object({
    cpu         = number
    memory      = number
    target_node = string
    static_ip   = string
    mac_address = string
  }))
}
