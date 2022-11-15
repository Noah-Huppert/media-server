#!/usr/bin/env bash
declare -r PROG_DIR=$(dirname $(realpath "$0"))
source "$PROG_DIR/common.sh"

# Exit codes
declare -ri EXIT_CODE_SALT_APPLY=10
declare -r EXIT_MSG_SALT_APPLY="Failed to apply Salt states"

# Apply Salt
log "Applying Salt"

run_check "sudo salt-call --local state.apply saltenv=base pillarenv=base" "$EXIT_CODE_SALT_APPLY" "$EXIT_MSG_SALT_APPLY"