variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL, e.g., https://<host>:8006/api2/json"
}

variable "proxmox_user" {
  type        = string
  description = "Proxmox API username, e.g., terraform-prov@pve"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox API user password"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Allow insecure TLS (self-signed certs). Set to false in production."
  default     = true
}
