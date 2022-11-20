{% set dir = '/opt/rpi-media-server-setup/k3s'%}

k3s:
  # Install script
  install_script:
    # URL of install script
    url: https://get.k3s.io

    # SHA256 checksum of install script
    checksum: 3f51c04045932cdaa9a7e222130a1744b72f5c3bdd668aa829663a2e578c195a

    # Directory where installs script will be saved
    dir: {{ dir }}

    # Full path including directory to location where script will be saved
    full_script_path: {{ dir }}/install-k3s.sh