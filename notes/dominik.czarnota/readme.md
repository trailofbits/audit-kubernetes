
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


### Minikube

It hosts all the cluster inside a VM (can be configured to do that on host, but it is insecure/not recommended and doesn't work on MacOS).

Here, I create cluster using vmware:
```
➜ ./minikube --vm-driver=vmware start
😄  minikube v0.35.0 on darwin (amd64)
🔥  Creating vmware VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
📶  "minikube" IP address is 192.168.143.141
🐳  Configuring Docker as the container runtime ...
✨  Preparing Kubernetes environment ...
💾  Downloading kubeadm v1.13.4
💾  Downloading kubelet v1.13.4
🚜  Pulling images required by Kubernetes v1.13.4 ...
🚀  Launching Kubernetes v1.13.4 using kubeadm ...
⌛  Waiting for pods: apiserver proxy etcd scheduler controller addon-manager dns
🔑  Configuring cluster permissions ...
🤔  Verifying component health .....
💗  kubectl is now configured to use "minikube"
🏄  Done! Thank you for using minikube!
```

which hosted it on a VM on `192.168.143.141` which has a lot of services;
```
➜ sudo nmap -sN -p- 192.168.143.141
Starting Nmap 7.70 ( https://nmap.org ) at 2019-03-15 02:28 CET
Nmap scan report for 192.168.143.141
Host is up (0.0031s latency).
Not shown: 65518 closed ports
PORT      STATE         SERVICE
22/tcp    open|filtered ssh
111/tcp   open|filtered rpcbind
2049/tcp  open|filtered nfs
2376/tcp  open|filtered docker
2379/tcp  open|filtered etcd-client
2380/tcp  open|filtered etcd-server
5355/tcp  open|filtered llmnr
8443/tcp  open|filtered https-alt
10250/tcp open|filtered unknown
10255/tcp open|filtered unknown
10256/tcp open|filtered unknown
10257/tcp open|filtered unknown
10259/tcp open|filtered unknown
38195/tcp open|filtered unknown
39095/tcp open|filtered unknown
52589/tcp open|filtered unknown
52737/tcp open|filtered unknown
MAC Address: 00:0C:29:8D:F4:3E (VMware)

Nmap done: 1 IP address (1 host up) scanned in 19.38 seconds
```

Let's try all the ports:
* 22 - `nc` returns `SSH-2.0-OpenSSH_7.7`
* 111 - ???
* 2049 - ???
* 2376 - `curl` https - sslv3 alert bad certificate
* 2379 - `curl` https - sslv3 alert bad certificate
* 2380 - `curl` https - sslv3 alert bad certificate
* 5355 - connection refused
* 8443 - https, 403 forbidden
* 10250 - kubelet HTTPS: `/runningpods/` returns forbidden
* 10255 - kubelet HTTP: `/runningpods/` `Debug endpoints are disabled.`
* 10256 - proxy healthz HTTP: TODO: what endpoints?
* 10257 - controller manager: Internal Server Error on https
* 10259 - kube-scheduler https: 403 forbidden
* 38195 - ???
* 39095 - ???
* 52589 - ???
* 52737 - ???

Some logs from testing above:
```
➜ curl https://192.168.143.141:8443/ -k
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}%

➜ curl https://192.168.143.141:10250/runningpods/ -k
Forbidden (user=system:anonymous, verb=get, resource=nodes, subresource=proxy)

➜ curl https://192.168.143.141:10257/ -k
Internal Server Error: "/": subjectaccessreviews.authorization.k8s.io is forbidden: User "system:kube-controller-manager" cannot create resource "subjectaccessreviews" in API group "authorization.k8s.io" at the cluster scope

➜ curl https://192.168.143.141:10259/ -k
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}%
```

#### Minikube has addons

Default addons:
```
➜ ./minikube addons list
- addon-manager: enabled
- dashboard: disabled
- default-storageclass: enabled
- efk: disabled
- freshpod: disabled
- gvisor: disabled
- heapster: disabled
- ingress: disabled
- logviewer: disabled
- metrics-server: disabled
- nvidia-driver-installer: disabled
- nvidia-gpu-device-plugin: disabled
- registry: disabled
- registry-creds: disabled
- storage-provisioner: enabled
- storage-provisioner-gluster: disabled
```
