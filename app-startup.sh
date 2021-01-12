#! /bin/bash

export CONFIG_FILE="/config/.config/qBittorrent/qBittorrent.conf"
if [[ -f $CONFIG_FILE ]]; then
	echo "Found existing config file"
else
	echo "QBittorrent configuration file not found.  Creating a new one..."
	cp /opt/defaults/qBittorrent.conf $CONFIG_FILE
fi

# Update the VPN port
echo "Updating port forward to $VPN_PORT"

if [[ -f $CONFIG_FILE ]]; then
	PTCFG=$(cat $CONFIG_FILE | grep "PortRangeMin" | wc -l )
	if [[ ${PTCFG} -ne 1 ]]; then
		echo "Configuration file does not have port config line Connection\\PortRangeMin"
	else
		sed -i "s@Connection\\\\PortRangeMin=[0-9]\\+@Connection\\\\PortRangeMin=$VPN_PORT@g" $CONFIG_FILE
	fi
else
	echo "QBittorrent configuration file not found"
fi

# Run Qbittorrent

echo "Starting qBittorrent Service"

echo -n "y\n" | qbittorrent-nox

