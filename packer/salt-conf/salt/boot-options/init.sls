# Ensures that specific options exist in the kernel command line options file.
{{ pillar.boot_options.script.dir }}:
  file.directory:
    - makedirs: True

{{ pillar.boot_options.script.full_file_path }}:
  file.managed:
    - source: salt://boot-options/ensure-boot-options.py
    - require:
      - file: {{ pillar.boot_options.script.dir }}

{% for opt, value in pillar['boot_options']['options'].items() %}
{% set cmd = "python3 " + pillar['boot_options']['script']['full_file_path'] + " --options-file " + pillar['boot_options']['opts_file'] + " --option-name " + opt + " --option-value  " + value %}
{{ cmd }}:
  cmd.run:
    - unless: {{ cmd }} --check
    - require:
      - file: {{ pillar.boot_options.script.full_file_path }}
{% endfor %}