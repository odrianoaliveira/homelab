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
