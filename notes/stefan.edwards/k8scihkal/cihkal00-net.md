# First blush

- kube-proxy: maps k8s IPs to internet/net IPs, handles comms to pod/service rewriting, usually with `iptables`. Containers must be able to speak w/ all containers & nodes must be able to speak w/ all containers w/o NAT for either
- No IDS by default, no egress filtering (SPA paper solves w/ interstitial IDS)
- flat network via Flannel
- Can use BGP (!!!) to advertise routes
- overlay via virtual extensible LAN (vxlan)

## API sec

- AuthN: valid user via cert, token, or proxy auth
- AuthZ: user authorized to do so, via Attribute-Based Access Control (ABAC) or RBAC; default deny (also, can be setup such that attributes/roles don't propagate)
- Admission Control: can "validate" or "mutate" requests prior to reification to an object
- Docs have note: `Many advanced features in Kubernetes require an admission controller to be enabled in order to properly support the feature. As a result, a Kubernetes API server that is not properly configured with the right set of admission controllers is an incomplete server and will not support all the features you expect.`

## Networking

- network comes in several flavors 
- flat network uses BGP (!!!) and `iptables`; Project Calico main one here
- overlay: packet encapsulation
- NetworkPolicy: A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints
- vxLAN: uses vxLAN Tunnel Endpoints (VTEPs) to encapsulate traffic in UDP packets. Two major impls
- OPenShift SDN uses Open vSwitch, which supports several different plugins, some of which support NetworkPolicy
- Flannel: vxLAN setup, but does not support NetworkPolicy by default; Must be combined with Calico to get NetworkPolicy, the combo is known as Canal
- **IMPORTANT** You can choose a networking type that does not support NetworkPolicy
- **IMPORTANT** this means you can write very robust network filtering that has no impact on the actual network
- **FINDING** that's a finding: it's non-trivial to determine if an arbitrary NetworkPolicy actually _does_ anything
- **FINDING** No egress filtering, still need a FW/IDPS behind the VTEPs
- **FINDING?** Pod to pod filtering, but note Node to Node, not Container to Container. Means Containers must be placed in Pods and then filtered...
- that's weird for affinity and the like too...
- Doesn't handle logging or the like.
- Swedish Police Authority (SPA) paper has extra components for loggin, firewalls, history...

### References

- [SPA Paper](https://kth.diva-portal.org/smash/get/diva2:1231856/FULLTEXT01.pdf)
- [SPA Blog](https://medium.com/@chrismessiah/docker-and-kubernetes-in-high-security-environments-d851645e8b99)

## Control Summary

- AN: Sufficient
- SDP: Missing
- IV: Weak
- OE: Weak
- AZ: Sufficient
- EH: Weak
- LG: Weak
