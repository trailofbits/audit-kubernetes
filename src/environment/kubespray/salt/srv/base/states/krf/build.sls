include:
  - krf.dependencies

Ensure KRF is cloned:
  git.cloned:
    - name: {{ pillar["krf"]["git"]["repository"] }}
    - target: {{ pillar["krf"]["git"]["clone_path"] }}
    - branch: {{ pillar["krf"]["git"]["branch"] }}
    - require:
      - pkg: Dependencies are installed

Ensuure destination directory exists:
  file.directory:
    - name: {{ pillar["krf"]["build"]["dest_dir"] }}

Build KRF within the cloned directory:
  cmd.run:
    - name: make -j{{ pillar["krf"]["build"]["num_procs"] }}
    - cwd: {{ pillar["krf"]["git"]["clone_path"] }}
    - require:
      - git: Ensure KRF is cloned

{% for bin, path in [('krfctl', 'src/krfctl/'), ('krfexec', 'src/krfexec/'), ('krfx.ko', 'src/module/')] %}
Ensure {{ bin }} is moved to the build destination directory:
  file.managed:
    - name: {{ pillar["krf"]["build"]["dest_dir"] }}{{ bin }}
    - source: {{ pillar["krf"]["git"]["clone_path"] }}{{ path }}{{ bin }}
{% endfor %}
