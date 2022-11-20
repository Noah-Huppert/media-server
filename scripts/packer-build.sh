#!/usr/bin/env bash
declare -r PROG_DIR=$(dirname $(realpath "$0"))
source "$PROG_DIR/common.sh"

# Exit codes
# ... Options
declare -ri EXIT_CODE_UNKNOWN_OPT=10
declare -r EXIT_MSG_UNKNOWN_OPT="Unknown option"

declare -ri EXIT_CODE_BAD_STEP_ARG=11
declare -r EXIT_MSG_BAD_STEP_ARG="Invalid value for STEP argument"

# ... Packer build
declare -ri EXIT_CODE_FIND_PACKER_VAR_FILES=20
declare -r EXIT_MSG_FIND_PACKER_VAR_FILES="Failed to find Packer variable files"

declare -ri EXIT_CODE_PACKER_BUILD=21
declare -r EXIT_MSG_PACKER_BUILD=""

# Constants
declare -r PACKER_STEP_BASE_SYSTEM="base-system"
declare -r PACKER_STEP_SALT_APPLY="salt-apply"

declare -r PACKER_SOURCE_NAME="null.server"

declare -r PACKER_DIR="$PROG_DIR/../packer"

# Options
while getopts "h" opt; do
    case "$opt" in
        h)
            cat <<EOF
packer-build.sh - Perform Packer build steps

USAGE

  packer-build.sh [-h] [STEP...]

OPTIONS

   -h    Show this help text

ARGUMENTS

  STEP    Name of piece of Packer build to run (Allowed values: '$PACKER_STEP_BASE_SYSTEM', '$PACKER_STEP_SALT_APPLY'), can be provided multiple times to run steps in provided order (Default: '$PACKER_STEP_BASE_SYSTEM $PACKER_STEP_SALT_APPLY')

BEHAVIOR

  Invokes the 'packer build' command. Each "step" is a builder in Packer.
  Automatically includes '*.pkrvars.hcl' files.

EOF
            exit 0
            ;;
        '?') die "$EXIT_CODE_UNKNOWN_OPT" "$EXIT_MSG_UNKNOWN_OPT" ;;
    esac
done

shift $((OPTIND-1))

# Arguments
declare -a ARG_STEP=()
while [[ -n "$1" ]]; do
    if [[ "$1" != "$PACKER_STEP_BASE_SYSTEM" ]] || [[ "$1" != "$PACKER_STEP_SALT_APPLY" ]]; then
        elog "STEP argument must be: '$PACKER_STEP_BASE_SYSTEM', '$PACKER_STEP_SALT_APPLY'"
        die "$EXIT_CODE_BAD_STEP_ARG" "$EXIT_MSG_BAD_STEP_ARG"
    fi

    ARG_STEP+=("$1")
done

if [[ -z "${ARG_STEP[@]}" ]]; then
    ARG_STEP=("$PACKER_STEP_BASE_SYSTEM" "$PACKER_STEP_SALT_APPLY")
fi

# Run build steps
packer_build() { # ( builder_name )
    # Arguments
    local -r builder_name="$1"

    local -r full_builder_name="${builder_name}.${PACKER_SOURCE_NAME}"

    # Find var files
    local -a packer_opts=()

    if ls $PACKER_DIR/*.pkrvars.hcl &> /dev/null; then
        local ls_out
        ls_out=$(run_check "ls $PACKER_DIR/*.pkrvars.hcl" "$EXIT_CODE_FIND_PACKER_VAR_FILES" "$EXIT_MSG_FIND_PACKER_VAR_FILES") || exit

        for file in "$ls_out"; do
            packer_opts+=("-var-file=$file")
        done
    fi

    # Set build step
    packer_opts+=("-only=$full_builder_name")

    log "Packer build for '$builder_name'"
    run_check "packer build ${packer_opts[*]} $PACKER_DIR" "$EXIT_CODE_PACKER_BUILD" "$EXIT_MSG_PACKER_BUILD"
}

for step in "${ARG_STEP[@]}"; do
    packer_build "$step"
done