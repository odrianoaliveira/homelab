
output "talosconfig" {
  description = "Talos client configuration..."
  value       = yamlencode(talos_machine_secrets.this.client_configuration)
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes cluster kubeconfig..."
  value       = talos_cluster_kubeconfig.this["talos-01"].kubeconfig_raw
  sensitive   = true
}

output "endpoint" {
  description = "Kubernetes cluster API endpoint"
  value       = local.cluster_endpoint
}
