# Homelab Platform

A minimal, automated homelab for learning practical DevOps and Platform Engineering.

```
Arch Linux → KVM/QEMU → Proxmox → Terraform → Talos → Kubernetes
```

## Roadmap

### Core Setup

* [x] KVM/QEMU
* [ ] Proxmox VE
* [ ] Terraform
* [ ] Talos Kubernetes (1 CP + 2 workers)

### Platform Add-Ons

* [ ] Flux CD (GitOps)
* [ ] Monitoring (Prometheus, Grafana, Loki)

## Build

### Installing KVM/QEMU

Follow the [Arch Linux KVM Guide](https://wiki.archlinux.org/title/KVM) to install and configure KVM/QEMU on your Arch Linux host.

### Installing Proxmox VE

Follow the [Proxmox VE Installation Guide](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_Buster) to install Proxmox VE on top of your KVM/QEMU setup.

### Provisioning with Terraform

Use the provided Terraform configuration files to provision Talos Kubernetes on your Proxmox VE setup. Make sure to customize the variables as needed.

```bashterraform init
terraform apply
```
