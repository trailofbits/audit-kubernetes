# Introduction

The Cloud Native Computing Foundation (CNCF) tasked a combined team of Trail of Bits and Atredis ("assessment team") to conduct a component-focused threat model of the 
Kubernetes system. This threat model reviewed Kubernetes' components across six control families:

- Networking
- Cryptography
- Authentication
- Authorization
- Secrets Management
- Multi-tennacy

Kubernetes itself is a large system, spanning API gateways to container orchestration to networking and beyond. In order to assuage scope creep and keep a reasonable timeline
for threat modeling, the CNCF selected eight components within the larger Kubernetes ecosystem for evaluation:

- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager
- cloud-controller-manager
- kubelet
- kube-proxy
- Container Runtime

In total, the assessment team found **XX-CHANGE-ME** vulnerabilities across the various components, ranging in severity from **CHANGEME** to **CHANGEME**.

_SUMMARY OF FINDINGS BELOW_
