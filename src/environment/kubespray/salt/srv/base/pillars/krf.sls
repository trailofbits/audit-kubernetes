krf:
  git:
    repository: https://github.com/trailofbits/krf.git
    clone_path: /tmp/krf/
    branch: master
  build:
    num_procs: 1
    dest_dir: /vagrant/salt/srv/base/assets/krf/
  dist:
    kernel:
      module: salt://krf/krfx.ko
    bins:
      krfctl: salt://krf/krfctl
      krfexec: salt://krf/krfexec
