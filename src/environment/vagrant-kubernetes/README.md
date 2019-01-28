# vagrant-kubernetes

## Description
`vagrant-kubernetes` is a testing environment allowing a Kubernetes cluster to be configured from a host, while executing within a guest virtual machine. SaltStack is leveraged to allow for guest management and configuration, as well as providing helpers for interacting with a Kubernetes cluster.

## System Design

### Overview
![System Overview][system_overview]

[system_overview]: docs/vagrant-kubernetes-System_Overview.png

### Guest configuration
Vagrant is used to provision guest machines. Once provisioned, guest machines are able to be configured in-mass through `SaltStack` on the `salt_master`. To control the number of Kubernetes masters and workers, you can specify the following environment variable options:

* `K8_MASTERS=<Number of masters>`
* `K8_WORKERS=<Number of workers>`

### Host and guest interaction

#### Shared folders
Shared folders are used to easily propagate files across all guest machines. The default shared folder is mounted at `/vagrant/` on all guests, and maps to the `vagrant-kubernetes/` directory on the host.

#### Host port forwarding
Guests are all able to communicate with each-other through a host-only network. The host is subsequently able to interact with guests through this host-only network.

### Kubernetes binaries
While bootstrapping the `salt_master`, the Kubernetes binaries are downloaded and staged within the `staging/kubernetes/` directory. Other guests are then able to access the binaries through the mounted `/vagrant/` shared folder.


## Project layout
```
salt/
- master/
- minion/
- srv/
staging/
- *kubernetes/
vagrant/
```

### kubernetes/
The `kubernetes/` directory contains a `kubernetes-src.tar.gz` and the corresponding pre-built binaries. Pre-generated certificates have been included to allow for rapid building of the Kubernetes cluster.

### salt/
The `salt/` directory contains SaltStack related configuration files. Both the `minion` and `master` daemon configurations are propagated from the `salt/(master|minion)/config/(master|minion).yml` configuration files. The `salt/srv/` directory is used as the mounting point for the `salt-master`'s `file_roots`, allowing pillar data and formulas to be developed on the host, and used within the `salt-master` guest.

### staging/
The `staging/` directory is used for arbitrary file transfer between the host and guest. Files should not be committed to the repository under this directory. The Kubernetes binaries are shared within this directory, specifically under a `kubernetes/` subdirectory.

### vagrant/
The `vagrant/` directory is used to house Vagrant configuration scripts used during guest machine provisioning.
