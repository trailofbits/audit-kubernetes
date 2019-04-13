# Trust Zones

Systems include logical "trust boundaries" or "zones" in which components may have different criticality or sensitivity. Therefore, in order to further analyze the system, we
decompose components into zones based on shared criticality, rather than physical placement within the system. Trust zones capture logical boundaries where controls should or
could be enforced by the system, and allow designers to implement interstitial controls and policies between zones of components as needed.

| Zone | Description | Included Components |
| :--: | :--: | :--: |
| Internet | The externally facing, wider internet zone. | kube-ctl, application clients |
| API Server | The central coördinator for the system, exposed only as much as needed for access from administrators with kubectl | kube-apiserver |
| Master Components | Internal portions of the Master node that work via callbacks and subscriptions to the API server | (kube, cloud)-controller-manager |
| Master Data | The data layer of the API server and master server(s) themselves. This boundary contains items such as Consul or etcd, and is tantamount to "root" or super-user access to the cluster when accessed in an uncontrolled fashion | etcd |
| Worker | The worker zone within a cluster includes all the components required to run worker processes. This includes things that are technically within the Master Control Plane such as kubelet, but are logically resident on the worker, and could be tampered within the event of a host compromise. | kubelet, kubeproxy, Container Runtime |

## Trust Zone Connections

Trust zones are only useful when we understand the data that flows between zones, and why. 

| Originating Zone | Destination Zone | Data Description | Connection Type |
| :---: | :---: | :---: | :---: |
| Internet | API Server | kubectl administration functionality, which could be a VPN or other bastion host with direct access to the API server | Authenticated HTTPS |
| Internet | Worker | Clients of the actual applications within the Kubernetes Worker nodes | Various (based on application) |
| API Server | Master Data | kube-apiserver retrieving and storing data from a key-value store such as etcd or Consul | HTTPS |
| Master Components | API Server | Items such as the Replication Manager retrieving and updating items managed by the API server | HTTPS/Internal Callbacks |
| API Server | Worker | Log and status retrieval from the API server to the individual Worker node's kubelet | HTTP |
| Worker | API Server | The kubelet on worker nodes must communicate with the API server for new pod allocations, to update status pods, and so on | HTTPS |
