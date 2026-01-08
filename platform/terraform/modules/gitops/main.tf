
data "github_repository" "existing" {
  full_name = "${var.github_org}/${var.github_repository}"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = data.github_repository.existing.name
  key        = var.flux_public_key
  read_only  = "false"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]

  embedded_manifests = true
  path               = "platform/fluxcd"
}
