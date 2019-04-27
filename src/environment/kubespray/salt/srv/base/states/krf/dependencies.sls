Dependencies are installed:
  pkg.installed:
    - pkgs:
      - build-essential
      - ruby
      - linux-headers-{{ salt['cmd.shell']('uname -r') }}
