output "kubeconfig" {
  value     = module.kubernetes.kubeconfig
  sensitive = true
}

output "talosconfig" {
  value     = module.kubernetes.talosconfig
  sensitive = true
}

output "cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}
