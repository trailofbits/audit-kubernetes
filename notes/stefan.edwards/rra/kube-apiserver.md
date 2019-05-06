# Overview

- Component: kube-apiserver
- Owner(s): [sig-api-machinery](https://github.com/kubernetes/community/tree/master/sig-api-machinery)
- SIG/WG(s) at meeting:
- Service Data Classification: High (technically, it isn't needed, but most clusters will use it extensively)
- Highest Risk Impact:

# Service Notes

The portion should walk through the component and discuss connections, their relevant controls, and generally lay out how the component serves its relevant function. For example
a component that accepts an HTTP connection may have relevant questions about channel security (TLS and Cryptography), authentication, authorization, non-repudiation/auditing,
and logging. The questions aren't the *only* drivers as to what may be spoken about, the questions are meant to drive what we discuss and keep things on task for the duration
of a meeting/call.

## How does the service work?

- RESTful API server
- made up of multiple subcomponents:
  - authenticators
  - authorizers 
  - admission controllers 
  - resource validators
- users issue a request, which is authenticated via one (or more) plugins
- the requests is then authorized by one or more authorizers
- it is then potentially modified and validated by an admission controller
- resource validation that validates the object, stores it in etcd, and responds
- clients issue HTTP requests (via TLS ala HTTPS) to "watch" resources and poll for changes from the server; for example:
  1. a client updates a pod definition via `kubectl` and a `POST` request
  1. the scheduler is "watching" for pod updates via an HTTP watch request to retrieve new pods
  1. the scheduler then update the pod list via a `POST` to the kube-apiserver
  1. a node's `kubelet` retrieves a list of pods assigned to it via an HTTP watch request
  1. the node's `kubelet` then update the running pod list on the kube-apiserver

## Are there any subcomponents or shared boundaries?

Yes

- Controllers technically run on the kube-apiserver
- the various subcomponents (authenticators, authorizers, and so on) run on the kube-apiserver 

additionally, depending on the configuration there may be any number of other Master Control Pane components running on the same phyical/logical host

## What communications protocols does it use?

- Communcations to the kube-apiserver use HTTPS and various authentication mechanisms
- Communications from the kube-apiserver to etcd use HTTPS, with optional client-side (two-way) TLS
- Communications from the kube-apiserver to kubelets can use HTTP or HTTPS, the latter is without validation by default (find this again in the docs)

## Where does it store data?

- Most data is stored in etcd, mainly under `/registry`
- Some data is obviously stored on the local host, to bootstrap the connection to etcd

## What is the most sensitive data it stores?

- Not much sensitive is directly stored on kube-apiserver
- However, all sensitive data within the system (save for in MCP-less setups) is processed and transacted via the kube-apiserver

## How is that data stored?

- On etcd, with the level of protection requested by the user
- looks like encryption [is a command line flag](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#configuration-and-determining-whether-encryption-at-rest-is-already-enabled)

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

- Not encrypting secrets in etcd by default
- requiring [a command line flag](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#configuration-and-determining-whether-encryption-at-rest-is-already-enabled)

## Secrets Management

## Authentication

## Authorization

## Multi-tenancy Isolation

## Summary

# Recommendations
