The KRF user has been installed:
  user.present:
    - name: krf

{% for bin, src in pillar["krf"]["dist"]["bins"].items()  %}
Ensure the {{ bin }} binary exists on the host:
  file.managed:
    - name: /usr/bin/{{ bin }}
    - source: {{ src }}
    - mode: 655
{% endfor %}

The KRF kernel module exists from the source:
  file.managed:
    - name: /tmp/krfx.ko
    - source: {{ pillar["krf"]["dist"]["kernel"]["module"] }}

Install the KRF kernel module:
  cmd.run:
    - name: insmod /tmp/krfx.ko
    - check_cmd:
      - /bin/true
    - require:
      - file: The KRF kernel module exists from the source
      - user: The KRF user has been installed
