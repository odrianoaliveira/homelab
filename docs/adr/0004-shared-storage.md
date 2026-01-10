# Use Longhorn for Shared Storage in Kubernetes Cluster

**Date:** 2024-06-15

## Status
Accepted

## Context
The challenge is to create a shared filesystem that works with GitOps workflows, can be managed through IaC, and can be expanded for future needs.

The setup includes an HP EliteDesk with 8TB RAID storage, a Mini PC with 256GB storage, and a Raspberry Pi with 64GB storage. The objective is to self-host apps while guaranteeing resilience and high availability.

## Decision
Use Longhorn for shared storage within the Kubernetes cluster.

## Consequences

### Pros:
  - Built-in replication and high availability.
  - Storage provisioning and management through Kubernetes.s.
  - Native integration with Kubernetes.
  - Supports snapshots and backups.
  - Scalable and flexible for future growth.
  
### Cons:
  - More complex to set up and manage compared to NFS.
  - Higher resource overhead due to replication and distributed nature.
  - Requires more initial configuration and setup.
  - Potential learning curve for team members unfamiliar with Longhorn.
