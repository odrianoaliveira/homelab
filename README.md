# Homelab Platform

A minimal, automated homelab for learning practical DevOps and Platform Engineering.

```
Arch Linux → KVM/QEMU → Proxmox → Terraform → Talos → Kubernetes
```

## Roadmap

### Core Setup

* [x] KVM/QEMU
* [x] Proxmox VE
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

## Terraform
### Setting up

Installing Terraform.
```bash
sudo pacman -Syu terraform
```

Check if it is working:.
```bash
terraform version
```

It's done.


### Configuring Proxmox for Terraform

This project manages infrastructure via Terraform.
This [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) describes how to use the Proxmox Terraform provider.

This projects relies on the proxmox user / password authentication, configured in the steps above.

### Provision Talos VMs

The documentation [Talos on Proxmox](https://docs.siderolabs.com/talos/v1.10/platform-specific-installations/virtualized-platforms/proxmox/) describes how to provision Talos Kubernetes on Proxmox.

#### Pre-requisites

1. Download the Talos ISO image from the [Talos Releases](https://github.com/siderolabs/talos/releases) page.
2. Upload the ISO to Proxmox storage (e.g., `local:iso/talos-amd64.iso`).
3. Create a Proxmox storage named `k8s-lvm` for Talos VM disks.

#### Apply Terraform Configuration

1. Navigate to the `terraform/` directory.
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the planned actions:
   ```bash
   terraform plan
   ```
4. Apply the configuration to create Talos VMs:
   ```bash
   terraform apply
   ```
5. Confirm the apply action when prompted.
6. After completion, verify that the Talos VMs are running in Proxmox.

You should see three Talos VMs created (talos-01, talos-02, talos-03) and running in your Proxmox environment.
<p align="center">
  <img src="https://github.com/user-attachments/assets/fa7de471-5a4a-474d-b459-7f3f974bb36f" alt="Proxmox Talos VMs">
</p>
