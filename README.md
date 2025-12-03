# Homelab Platform

A minimal, automated homelab for learning practical DevOps and Platform Engineering.

```
Arch Linux → KVM/QEMU → Proxmox → Terraform → Talos → Kubernetes
```

## Roadmap

### Core Setup

* [x] KVM/QEMU
* [x] Proxmox VE
* [ ] Ansible
* [x] Terraform
* [ ] Talos Kubernetes (1 CP + 2 workers)

### Platform Add-Ons

* [ ] Flux CD (GitOps)
* [ ] Monitoring (Prometheus, Grafana, Loki)

## Build

### Installing KVM/QEMU

Follow the [Arch Linux KVM Guide](https://wiki.archlinux.org/title/KVM) to install and configure KVM/QEMU on your Arch Linux host.

### Installing Virt-Manager & libvirt

Install Virt-Manager for managing your virtual machines:

```bash
sudo pacman -S virt-manager virt-viewer libvirt dnsmasq bridge-utils openbsd-netcat
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $(whoami)
```

### Installing Proxmox VE

Open Virt-Manager and create a new VM using the following configuration:

**VM Details**
* OS: "Generic Linux"
* CPU:
  * 4 cores (host-passthrough)
  * Enable: "Host passthrough"
  * Memory: 16 GB
  * Disk: 128 GB (virtio-blk)
  * Network: Bridge to LAN

**Enable nested virtualization features**

Under CPU configuration:
* Mode: Host Passthrough
* Check: "Enable virtualization features (VMX/SVM)"

**Attach Proxmox ISO**

* Download the ISO: https://www.proxmox.com/en/downloads
* Attach it when creating the VM.
* Install Proxmox normally
* No special steps needed, just follow the installation process.

### Setting up Ansible

```bash
sudo pacman -S ansible ansible-lint openssh
```

### Setting up Terraform

Installing Terraform.
```bash
sudo pacman -S terraform sshpass
```

Check if it is working:.
```bash
terraform version
```

It's done.


### Provision Promox resouces

This project manages infrastructure via Terraform.
This [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) describes how to use the Proxmox Terraform provider.

This projects relies on the proxmox user / password authentication, configured in the steps above.

### Provision Talos Kubernetes

The documentation [Talos on Proxmox](https://docs.siderolabs.com/talos/v1.10/platform-specific-installations/virtualized-platforms/proxmox/) describes how to provision Talos Kubernetes on Proxmox.
