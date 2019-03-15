
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
* 111 - rpcbind
* 2049 - ???
* 2376 - docker daemon HTTPS 
* 2379 - etcd HTTPS - listen/advertise sclient-urls
* 2380 - etcd HTTPS - listen/advertise peer-urls
* 5355 - connection refused
* 8443 - https, 403 forbidden
* 10250 - kubelet HTTPS: `/runningpods/` returns forbidden
* 10255 - kubelet HTTP: `/runningpods/` `Debug endpoints are disabled.`
* 10256 - proxy healthz HTTP: TODO: what endpoints?
* 10257 - controller manager: Internal Server Error on https
* 10259 - kube-scheduler https: 403 forbidden
* 38195 - ???
* 39095 - rpc.mountd ?
* 52589 - rpc.mountd ?
* 52737 - rpc.mountd ?

Some logs from testing above:
```bash
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

The `minikube ssh` command let us ssh into the VM and inspect other ports. It uses `busybox` so e.g. `lsof -i :PORT` doesn't work.

The ports can be inspected via `cat /proc/net/tcp` (as suggested on https://serverfault.com/questions/219984/busybox-netstat-no-p).

For example, we can find out that port 111 (006F in hex) is bound by `rpcbind` command:
```bash
$ cat /proc/net/tcp | grep 006F
   9: 00000000:006F 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 16290 1 00000000cb421112 100 0 0 10 0

$ sudo ls  -la /proc/*/fd | grep -B15 16290
/proc/3192/fd:
total 0
dr-x------ 2 root root  0 Mar 15 15:28 .
dr-xr-xr-x 9 root root  0 Mar 15 01:46 ..
lrwx------ 1 root root 64 Mar 15 15:34 0 -> /dev/null
lrwx------ 1 root root 64 Mar 15 15:34 1 -> /dev/null
lrwx------ 1 root root 64 Mar 15 15:34 10 -> socket:[16292]
lrwx------ 1 root root 64 Mar 15 15:34 11 -> socket:[16293]
lrwx------ 1 root root 64 Mar 15 15:34 12 -> socket:[17431]
lrwx------ 1 root root 64 Mar 15 15:34 2 -> /dev/null
lrwx------ 1 root root 64 Mar 15 15:34 3 -> socket:[16980]
lr-x------ 1 root root 64 Mar 15 15:34 4 -> /run/rpcbind.lock
lrwx------ 1 root root 64 Mar 15 15:34 5 -> socket:[17196]
lrwx------ 1 root root 64 Mar 15 15:34 6 -> socket:[16288]
lrwx------ 1 root root 64 Mar 15 15:34 7 -> socket:[16289]
lrwx------ 1 root root 64 Mar 15 15:34 8 -> socket:[16290]

$ cat /proc/3192/cmdline
/usr/bin/rpcbind$
```

Port 2049 (0x0801) - not found?:
```
$ cat /proc/net/tcp | grep 0801
  14: 00000000:0801 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 16319 1 000000000f736b62 100 0 0 10 0
$ sudo ls  -la /proc/*/fd | grep -B15 16319
$
```

Some useful commands - show port <-> socket inode (not sure if this is good name) mapping:
```bash
$ cat /proc/net/tcp | awk '{split($2,a,":"); print sprintf("%d","0x"a[2])" "$10}' |  sort
```

[ALMOST, not working fully] For a given `$port` find the associated socket, note that doing `grep -B20` instead of `grep` might show the PID that uses this socket:
```bash
$ sudo ls -la /proc/*/fd | grep "$(cat /proc/net/tcp | awk '{split($2,a,":"); print sprintf("%d","0x"a[2])" "$10}' | grep $port | awk '{print $2}')"
```

Port 2376 is a https for docker daemon:
```bash
$ ps auxf | grep dockerd
docker   27563  0.0  0.0   9240   480 pts/0    S+   16:10   0:00              \_ grep dockerd
root      3637  1.2  3.3 644280 68736 ?        Ssl  08:12   5:44 /usr/bin/dockerd -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=vmware --insecure-registry 10.96.0.0/12
```

Port 39095:
```bash
$ export port=39095
$ echo $port
39095
$ echo "$(cat /proc/net/tcp | awk '{split($2,a,":"); print sprintf("%d","0x"a[2])" "$10}' | grep $port | awk '{print $2}')"
15824

$ sudo ls -la /proc/*/fd | grep 15824
lrwx------ 1 root root 64 Mar 15 15:34 12 -> socket:[15824]

$ sudo ls -la /proc/*/fd | grep 15824 -B15
lrwx------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 4 -> anon_inode:[eventpoll]
lrwx------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 5 -> anon_inode:[signalfd]
lrwx------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 6 -> anon_inode:[timerfd]
lr-x------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 7 -> /proc/sys/kernel/hostname
lr-x------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 8 -> anon_inode:inotify
lrwx------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 9 -> socket:[15742]

/proc/3159/fd:
total 0
dr-x------ 2 root root  0 Mar 15 15:28 .
dr-xr-xr-x 9 root root  0 Mar 15 01:46 ..
lrwx------ 1 root root 64 Mar 15 15:34 0 -> /dev/null
lrwx------ 1 root root 64 Mar 15 15:34 1 -> /dev/null
lrwx------ 1 root root 64 Mar 15 15:34 10 -> socket:[15818]
lrwx------ 1 root root 64 Mar 15 15:34 11 -> socket:[15821]
lrwx------ 1 root root 64 Mar 15 15:34 12 -> socket:[15824]
$ sudo ls -la /proc/3159/exe
lrwxrwxrwx 1 root root 0 Mar 15 01:46 /proc/3159/exe -> /usr/sbin/rpc.mountd
```

Port 52895:
```bash
$ export port=52589

$ echo "$(cat /proc/net/tcp | awk '{split($2,a,":"); print sprintf("%d","0x"a[2])" "$10}' | grep $port | awk '{print $2}')"
15812

$ sudo ls -la /proc/*/fd | grep 15812 -B30 | grep proc
lr-x------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 7 -> /proc/sys/kernel/hostname
/proc/3159/fd:
lrwx------ 1 root root 64 Mar 15 15:34 3 -> /proc/3157/net/rpc/auth.unix.ip/channel
lrwx------ 1 root root 64 Mar 15 15:34 4 -> /proc/3157/net/rpc/nfsd.export/channel
lrwx------ 1 root root 64 Mar 15 15:34 5 -> /proc/3157/net/rpc/nfsd.fh/channel
$ sudo ls -la /proc/3159/exe
lrwxrwxrwx 1 root root 0 Mar 15 01:46 /proc/3159/exe -> /usr/sbin/rpc.mountd
```

Port 52737:
```bash
$ export port=52737
$ echo "$(cat /proc/net/tcp | awk '{split($2,a,":"); print sprintf("%d","0x"a[2])" "$10}' | grep $port | awk '{print $2}')"
15818
$ sudo ls -la /proc/*/fd | grep -B30 15818 | grep proc
/proc/3156/fd:
lr-x------ 1 systemd-resolve systemd-resolve 64 Mar 15 01:46 7 -> /proc/sys/kernel/hostname
/proc/3159/fd:
$ sudo ls -la /proc/3159/exe
lrwxrwxrwx 1 root root 0 Mar 15 01:46 /proc/3159/exe -> /usr/sbin/rpc.mountd
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
