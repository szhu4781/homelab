# Setup Guide

## Requirements and Environment
- Windows 10/11 with WSL2
- Ubuntu 24.04 LTS
- At least 8GB RAM recommended

## 1. Initial WSL Setup
Open Ubuntu terminal and update packages:
```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Fix Port 53 for Pi-hole
Disable systemd-resolved so Pi-hole can use port 53:
```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo rm /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

## 3. Install Pi-hole
```bash
git clone --depth 1 https://github.com/pi-hole/pi-hole.git /tmp/pihole
cd /tmp/pihole/automated\ install/
sudo bash basic-install.sh
```

Installer settings:
- Upstream DNS: Google (ECS, DNSSEC)
- Blocklists: Yes (StevenBlack)
- Web admin interface: Yes
- Query logging: Yes
- Privacy mode: Show everything

After install, stop lighttpd and start pihole-FTL:
```bash
sudo service lighttpd stop
sudo service pihole-FTL restart
```

Set a new admin password:
```bash
sudo pihole setpassword
```

## 4. Install Nginx
```bash
sudo apt install nginx -y
```
Change default port to 8080 in `/etc/nginx/sites-available/default`:
```
listen 8080 default_server;
listen [::]:8080 default_server;
```

Disable default site and create Pi-hole proxy:
```bash
sudo unlink /etc/nginx/sites-enabled/default
sudo nano /etc/nginx/sites-available/pihole
```

Paste:
```nginx
server {
    listen 8080;
    server_name pihole.home;

    location / {
        proxy_pass http://127.0.0.1:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Enable and reload:
```bash
sudo ln -s /etc/nginx/sites-available/pihole /etc/nginx/sites-enabled/
sudo service nginx start
```

## 5. Install Prometheus and Grafana

```bash
sudo apt install prometheus -y
```

Add Grafana repository and install:
```bash
sudo apt install -y apt-transport-https software-properties-common
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install grafana -y
sudo service grafana-server start
```

In Grafana (`http://<WSL_IP>:3000`):
- Add Prometheus data source at `http://localhost:9090`
- Import dashboard ID `1860` (Node Exporter Full)

## 6. Install Nextcloud

Install dependencies:
```bash
sudo apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-mysql php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip php-bz2
```

Set up database:
```bash
sudo service mariadb start
sudo mysql -u root
```

```sql
CREATE DATABASE nextcloud;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Download and install Nextcloud:
```bash
cd /tmp
wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install unzip -y
sudo unzip latest.zip -d /var/www/
sudo chown -R www-data:www-data /var/www/nextcloud
```

Configure Apache:
```bash
sudo nano /etc/apache2/sites-available/nextcloud.conf
```

Paste:
```apache
<VirtualHost *:8081>
    DocumentRoot /var/www/nextcloud
    ServerName nextcloud.home

    <Directory /var/www/nextcloud>
        Require all granted
        AllowOverride All
        Options FollowSymLinks MultiViews
    </Directory>
</VirtualHost>
```

Enable site and modules:
```bash
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo nano /etc/apache2/ports.conf  # Change Listen 80 to Listen 8081
sudo service apache2 restart
```

## 7. Install Wireguard

```bash
sudo apt install wireguard iptables -y
```

Generate server keys:
```bash
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
sudo chmod 600 /etc/wireguard/private.key
```

Create server config at `/etc/wireguard/wg0.conf`:
```ini
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <SERVER_PRIVATE_KEY>

PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <CLIENT_PUBLIC_KEY>
AllowedIPs = 10.0.0.2/32
```

Enable IP forwarding and start:
```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo wg-quick up wg0
```

## 8. Boot Automation

Create the update script:
```bash
sudo nano /usr/local/bin/update-wsl-ip.sh
```

See `scripts/update-wsl-ip.sh` in this repository.

Make it executable:
```bash
sudo chmod +x /usr/local/bin/update-wsl-ip.sh
```

Add to `/etc/wsl.conf`:
```ini
[boot]
systemd=true
command="/usr/local/bin/update-wsl-ip.sh && service pihole-FTL start && service nginx start && service prometheus start && service grafana-server start && service mariadb start && service apache2 start && wg-quick up wg0"

[user]
default=<your_username>
```

## 9. Windows DNS

Set your Wi-Fi DNS to your WSL IP:
- Go to Wi-Fi Properties → IPv4 → DNS
- Preferred: `<WSL_IP>`
- Alternate: `8.8.8.8`
