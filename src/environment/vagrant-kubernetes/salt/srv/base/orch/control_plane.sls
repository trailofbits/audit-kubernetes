Apply the base state to the masters:
  salt.state:
    - tgt: 'kube-master-*'
    - highstate: True

Refresh pillar data on the masters:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'kube-master-*'

Update the mine data from the masters:
  salt.function:
    - name: mine.update
    - tgt: 'kube-master-*'

Install Kubernetes binaries to the masters:
  salt.state:
    - tgt: 'kube-master-*'
    - sls:
      - kubernetes

Bootstrap the control plane reverse proxy:
  salt.state:
    - tgt: 'salt-master'
    - sls:
      - kubernetes.control_plane_rp

Bootstrap the control plane certificates:
  salt.state:
    - tgt: 'salt-master'
    - sls:
       - kubernetes.generate_certificates

Configure etcd across the master plane:
  salt.state:
    - tgt: 'kube-master-*'
    - sls:
      - etcd
