
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
