#!/bin/bash

# Get current WSL IP
WSL_IP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Update Windows hosts file
HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"

# Stream editor is used to clean up entries for the hosts file
sed -i "/pihole.home/d" $HOSTS_FILE
echo -e "$WSL_IP\tpihole.home" | tee -a $HOSTS_FILE > /dev/null

sed -i "/grafana.home/d" $HOSTS_FILE
echo -e "$WSL_IP\tgrafana.home" | tee -a $HOSTS_FILE > /dev/null

sed -i "/nextcloud.home/d" $HOSTS_FILE
echo -e "$WSL_IP\tnextcloud.home" | tee -a $HOSTS_FILE > /dev/null

# Update Windows DNS to point to Pi-hole
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Set-DnsClientServerAddress -InterfaceAlias 'Wi-Fi' -ServerAddresses ('$WSL_IP', '8.8.8.8')"

echo "WSL IP updated to $WSL_IP"
