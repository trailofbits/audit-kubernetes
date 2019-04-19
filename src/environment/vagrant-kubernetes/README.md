# vagrant-kubernetes

## Description
`vagrant-kubernetes` is a testing environment allowing a Kubernetes cluster to be configured from a host, while executing within a guest virtual machine. SaltStack is leveraged to allow for guest management and configuration, as well as providing helpers for interacting with a Kubernetes cluster.

## System Design

### Overview
![System Overview][system_overview]

[system_overview]: docs/vagrant-kubernetes-System_Overview.png

### Guest provisioning
Vagrant is used to provision guest machines. Once provisioned, guest machines are able to be configured in-mass through SaltStack on the `salt_master`. To control the number of Kubernetes masters and workers, you can specify the following environment variable options:

* `K8_MASTERS=<Number of masters>` (default `1`)
* `K8_WORKERS=<Number of workers>` (default `1`)

The amount of ram and cpus dedicated to each machine can be controlled in a similar fashion:

* `(SALT_MASTER|K8_MASTER|K8_WORKER)_RAM=<ram>` (default `1024` for all except for `K8_MASTER`, which is `2048`)
* `(SALT_MASTER|K8_MASTER|K8_WORKER)_CPUS=<cpus>` (default `1` for all except for `K8_MASTER`, which is `2`)

### Guest configuration
#### SaltStack usage TL;DR
SaltStack was used to configure the vagrant-provisioned machines for several reasons:

1. To avoid rebuilding entire guest machines in order to propagate settings or configuration changes.
2. To allow trivial post-configuration management tasks (e.g. collecting/distributing files).
3. To provide reproducible and (mostly) platform-agnostic configuration.
4. To avoid hardcoded environment settings.

To facilitate this, several components of SaltStack are leveraged:

* **states**: States are used to ensure that configuration exists in a particular "state". For example, ensure a `docker` container is running, or that a configuration file exists. If the configuration does not exist, it will configure the component to match the specified state.
* **pillars**: Pillars are used to propagate static configuration settings from the master to the minions.
* **mines**: Mines are used to pull periodically updated information from the minions (e.g. IP addresses of interfaces attached to a minion machine). This information is available across every node, both minion and master.
* **orchestration**: Orchestration is leveraged to allow for ordered execution of salt commands and functions. Execution of orchestration files are performed from the salt master.

Using these components together with Vagrant, we are able to achieve the following workflow:

1. Perform `vagrant up` with configuration environment variables to control cpu/memory/etc.
2. Perform `vagrant ssh salt_master` to ssh into the `salt_master`.
3. Elevate permissions (e.g. `sudo su`) to execute `salt` commands with privileges.
4. Accept all configured minions using `salt-key -A`.
5. Execute an orchestration configuration (e.g. `salt-run state.orchestrate control_plane`).

#### `docker`
`docker` is used on both the master control plane, as well as on the Kubernetes nodes. Thus, every component under the `kube-*` scope has `docker` installed. The configuration of the `docker` installation can be specified within the `docker` salt pillar.

#### `nginx`
`nginx` is used as a reverse proxy for the Kubernetes API server. This allows for health checks to be performed against the API server, only balancing traffic to known-healthy endpoints. It also allows for the `kubeconfig` to be configured with a single address for the API server (similar to the availability of a DNS name).

#### `etcd`
`etcd` is a key component of the Kubernetes master control plane. As such, it is automatically configured when provisioning the Kubernetes master control plane. Execution is performed within a `docker` container, with certificate configuration possible through a specified mount point.

`etcd` configuration is built with both statically-defined pillar data, as well as polled mine data. Cluster `etcd` hosts are detected through salt minion ID targeting of this collected mine data in order to detect networking information, and pillar data is used to define the `etcd` docker image to use, and other similar types of information.

To Do:
* Allow minion targeting via pillar-specified target.
* Allow control of the `http://` || `https://` usage within the Pillar data
* Generate default certificates for trivial configuration of a "secure" `etcd` cluster.

#### `kube-apiserver`, `kube-controller-manager`, `kube-scheduler`, and `kube-proxy`
The `kube-apiserver`, `kupe-controller-manager`, and `kube-scheduler` are all configured as `docker` containers. Configuration details are provided through the use of a `kubeconfig`


To Do:
* Set up `docker` container configuration of these components.
* Generate default PKI data for these components.
* Generate a `kubeconfig` template for propagation.

#### `kubelet`
The `kubelet` is the one component of the Kubernetes architecture which runs natively in this configuration. Due to it's integration with `docker`, and it's role with ensuring containers are running for the Kubernetes cluster, it runs natively on the guest host.

To Do:
* Set up `systemd` configuration for the `kubelet`.


### Environment interactions

#### Shared folders
Shared folders are used to easily propagate files across all guest machines. The default shared folder is mounted at `/vagrant/` on all guests, and maps to the `vagrant-kubernetes/` directory on the host. Symlinks to shared folder entities are enabled by default by Vagrant. This could lead to [negative side-effects](https://phoenhex.re/2018-03-25/not-a-vagrant-bug), but is useful for the testing purposes this environment provides.

The shared folder is used in a similar fashion to a distributed filesystem. Since all guests hosts have access to it, file sharing, linking, and similar operations are able to be performed against it in a unified fashion.

#### Host port forwarding
Guests are all able to communicate with each-other through a host-only network. The host is subsequently able to interact with guests through this host-only network.

#### IP distribution
TBD
