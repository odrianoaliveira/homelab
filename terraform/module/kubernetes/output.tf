output "talosconfig" {
  description = "Talos configuration for the cluster"
  value       = talos_machine_secrets.this.client_configuration
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig for the Kubernetes cluster"
  value = one([
    for _, v in talos_cluster_kubeconfig.this :
    v.kubeconfig_raw
  ])
  sensitive = true
}

output "cluster_endpoint" {
  description = "Kubernetes cluster API endpoint"
  value       = local.cluster_endpoint
}
