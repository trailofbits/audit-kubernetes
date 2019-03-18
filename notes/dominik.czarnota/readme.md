## Links

* [Static analysis - results of gosec/errcheck](static_analysis.md)
* [Minikube notes](minikube_notes.md)
* [linkcheck notes](linkcheck.md)

## Kubernetes components 
### Master / Cluster Control Plane
* kube-apiserver - handles pods, balances load
* etcd - key/value storage
* kube-scheduler
* kube-controller-manager
* cloud-controller-manager

### Node
* kubelet - undocumented API, the kube-apiserver(?) connects to it(?)
* kube-proxy - not really a proxy, just manages network (iptables etc)
* Container Runtime - containerd, runc, docker

### TODO
List of random things to check out/revisit/think about during the audit:
* Minikube - local testing environment - hosted by default in a VM; what are the default services exposed? Maybe it lets some horrible CSRF attacks?
* What are all places where JWT (JSON Web Tokens) are used? There are many flaws that could occur here (see https://sekurak.pl/jwt-security-ebook.pdf - unfortunately in Polish)
* How do kubernetes parse user's certs when using RBAC? Is it fuzzed by them?
* The default token stored in etcd lies in a brutable directory (5 random chars):
```
$ etcdctl --insecure-skip-tls-verify --insecure-transport=false --endpoints=https://172.31.25.93:2379 get / --prefix --keys-only | grep kube-system | grep default-tok
/registry/secrets/kube-system/default-token-zvkfq
```

