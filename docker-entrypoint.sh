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
	log_notice 'No mqtt_preferences. Creating ...'
	cat <<- EOF > /config/mqtt_preferences
	# ---------------------------
	#
	# MOSQUITTO PREFERENCES
	#
	# ---------------------------
	
	# IP ADDRESS OR HOSTNAME OF MQTT BROKER
	mqtt_address='${MONITOR_MQTT_SERVER:-0.0.0.0}'
	
	# MQTT BROKER USERNAME
	mqtt_user='${MONITOR_MQTT_USERNAME:-monitor}'
	
	# MQTT BROKER PASSWORD
	mqtt_password='${MONITOR_MQTT_PASSWORD:-password}'
	
	# MQTT PUBLISH TOPIC ROOT
	mqtt_topicpath='${MONITOR_MQTT_TOPIC_ROOT:-monitor}'
	
	# PUBLISHER IDENTITY
	mqtt_publisher_identity='${MONITOR_MQTT_PUBLISHER_IDENTITY:-}'
	
	# MQTT PORT
	mqtt_port='${MONITOR_MQTT_PORT:-1883}'
	
	# MQTT CERTIFICATE FILE
	mqtt_certificate_path='${MONITOR_MQTT_CERTIFICATE_PATH:-}'
	
	#MQTT VERSION (EXAMPLE: 'mqttv311')
	mqtt_version='${MONITOR_MQTT_VERSION:-}'
	EOF
fi

if [ ! -f /config/behavior_preferences ] ; then
	log_notice 'No behavior_preferences. Creating ...'
	cat <<- EOF > /config/behavior_preferences
	# ---------------------------
	#
	# BEHAVIOR PREFERENCES
	#
	# ---------------------------
	
	#MAX RETRY ATTEMPTS FOR ARRIVAL
	PREF_ARRIVAL_SCAN_ATTEMPTS='${MONITOR_PREF_ARRIVAL_SCAN_ATTEMPTS:-1}'
	
	#MAX RETRY ATTEMPTS FOR DEPART
	PREF_DEPART_SCAN_ATTEMPTS='${MONITOR_PREF_DEPART_SCAN_ATTEMPTS:-2}'
	
	#SECONDS UNTIL A BEACON IS CONSIDERED EXPIRED
	PREF_BEACON_EXPIRATION='${MONITOR_PREF_BEACON_EXPIRATION:-240}'
	
	#MINIMUM TIME BEWTEEN THE SAME TYPE OF SCAN (ARRIVE SCAN, DEPART SCAN)
	PREF_MINIMUM_TIME_BETWEEN_SCANS='${MONITOR_PREF_MINIMUM_TIME_BETWEEN_SCANS:-15}'
	
	#ARRIVE TRIGGER FILTER(S)
	PREF_PASS_FILTER_ADV_FLAGS_ARRIVE='${MONITOR_PREF_PASS_FILTER_ADV_FLAGS_ARRIVE:-.*}'
	PREF_PASS_FILTER_MANUFACTURER_ARRIVE='${MONITOR_PREF_PASS_FILTER_MANUFACTURER_ARRIVE:-.*}'
	
	#ARRIVE TRIGGER NEGATIVE FILTER(S)
	PREF_FAIL_FILTER_ADV_FLAGS_ARRIVE='${MONITOR_PREF_FAIL_FILTER_ADV_FLAGS_ARRIVE:-NONE}'
	PREF_FAIL_FILTER_MANUFACTURER_ARRIVE='${MONITOR_PREF_FAIL_FILTER_MANUFACTURER_ARRIVE:-NONE}'
	EOF
fi

if [ ! -f /config/known_beacon_addresses ] ; then
	log_notice 'No known_beacon_addresses. Creating empty ...'
	touch /config/known_beacon_addresses
fi
if [ ! -f /config/known_static_addresses ] ; then
	log_notice 'No known_static_addresses. Creating empty ...'
	touch /config/known_static_addresses
fi

exec "$@"
