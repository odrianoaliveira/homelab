variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
  default     = ""
}

variable "flux_public_key" {
  description = "Flux SSH public key"
  type        = string
  default     = ""
}

variable "flux_private_key" {
  description = "Flux SSH private key"
  type        = string
  sensitive   = true
  default     = ""
}
