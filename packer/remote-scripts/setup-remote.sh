#!/usr/bin/env bash
declare -r PROG_DIR=$(dirname $(realpath "$0"))
source "$PROG_DIR/common.sh"

# Exit codes
declare -ri EXIT_CODE_GENERAL_SYSTEM_UPDATE=10
declare -r EXIT_MSG_GENERAL_SYSTEM_UPDATE="Failed to update all packages which were already installed on the system"

declare -ri EXIT_CODE_SALT_INSTALL=11
declare -r EXIT_MSG_SALT_INSTALL="Failed to install Salt"

# Setup
# ... General system update
log "Updating system"

run_check "sudo apt-get update && sudo apt-get upgrade -y" "$EXIT_CODE_GENERAL_SYSTEM_UPDATE" "$EXIT_MSG_GENERAL_SYSTEM_UPDATE"

# ... Install Salt
log "Installing Salt"

run_check "sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/debian/11/armhf/3004/salt-archive-keyring.gpg && echo \"deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=armhf] https://repo.saltproject.io/py3/debian/11/armhf/3004 bullseye main\" | sudo tee /etc/apt/sources.list.d/salt.list && sudo apt-get update && sudo apt-get install -y salt-master salt-minion" "$EXIT_CODE_SALT_INSTALL" "$EXIT_MSG_SALT_INSTALL"