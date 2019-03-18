base:
  '*':
    - common.packages

  'salt-master':
    - krf.dependencies
    - pykrfd.install
