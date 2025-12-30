
output "talos_configs" {
  description = "Talos machine configurations"
  value       = module.cluster.talosconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster"
  value       = module.cluster.kubeconfig
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = module.cluster.endpoint
}

output "vm_nodes" {
  description = "VM nodes"
  value       = module.infra.nodes
}

output "module_garage_output" {
  value = try(module.garage.garage_endpoint, null)
}
