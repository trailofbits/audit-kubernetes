include:
  - common.python_pip

Docker dependencies are installed:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg-agent
      - software-properties-common

Docker PPA is added:
  pkgrepo.managed:
    - humanname: DockerCE PPA
    - name: deb [arch={{ pillar["docker"]["architecture"] }}] {{ pillar["docker"]["repo_url"] }} {{ pillar["docker"]["distribution"] }} stable
    - key_url: {{ pillar["docker"]["gpg_key_url"] }}
    - gpgcheck: 1
    - require:
      - pkg: Docker dependencies are installed

Docker is installed:
  pkg.installed:
    - pkgs:
      - docker-ce
    - require:
      - pkgrepo: Docker PPA is added

Docker Python module is installed:
  pip.installed:
    - name: docker
    - require:
      - pkg: Python pip is installed
