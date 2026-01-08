variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
}

variable "flux_public_key" {
  description = "Flux SSH public key"
  type        = string
}

variable "flux_private_key" {
  description = "Flux SSH private key"
  type        = string
  sensitive   = true
}

variable "flux_path" {
  description = "Path in the repository where Flux manifests are located"
  type        = string
}
