# Troubleshooting Guide

## Pi-hole
### Installer hangs on "Installing Pi-hole dependency package"
The curl one-liner sometimes hangs in WSL. Fix by cloning directly:
```
git clone --depth 1 https://github.com/pi-hole/pi-hole.git /tmp/pihole
cd /tmp/pihole/automated\ install/
sudo bash basic-install.sh
```

### Port 53 already in use
systemd-resolved occupies port 53 by default. Fix:
```
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo rm /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### Web interface shows directory listing instead of dashboard
Pi-hole v6 uses its own built-in web server (FTL) instead of lighttpd.
Stop lighttpd and restart FTL:
```
sudo service lighttpd stop
sudo service pihole-FTL restart
```

### Wrong password on login
The repair process resets the password. Set a new one:
```
sudo pihole setpassword
```
---
## Nginx
### Failed to start - port already in use
Pi-hole FTL occupies port 80. Run Nginx on port 8080 instead.
Change in `/etc/nginx/sites-available/default`:
```
listen 8080 default_server;
listen [::]:8080 default_server;
```
---
## Apache / Nextcloud
### Apache stealing port 80 from Pi-hole
Apache defaults to port 80. Remove it from ports.conf:
```
sudo nano /etc/apache2/ports.conf
# Remove "Listen 80", keep only "Listen 8081"
sudo service apache2 restart
sudo service pihole-FTL restart
```
---
## Wireguard
### iptables command not found
```
sudo apt install iptables -y
```
---
## WSL General
### WSL IP changes on restart
The boot script `update-wsl-ip.sh` handles this automatically.
If services break after a network change, run manually:
```
sudo /usr/local/bin/update-wsl-ip.sh
```
### .local domains not resolving in Windows
Windows intercepts `.local` domains for mDNS. Use `.home` instead and add to Windows hosts file: `C:\Windows\System32\drivers\etc\hosts`

