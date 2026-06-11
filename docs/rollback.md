# Rollback Guide

## Pi-hole
### Disable temporarily
```
sudo pihole disable
```

### Stop service
```
sudo service pihole-FTL stop
```

### Full Uninstall
```
sudo pihole uninstall
sudo rm /etc/resolv.conf
sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
```
Also remove your `<WSL_IP>` from Windows Wi-Fi DNS settings.

---

## Nginx
```
sudo service nginx stop
sudo apt remove nginx -y
```

---

## Grafana
```
sudo service grafana-server stop
sudo apt remove grafana -y
```

---

## Prometheus
```
sudo service prometheus stop
sudo apt remove prometheus -y
```

---

## Nextcloud
```
sudo service apache2 stop
sudo rm -rf /var/www/nextcloud
sudo mysql -u root -e "DROP DATABASE nextcloud;"
sudo apt remove apache2 -y
```

---

## Wireguard
```
sudo wg-quick down wg0
sudo apt remove wireguard -y
```

---

## Full Lab Teardown
```
sudo pihole uninstall
sudo service nginx stop && sudo apt remove nginx -y
sudo service grafana-server stop && sudo apt remove grafana -y
sudo service prometheus stop && sudo apt remove prometheus -y
sudo wg-quick down wg0 && sudo apt remove wireguard -y
sudo service apache2 stop && sudo rm -rf /var/www/nextcloud && sudo apt remove apache2 -y
sudo service mariadb stop && sudo apt remove mariadb-server -y
```
