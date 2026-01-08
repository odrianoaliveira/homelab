
output "nodes" {
  value = {
    for name, node in var.nodes :
    name => {
      ip  = node.static_ip
      mac = node.mac_address
    }
  }
}
