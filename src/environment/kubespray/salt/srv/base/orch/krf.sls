Ensure the highstate is applied across all nodes:
  salt.state:
    - tgt: '*'
    - highstate: True

Refresh pillar data on the cluster:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: '*'

Build KRF on the salt master:
  salt.state:
    - tgt: 'salt-master'
    - sls:
      - krf.build

Install KRF to the cluster nodes:
  salt.state:
    - tgt: 'k8s-*'
    - sls:
      - krf.install
