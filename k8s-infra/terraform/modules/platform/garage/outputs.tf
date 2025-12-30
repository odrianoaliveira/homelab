
output "garage_endpoint" {
  description = "Garage platform endpoint"
  value       = helm_release.garage.status
}
