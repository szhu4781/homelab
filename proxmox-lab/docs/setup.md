# Proxmox Virtualization Lab Setup

## Prerequisites
- Beelink Mini S13 (or equivalent mini PC with 16GB RAM, 500GB NVMe)
- Proxmox VE 9.2 ISO flashed to USB drive (use Rufus or Balena Etcher)
- Windows Server 2022 Datacenter ISO
- Ubuntu Server 24.04 LTS ISO
- VirtIO driver ISO (virtio-win-0.1.285 or later)
- Cat6 ethernet cable connected to your router
- USB keyboard and HDMI display for initial Proxmox install only
---

## 1. Install Proxmox VE
1. Boot the mini PC from the Proxmox USB installer (spam F7 on Beelink to get boot menu)
2. Select **Install Proxmox VE (Graphical)**
3. Accept the EULA
4. Select the internal NVMe SSD as the target disk
5. Set your country, timezone, and keyboard layout
6. Set a strong root password and email
7. Configure network:
   - Hostname: `proxmox.home`
   - IP Address: `10.0.0.200` (IP within the same subnet range as router)
   - Gateway: `10.0.0.1` (IP of your router)
   - DNS: `8.8.8.8` (can set to Google's public DNS)
8. Complete install and reboot, remove USB when prompted
9. Access the web UI on your browser at `https://10.0.0.200:8006`
**Note: The URL address will be different depending on what you set your IP address to during installation.**

## 2. Upload ISOs to Proxmox
1. Log into Proxmox web UI
2. Go to **Datacenter > proxmox > local storage > ISO Images**
3. Upload:
   - Windows Server 2022 Datacenter ISO
   - Windows 10 ISO
   - Ubuntu Server 24.04 LTS ISO
   - virtio-win ISO

## 3. Create Windows Server 2022 VM (Domain Controller)
### VM Settings
| Setting | Value |
|---|---|
| Name | server-dc |
| OS Type | Microsoft Windows 10/2016/2019 |
| Machine | q35 |
| BIOS | OVMF (UEFI) |
| Disk | 100GB SCSI, VirtIO SCSI single |
| CPU | 2 cores, host type |
| RAM | 4096 MB |
| Network | VirtIO, vmbr0 |
| CD/DVD 1 | Windows Server 2022 ISO |
| CD/DVD 2 | virtio-win ISO |
| Qemu Agent | Enabled |
| TPM | v2.0 |

### Installation Notes
- When installer shows no disks, click **Load Driver** → browse virtio CD → `vioscsi\2k22\amd64`
- Install VirtIO network driver from `NetKVM\2k22\amd64` after OS install
- Run `virtio-win-guest-tools.exe` from the VirtIO CD after install
- Activate with your Windows Server Datacenter product key when prompte

## 4. Configure Static IP on Windows Server
1. Open **Network & Internet Settings > Change adapter options**
2. Right-click adapter > **Properties > IPv4 > Properties**
3. Set:
   - IP: `10.0.0.201` (Set this to an IP within the range of your gateway)
   - Subnet: `255.255.255.0`
   - Gateway: `10.0.0.1`
   - DNS: `127.0.0.1` (points to itself after AD DS promotion)
4. Disable IPv6 on the adapter to avoid DNS conflicts

## 5. Install Active Directory Domain Services
1. Open **Server Manager → Add Roles and Features**
2. Select **Active Directory Domain Services** and **DNS Server**
3. Complete installation
4. Click the notification flag → **Promote this server to a domain controller**
5. Select **Add a new forest**
6. Root domain name: `<DOMAIN_NAME>`
7. Set DSRM password
8. Accept DNS delegation warning
9. Complete promotion and reboot
**Note: You can choose whatever name you want for domain. Examples of name extension includes but not limited to: .local, .home, lab, .corp, etc.**

## 6. Provision Active Directory via PowerShell
Run scripts from `proxmox-lab/scripts/` on the Domain Controller:
```
# Create OUs
.\create-ou.ps1

# Create users
.\create-users.ps1

# Create groups and add members
.\create-groups.ps1

# Add users to groups
.\add-user2groups.ps1
```
See `proxmox-lab/docs/gpo-list.md` for GPO configuration details.
**Note: Copy-and-paste from host to VM is not enabled by default for noVNC, which is typically used for Proxmox VM consoles. There are ways to get that set up like changing the graphics display to SPICE or installing guest tools for QEMU, but I won't be including steps for setting those up here.**

## 7. Create Windows 10 Client VM
### VM Settings
| Setting | Value |
|---|---|
| Name | windows10-client |
| OS Type | Microsoft Windows 10/2016/2019 |
| Machine | q35 |
| BIOS | OVMF (UEFI) |
| Disk | 80GB SCSI, VirtIO SCSI single |
| CPU | 2 cores, host type |
| RAM | 4096 MB |
| Network | VirtIO, vmbr0 |
| CD/DVD 1 | Windows 10 ISO |
| CD/DVD 2 | virtio-win ISO |
| Qemu Agent | Enabled |

### Join to Domain
1. Set DNS to `10.0.0.201` (Domain Controller IP)
2. Disable IPv6 on the network adapter
3. Go to **System Properties > Change > Domain**
4. Enter `<DOMAIN_NAME>` (name of your domain)
5. Authenticate with domain admin credentials
6. Reboot the VM

## 8. Create Ubuntu Server VM (Nextcloud + SIEM)
### VM Settings
| Setting | Value |
|---|---|
| Name | nextcloud-server |
| OS Type | Linux 6.x kernel |
| Machine | i440fx (default) |
| BIOS | SeaBIOS |
| Disk | 100GB SCSI, VirtIO SCSI single |
| CPU | 2 cores, host type |
| RAM | 4096 MB |
| Network | VirtIO, vmbr0 |
| Qemu Agent | Enabled |

### Installation Notes
- Enable OpenSSH during Ubuntu Server install
- SSH in from your computer after install: `ssh username@<UBUNTU_SERVER_IP>`
- Clone Github repo and run Ansible playbook for Nextcloud:
```
git clone https://github.com/szhu4781/homelab.git
cd homelab/ansible
ansible-playbook -i inventory.ini homelab.yml --tags "common,nextcloud"
```

## 9. Deploy Elasticsearch and Kibana (Docker)
### Install Docker
```
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

### SIEM Setup
Create `docker-compose.yml` and deploy with reduced heap size for resource-constrained environments. See `proxmox-lab/docs/elastic-setup.md` for full configuration and Winlogbeat configuration.
