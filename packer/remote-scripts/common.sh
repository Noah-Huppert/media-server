#!/usr/bin/env bash
# Output log message
log () { # ( msg )
    local -r msg="$1"
    echo "$(date --iso-8601=seconds) $msg"
}

# Output error message
elog() { # ( msg )
    local -r msg="$1"
    log "$msg" >&2
}

# Execute a command, if it fails exit with $exit_code and write $err_msg to stderr.
run_check () { # ( cmd, exit_code, err_msg )
    local -r cmd="$1"
    local -ri exit_code=$2
    local -r err_msg="$3"

    if ! eval "$cmd"; then
        elog "$err_msg"
        exit $exit_code
    fi
}

# Ensure utilities used by these functions are the variants expected
declare -ri EXIT_CODE_COMMON_SH_INTERNAL_ERROR=255

if ! date --help | grep "GNU coreutils" &> /dev/null; then
    elog "The 'date' utility must be the GNU coreutils variant"
    exit $EXIT_CODE_COMMON_SH_INTERNAL_ERROR
fi