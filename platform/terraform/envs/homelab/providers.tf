
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.7"
    }
    github = {
      source  = "integrations/github"
      version = "~>6.9"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.1"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}

locals {
  kubeconfig_data = yamldecode(module.cluster.kubeconfig)
  host            = local.kubeconfig_data.clusters[0].cluster.server
  cluster_ca_certificate = base64decode(
    local.kubeconfig_data.clusters[0].cluster.certificate-authority-data
  )
  client_certificate = base64decode(
    local.kubeconfig_data.users[0].user.client-certificate-data
  )
  client_key = base64decode(
    local.kubeconfig_data.users[0].user.client-key-data
  )
}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate

    load_config_file = false
  }
}

provider "flux" {
  kubernetes = {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}
