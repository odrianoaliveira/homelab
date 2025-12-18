# Adopt Flux CD for GitOps in Homelab Kubernetes Cluster

Date: 2025-12-18

## Status

Accepted

## Context

I am building a homelab Kubernetes cluster to learn enterprise-ready practices.
Managing cluster configurations, application deployments manually is error-prone and unscalable.
I need a declarative, automated, and auditable approach to manage my cluster and applications.

## Decision

Adopt Flux CD as the GitOps operator for my Kubernetes cluster.

## Consequences

### Positive

- GitOps Principles: Flux CD enables GitOps workflows, where the desired state of my cluster and applications is declared in Git. This aligns with enterprise practices for auditability, reproducibility, and collaboration.
- Automation: Flux CD automates the synchronization between my Git repository and the cluster, reducing manual intervention and human error.
- Security: Flux CD uses a pull-based model, reducing the attack surface. It also integrates with security tools like image scanning and policy enforcement.
- Multi-Environment Support: Flux CD supports promoting configurations across environments (e.g., dev, staging, prod), which is valuable for learning enterprise workflows.
- Extensibility: Flux CD integrates with tools like Helm, Kustomize, and Terraform, allowing me to experiment with different deployment strategies.
- Community and Documentation: Flux CD is a CNCF project with strong community support, extensive documentation, and enterprise adoption.
- Disaster Recovery: Git acts as a backup for my cluster state, making it easier to recover from failures.

### Negative

- Learning Curve: There is a learning curve associated with Flux CD and GitOps concepts, which may require additional time and effort.
- Initial Setup Complexity: Setting up Flux CD and configuring Git repositories may be more complex than manual management initially.
- Resource Overhead: Running Flux CD components in the cluster introduces some resource overhead, which may be a consideration in a homelab environment.

## References

- [Flux CD Documentation](https://fluxcd.io/docs/)
- [OpenGitOps](https://opengitops.dev/)
