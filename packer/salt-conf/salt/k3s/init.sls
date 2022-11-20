# Install k3s.
{{ pillar.k3s.install_script.dir }}:
  file.directory:
    - makedirs: True

put_install_script:
  file.managed:
    - name: {{ pillar.k3s.install_script.full_script_path }}
    - source: {{ pillar.k3s.install_script.url }}
    - source_hash: {{ pillar.k3s.install_script.checksum }}
    - mode: 744
    - require:
      - file: {{ pillar.k3s.install_script.dir }}

run_install_script:
  cmd.run:
    - name: bash {{ pillar.k3s.install_script.full_script_path }}
    - unless: which k3s
    - require:
      - file: put_install_script