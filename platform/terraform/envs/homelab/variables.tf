variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL, e.g., https://<host>:8006/api2/json"
}

variable "proxmox_token_id" {
  type        = string
  description = "Proxmox API token ID in the format user@realm!tokenname"
}

variable "proxmox_token_secret" {
  type        = string
  description = "Proxmox API token secret value."
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Allow insecure TLS (self-signed certs). Set to false in production."
  default     = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_org" {
  type        = string
  description = "GitHub organization where the repository is located"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository name for GitOps"
}
