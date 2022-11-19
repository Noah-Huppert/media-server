{% set dir = '/opt/rpi-media-server-setup/boot-options' %}
boot_options:
  # Options already existing won't be deleted, but if these options don't exist they will be added
  options:
    cgroup_memory: "1"
    cgroup_enable: memory

  # Path to options file
  opts_file: /boot/cmdline.txt

  # Script which ensures boot options exist
  script:
    # Directory for script
    dir: {{ dir }}

    # Path to script including directory and file name
    full_file_path: {{ dir }}/ensure-boot-options.py