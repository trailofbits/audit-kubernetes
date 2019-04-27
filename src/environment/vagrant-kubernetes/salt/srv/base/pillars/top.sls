base:
  # Include the kubernetes pillar on the salt master
  # to allow the control plane RP to be configured.
  'salt-master':
    - kubernetes
  # Use generic settings for all Kubernetes machines.
  'kube-*':
    - docker
    - network_mine
  # Kubernetes-master specific settings
  'kube-master-*':
    - kubernetes
    - etcd
  # Kubernetes-worker specific settings
  'kube-worker-*':
    - kubernetes
