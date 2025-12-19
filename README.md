# Platform Engineering Homelab

Exploring declarative infrastructure, Kubernetes, and automation for the AI boom era.

## 🏗️ Architecture

```mermaid
%% Homelab Architecture Diagram
graph TD
    subgraph Virtualization
        A[Proxmox] -->|Hosts| B[Talos Nodes]
    end

    subgraph Kubernetes Cluster
        B -->|Runs| C[Kubernetes Control Plane]
        B -->|Runs| D[Kubernetes Worker Nodes]
        C -->|Manages| D
    end

    subgraph GitOps
        I[Flux CD] -->|Syncs Configs| C
        I -->|Syncs Configs| D
        J[Git Repository] -->|Reads Configs| I
    end

    subgraph IaC
        J[Git Repository] --> |Reads Configs| E[Terraform]
        E -->|Provisions| A
        E -->|Bootsrap Talos Cluster| B
        E -->|Bootstrap Flux CD| I[Flux CD]
        E -->|Persists| P[Terraform State]
    end

    subgraph Observability
        F[Prometheus] -->|Collects Metrics| C
        F -->|Collects Metrics| D
        G[Grafana] -->|Visualizes| F
        H[Loki] -->|Stores Logs| C
        H -->|Stores Logs| D
    end
```
```
```

- **Proxmox**: Virtualization and bare-metal management.
- **Talos**: Minimal, secure OS for Kubernetes.
- **Kubernetes**: Orchestration for containerized workloads.
- **Terraform**: IaC tool to provision and manage infrastructure declaratively.
- **Observability**: Prometheus, Grafana, and Loki for observability.

## 🚀 Key Projects
### Automated Kubernetes Cluster
- **Goal**: Deploy a production-grade Kubernetes cluster using Terraform and Talos
- **Outcome**: Reduced manual setup time by 80%.
- **Code**: [k8s-infra](k8s-infra/Terraform)

### GitOps
- **Goal**: Apply DevOps practices like version control, collaboration, and CI/CD to ensure reproducible deployments.
- **Tools**: Git, Flux CD
- **Outcome**: GitOps configuration generates the same infrastructure every time it is deployed.
- **Code**: [monitoring](link-to-folder)

## 🎯 Lessons Learned

## 🔮 Future Plans
- Experiment with **GPU passthrough** for AI training.
- Explore **MLOps tools** (e.g., Kubeflow, Argo Workflows).
- Add **edge computing** nodes for IoT simulations.

## 📫 Connect
- [LinkedIn](https://www.linkedin.com/in/adriano-oliveira/)
- [GitHub](https://github.com/odrianoaliveira/)
