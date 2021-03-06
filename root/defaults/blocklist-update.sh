#!/usr/bin/with-contenv bash

BLOCKLIST_ENABLED=`jq -r '.["blocklist-enabled"]' "$CONFIG_PATH"/settings.json`
BLOCKLIST_URL=`jq -r '.["blocklist-url"]' "$CONFIG_PATH"/settings.json | sed 's/\&amp;/\&/g'`

if [ $BLOCKLIST_ENABLED == true ]; then
	mkdir -p /tmp/blocklists
	rm -rf /tmp/blocklists/*
	cd /tmp/blocklists
	wget -q -O blocklist.gz "$BLOCKLIST_URL"
	if [ $? == 0 ]; then
		gunzip *.gz
		if [ $? == 0 ]; then
			chmod go+r *
			rm -rf "$CONFIG_PATH"/blocklists/*
			cp /tmp/blocklists/* "$CONFIG_PATH"/blocklists
			s6-svc -h /var/run/s6/services/transmission
		fi
	fi
fi
