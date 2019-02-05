mine_functions:
  # We are limiting the IP addresses returned to only include
  # the host-only network interface.
  network.ip_addrs:
    interface: enp0s8
    cidr: '172.28.0.0/16'
