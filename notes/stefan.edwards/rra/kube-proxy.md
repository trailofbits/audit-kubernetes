# Overview

- Component: kube-proxy
- Owner(s): [sig-network](https://github.com/kubernetes/community/tree/master/sig-network)
- SIG/WG(s) at meeting:
- Service Data Classification: Medium
- Highest Risk Impact:

# Service Notes

The portion should walk through the component and discuss connections, their relevant controls, and generally lay out how the component serves its relevant function. For example
a component that accepts an HTTP connection may have relevant questions about channel security (TLS and Cryptography), authentication, authorization, non-repudiation/auditing,
and logging. The questions aren't the *only* drivers as to what may be spoken about, the questions are meant to drive what we discuss and keep things on task for the duration
of a meeting/call.

## How does the service work?

- kubeproxy has two main modes of operation:
  - as a literal network proxy, handling networking between nodes
  - as a bridge between Container Network Interface (CNI) which handles the actual networking and the host operating system (via `iptables` and the like)
- in either mode, kubeproxy interfaces with the host's `iptables` so as to achieve a seamless, flat network across the kubernetes cluster

## Are there any subcomponents or shared boundaries?

Yes.

- Similar to kubelet, kube-proxy run's on the node, with an implicit trust boundary between Worker components and Container components (i.e. pods)

## What communications protocols does it use?

- Direct IPC to `iptables` or `ipvs`

## Where does it store data?

Minimal data should be stored by kube-proxy itself, this should mainly be handled by kubelet and some file system configuration

## What is the most sensitive data it stores?

N/A

## How is that data stored?

N/A

# Data Dictionary

| Name | Classification/Sensitivity | Comments |
| :--: | :--: | :--: |
| Data | Goes | Here |

# Control Families 

These are the areas of controls that we're interested in based on what the audit working group selected. 

When we say "controls," we mean a logical section of an application or system that handles a security requirement. Per CNSSI:

> The management, operational, and technical controls (i.e., safeguards or countermeasures) prescribed for an information system to protect the confidentiality, integrity, and availability of the system and its information.

For example, an system may have authorization requirements that say:

- users must be registered with a central authority
- all requests must be verified to be owned by the requesting user
- each account must have attributes associated with it to uniquely identify the user

and so on. 

For this assessment, we're looking at six basic control families:

- Networking
- Cryptography
- Secrets Management
- Authentication
- Authorization (Access Control)
- Multi-tenancy Isolation

Obviously we can skip control families as "not applicable" in the event that the component does not require it. For example,
something with the sole purpose of interacting with the local file system may have no meaningful Networking component; this
isn't a weakness, it's simply "not applicable."

For each control family we want to ask:

- What does the component do for this control?
- What sorts of data passes through that control? 
  - for example, a component may have sensitive data (Secrets Management), but that data never leaves the component's storage via Networking
- What can attacker do with access to this component?
- What's the simplest attack against it?
- Are there mitigations that we recommend (i.e. "Always use an interstitial firewall")?
- What happens if the component stops working (via DoS or other means)?
- Have there been similar vulnerabilities in the past? What were the mitigations?

# Threat Scenarios

- An External Attacker without access to the client application
- An External Attacker with valid access to the client application
- An Internal Attacker with access to cluster
- A Malicious Internal User

## Networking

## Cryptography

## Secrets Management

## Authentication

## Authorization

## Multi-tenancy Isolation

## Summary

# Recommendations
