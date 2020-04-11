#!/bin/ash
set -e

# logging functions
log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}
log_notice() {
	log Notice "$@"
}
log_warn() {
	log Warn "$@" >&2
}
log_error() {
	log ERROR "$@" >&2
	exit 1
}

exec "$@"
