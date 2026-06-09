# Home Lab Setup on WSL2
## Author: Shengwei Zhu

A self-hosted home lab running on Windows Subsystem for Linux (WSL2) featuring DNS filtering, reverse proxying, monitoring, cloud storage, and VPN.

## Requirements and Environment
- Windows 10/11 with WSL2 enabled
- WSL installed on your Windows system
- Ubuntu 24.04 LTS or similar installed (I installed mine from the Microsoft Store)
- Personal network since router access is required for DNS

## Stack
| Service | Purpose | URL |
|---|---|---|
| Pi-hole | DNS filtering & ad blocking | `http://pihole.home/admin` |
| Nginx | Reverse proxy | `http://172.22.71.14:8080` |
| Prometheus | Metrics collection | `localhost:9090` |
| Grafana | Monitoring dashboard | `http://grafana.home:3000` |
| Nextcloud | Personal cloud storage | `http://nextcloud.home:8081` |
| Wireguard | VPN server | Port 51820 |

## Architecture
```
Windows Host
└── WSL2 (Ubuntu 24.04)
├── Pi-hole (DNS + Web UI :80)
├── Nginx (Reverse Proxy :8080)
├── Prometheus (Metrics :9090)
├── Grafana (Dashboard :3000)
├── Apache2 + Nextcloud (Cloud :8081)
├── MariaDB (Database)
└── Wireguard (VPN :51820)
```

## Automation
A boot script (`scripts/update-wsl-ip.sh`) runs on every WSL launch and:
- Updates the Windows hosts file with the current WSL IP
- Sets Windows DNS to point to Pi-hole
- Starts all services automatically

## Note
- Replace all placeholder values in configs before use
- Database credentials should be changed from defaults

## Resouces
- [Pi-hole](https://github.com/pi-hole/docs)
- [Nginx Guide](https://nginx.org/en/docs/beginners_guide.html)
- [Grafana and Prometheus](https://grafana.com/docs/grafana/latest/fundamentals/getting-started/first-dashboards/get-started-grafana-prometheus/)
- [Wireguard Quick Start](https://www.wireguard.com/quickstart/)
- [Nextcloud User Manual](https://docs.nextcloud.com/server/stable/user_manual/en/)
