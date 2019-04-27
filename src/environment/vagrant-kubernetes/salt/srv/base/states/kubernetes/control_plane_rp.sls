Install nginx as the reverse proxy:
  pkg.installed:
    - pkgs:
      - nginx

Configure nginx to point to the master control plane:
  file.managed:
    - name: /etc/nginx/sites-enabled/kubernetes-control-plane
    - source: {{ pillar["kubernetes"]["control_plane_rp_template"] }}
    - template: jinja
    - require:
      - pkg: Install nginx as the reverse proxy

Hot reload the nginx instance so our site can be detected:
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: Configure nginx to point to the master control plane
    - require:
      - file: Configure nginx to point to the master control plane
