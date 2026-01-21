# ADR-001: Secure Longhorn UI Access Using Gateway API and OAuth2 Proxy

**Date:** 2026-01-20

## Status
Accepted

## Context
As part of my homelab and platform engineering skill development, I need a secure, zero-trust way to access the **Longhorn UI** from within my local network. The solution must:
- **Authenticate users** (only sysadmins allowed).
- **Avoid public internet exposure**.
- **Leverage modern Kubernetes features** (Gateway API).
- **Integrate with existing infrastructure** (Talos, k3s, Fritz Box 7590, VLANs).

### Constraints
1. **No public internet exposure**: The UI must not be accessible outside my home network.
2. **Authentication required**: Only authenticated sysadmins (e.g., via GitHub OAuth) can access the UI.
3. **Zero-trust principles**: Minimize lateral movement risk within the cluster.
4. **Homelab simplicity**: Avoid over-engineering; use tools already in my stack (e.g., Pi-hole, Calico/Cilium).

### Background
- My homelab runs **Talos Linux** and **k3s** on an HP EliteDesk 800 G3 (control plane) and Raspberry Pis (workers).
- I use **VLANs** (e.g., `192.168.8.0/24` for admin traffic) and **Pi-hole** for internal DNS.
- I am preparing for the **CKAD certification** and want to practice **Gateway API, Network Policies, and OAuth2 Proxy**—skills relevant to platform engineering roles.
- Alternatives considered:
  - **Tailscale (Solution 2)**: While simpler for remote access, it adds dependency on a third-party service.
  - **Traditional Ingress + Basic Auth**: Less secure and not aligned with zero-trust principles.

## Decision
I will implement **Solution 1: Internal Gateway API + OAuth2 Proxy** to secure Longhorn UI access. This approach:
- Uses **Gateway API** (successor to Ingress) for routing.
- Deploys **OAuth2 Proxy** as an authentication layer (GitHub OAuth).
- Enforces **Network Policies** to restrict traffic between OAuth2 Proxy and Longhorn.
- Resolves `longhorn.admin.home` via **Pi-hole** (internal DNS).

### Architecture
```mermaid
flowchart TD
    subgraph Home Network
        SA[SysAdmin Device] -->|VLAN: Admin| FB[Fritz Box 7590]
        FB -->|192.168.8.0/24| K8s[Kubernetes Cluster\n(Talos/k3s)]
    end
    subgraph Kubernetes Cluster
        K8s -->|Gateway API| GW[Gateway\n(ClusterIP: 192.168.8.100)]
        GW -->|HTTPRoute| OA[OAuth2 Proxy\n(Pod)]
        OA -->|AuthN| LF[Longhorn Frontend\n(Pod)]
        OA -->|Restrict| NP[Network Policy\n(Allow only OAuth2 → Longhorn)]
        LF -->|Storage| Longhorn[Longhorn Storage\n(Raspberry Pi Nodes)]
    end
    PiHole[Pi-hole\nInternal DNS] -->|Resolves| GW
    style OAuth2 fill:#f9f,stroke:#333
    style NP fill:#9f9,stroke:#333
```
