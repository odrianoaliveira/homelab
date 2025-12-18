# Use Calico for Kubernetes Pod Networking in Homelab

Date: 2025-12-17

## Status
Accepted

## Context
To learn platform engineering techniques and automate infrastructure with Terraform, I am constructing a Kubernetes home lab. For pods to be able to talk to each other, follow security rules, and connect to outside systems, pod networking is a key part.

I need a CNI plugin that is:
- Easy to operate and appropriate for a homelab setting.
- Allows network rules for testing and learning
- Well-documented and scalable.

## Decision
For our Kubernetes homelab, I will use Calico as the CNI plugin.

## Consequences

### Positive
- Calico is widely used and well-documented, which makes it accessible for learning.
- Calico fully supports Kubernetes NetworkPolicy, which lets us enforce security rules and try out zero-trust ideas.
- Calico works well in larger production settings as well as tiny homelabs.
- Access to resources and troubleshooting assistance is guaranteed by a large community and ongoing development.

### Negative
- Calico may introduce slightly more resource overhead compared to simpler CNI plugins like Flannel.
- While Calico is user-friendly, its advanced features may require additional learning.

## References
- [Calico Documentation](https://projectcalico.docs.tigera.io/)
- [Kubernetes NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
