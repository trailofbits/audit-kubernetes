Ensure the staging directory exists:
  file.directory:
    - name: {{ pillar["kubernetes"]["staging_directory"] }}

Ensure the Kubernetes staging directory exists:
  file.directory:
    - name: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes

Ensure the Kubernetes client binaries are downloaded:
  archive.extracted:
    - name: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes
    - source: {{ pillar["kubernetes"]["client_binaries_archive"] }}
    - source_hash: {{ pillar["kubernetes"]["client_binaries_archive_hash"] }}
    - require:
      - file: Ensure the Kubernetes staging directory exists

{% for binary in pillar["kubernetes"]["client_binaries_installed"] %}
Ensure the Kubernetes client binary {{ binary }} is in /usr/bin/ and executable:
  file.managed:
    - name: /usr/bin/{{ binary }}
    - source: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes/kubernetes/client/bin/{{ binary }}
    - mode: 655
    - require:
      - archive: Ensure the Kubernetes client binaries are downloaded
{% endfor %}

Ensure the Kubernetes server binaries are downloaded:
  archive.extracted:
    - name: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes
    - source: {{ pillar["kubernetes"]["server_binaries_archive"] }}
    - source_hash: {{ pillar["kubernetes"]["server_binaries_archive_hash"] }}
    - require:
      - file: Ensure the Kubernetes staging directory exists

{% for binary in pillar["kubernetes"]["server_binaries_installed"] %}
Ensure the Kubernetes server binary {{ binary }} is in /usr/bin/ and executable:
  file.managed:
    - name: /usr/bin/{{ binary }}
    - source: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes/kubernetes/server/bin/{{ binary }}
    - mode: 655
    - require:
      - archive: Ensure the Kubernetes server binaries are downloaded
{% endfor %}

Ensure the Kubernetes node binaries are downloaded:
  archive.extracted:
    - name: {{ pillar["kubernetes"]["staging_directory"]}}/kubernetes
    - source: {{ pillar["kubernetes"]["node_binaries_archive"] }}
    - source_hash: {{ pillar["kubernetes"]["node_binaries_archive_hash"] }}
    - require:
      - file: Ensure the Kubernetes staging directory exists

{% for binary in pillar["kubernetes"]["node_binaries_installed"] %}
Ensure the Kubernetes node binary {{ binary }} is in /usr/bin/ and executable:
  file.managed:
    - name: /usr/bin/{{ binary }}
    - source: {{ pillar["kubernetes"]["staging_directory"] }}/kubernetes/kubernetes/node/bin/{{ binary }}
    - mode: 655
    - require:
      - archive: Ensure the Kubernetes node binaries are downloaded
{% endfor %}
