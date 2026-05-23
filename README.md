# Home Lab Setup on WSL2
## Author: Shengwei Zhu
---
A self-hosted home lab running on Windows Subsystem for Linux (WSL2) featuring DNS filtering, reverse proxying, monitoring, cloud storage, and VPN.

## Stack
| Service | Purpose | URL |
|---|---|---|
| Pi-hole | DNS filtering & ad blocking | `http://pihole.home/admin` |
| Nginx | Reverse proxy | `http://172.22.71.14:8080` |
| Prometheus | Metrics collection | `localhost:9090` |
| Grafana | Monitoring dashboard | `http://grafana.home:3000` |
| Nextcloud | Personal cloud storage | `http://nextcloud.home:8081` |
| Wireguard | VPN server | Port 51820 |

