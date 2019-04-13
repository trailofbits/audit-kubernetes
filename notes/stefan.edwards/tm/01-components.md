# Components

The Kubernetes architecture is split into multiple components, many of which are stand-alone operating system binaries written in Go. Kubernetes uses a central API server to 
coördinate data across components; the API server itself takes (almost) no direct action, and instead is a simple, state-less manager for mapping Kubernetes resources to 
entries within the etcd system. The following is a table describing the eight selected Kubernetes components:

| Component | Description |
| :---: | :---: |
| kube-apiserver | A RESTful web server that handles coördination of all aspects of a cluster. Specifically, it accepts client requests for updating all other components within a cluster. These requests are authenticated, authorized, processed, and then stored within etcd for further processing and use. Clients may subscribe to topics in order to be notified of changes that are relevant to their interests; for example, a kubelet may listen for pod scheduling events that require the kubelet's action. |
| etcd | A key-value store that leverages gPRC and TLS (potentially with two-way, or client-authenticated TLS), used to store the most sensitive data within a cluster. Access to etcd should be restricted to as-few users as possible; generally, unrestrained access to etcd is considered "root" (or super user) access to the cluster itself. |
| kube-scheduler | A component that reads from pod descriptions and schedules the pods to nodes based on a scheduling algorithm and resource constraints. In practice, this means the scheduler "listens" to new pod creation on the API server, reviews the node list for potential resource allocation and rules, and updates the pod to be assigned to a specific node within the API server. A further process, namely the kubelet, will actually handle the task of running and executing the pod. |
| kube-controller-manager | A daemon that listens for specific updates within the API server, and stores those updates within the API server itself. The purpose of the daemon is to run "controllers" within an infinite loop, with each controller attempting to keep the state of the cluster consistent. This works by way of a call-back listener loop, and comparision of current cluster state with the desired state of the cluster as described by developers and administrators. |
| cloud-controller-manager | A daemon with similar purpose to kube-controller-manager, but instead of focusing on generic components within Kubernetes, focuses on maintaining consistency with cloud-platform-specific components that back a Kubernetes cluster. |
| kubelet | A worker component tasked with all aspects of node operations within a worker. It interacts with the Container Runtime, listens for pod scheduling and related events on the API server, and updates the API server as to pod availability, resource usage, and general status. It is also the endpoint the API server reaches out to for logs and other updates from nodes and pods within the cluster. |
| kube-proxy | A component to help, along with the Container Networking Interface (CNI), facilitate Kubernetes' transparent model of networking. Kubernetes requires that all nodes and pods be able to communicate without a (visible) Network Address Translation (NAT). kube-proxy utilizes `iptables` and either proxy or pass-thru modes in order to ensure that all containers, pods, and nodes are able to seemlessly communicate with one another, as if they were on a single network. |
| Container Runtime | A group of components that allow for the direct execution of containers within a cluster. This includes the necessary operating system integrations (such as `cgroups` on Linux), configuration settings, and Kubernetes interfaces to a container system, e.g. Docker, rkt, containerd) |

## Planes

Kubernetes itself is divided (roughly) into two "planes," or groupings of components. The following table describes each plane, and groups the aforementioned components:

| Plane | Description | Components |
| :---: | :---: | :---: |
| Control Plane | The Control Plane (CP) controls the state of the cluster, and ensures that the desired components are running as specified by the end user. Generally, these are grouped as Master (technically, the API server and related components) as well as the kubelet (which, whilst it is part of the CP, actually runs on the worker node). | kube-apiserver, kube-scheduler, (kube, cloud)-controller-manager, kubelet, etcd |
| Worker Node | The worker, on the other hand, executes the actual pods and containers that make up a client's applications. These components focus on running and networking pods and their associated containers. | kube-proxy, CNI, CRI, pods |
