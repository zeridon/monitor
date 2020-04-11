#!/bin/bash
set -eo pipefail
shopt -s nullglob

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

# create config files
if [ ! -f /config/mqtt_preferences ] ; then
	cat <<- EOF > /config/mqtt_preferences
	# ---------------------------
	#
	# MOSQUITTO PREFERENCES
	#
	# ---------------------------
	
	# IP ADDRESS OR HOSTNAME OF MQTT BROKER
	mqtt_address=192.168.166.10
	
	# MQTT BROKER USERNAME
	mqtt_user=monitor
	
	# MQTT BROKER PASSWORD
	mqtt_password='slu6alkoviden-kalamburozavur4ko!!!!'
	
	# MQTT PUBLISH TOPIC ROOT
	mqtt_topicpath=monitor
	
	# PUBLISHER IDENTITY
	mqtt_publisher_identity=''
	
	# MQTT PORT
	mqtt_port='1883'
	
	# MQTT CERTIFICATE FILE
	mqtt_certificate_path=''
	
	#MQTT VERSION (EXAMPLE: 'mqttv311')
	mqtt_version=''
	EOF

exec "$@"
