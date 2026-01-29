# Pi-hole with Unbound, Nebula, and Keepalived for HA DNS

## Context
In the homelab environment, there is a need for a private, secure, and highly available DNS solution.
The current setup involves multiple devices and VLANs, requiring reliable DNS resolution while maintaining privacy and security.
Pi-hole is preferred for its ad-blocking capabilities and ease of use, but the default upstream DNS providers do not offer the desired level of privacy.
High availability is required to ensure uninterrupted DNS service.

## Decision
Deploy two Raspberry Pi Zero 2W nodes running Pi-hole with Unbound as the upstream DNS resolver.
Use Nebula for secure synchronization between nodes.
Utilize Keepalived for virtual IP failover to achieve high availability.

## Architecture
- Pi-hole + Unbound: Each node runs Pi-hole with Unbound as the upstream resolver.
- Nebula: Nodes are connected via Nebula for secure communication and configuration synchronization.
- Keepalived: Virtual IP is shared between nodes for failover.

## Consequences
- Positive: Privacy, security, high availability, and consistency.
- Negative: Increased complexity and resource usage.

## References
- [Pi-hole Documentation](https://docs.pi-hole.net/)
- [Unbound Documentation](https://nlnetlabs.nl/documentation/unbound/)
- [Nebula Documentation](https://github.com/slackhq/nebula)
- [Keepalived Documentation](https://www.keepalived.org/documentation.html)
