The etcd Docker image is installed:
  docker_image.present:
    - name: {{ pillar["etcd"]["image"] }}


{% set advertise_address = salt["mine.get"](grains.id, "network.ip_addrs").items()[0][1][0] %}
{% set etcd_name = grains.id.split("-")[2] %}
{% set initial_cluster = [] %}

The etcd Docker image is running:
  docker_container.running:
    - name: etcd-kubernetes
    - image: {{ pillar["etcd"]["image"] }}
    - port_bindings:
      - {{ pillar["etcd"]["bind_address"] }}:4001:4001
      - {{ pillar["etcd"]["bind_address"] }}:2380:2380
      - {{ pillar["etcd"]["bind_address"] }}:2379:2379
    - binds:
      - {{ pillar["etcd"]["pki_directory"]["host"] }}:{{ pillar["etcd"]["pki_directory"]["guest"] }}:ro
    - environment:
      - ETCD_ADVERTISE_CLIENT_URLS=http://{{ advertise_address }}:2379,http://{{ advertise_address }}:4001
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379,http://0.0.0.0:4001
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://{{ advertise_address }}:2380
      - ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
      - ETCD_NAME=etcd{{ etcd_name }}
      - ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster
      {% for server, addresses in salt["mine.get"]("kube-master-*", "network.ip_addrs").items() -%}
      - ETCD_INITIAL_CLUSTER={{ "etcd%s=%s"|format(server.split("-")[2], "http://" + addresses[0] + ":2380") }} {% if not loop.last %},{% endif %}
      {%- endfor %}
      - ETCD_INITIAL_CLUSTER_STATE=new
