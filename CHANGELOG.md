# Changelog
## 2026-06-23
- Documentation for Proxmox Lab and Elastic setup has been added to /proxmox-lab. See **proxmox-lab/docs** for proxmox-lab/docs/setup.md and proxmox-lab/doc/elastic-setup.md
- Fixed some formatting issues in README.md
- Included the docker-compose.yml file in /proxmox-lab/scripts
- Included list of GPOs that were setup in domain controller VM. See /proxmox-lab/docs/gpo-list.md.

## 2026-06-22
- Updated README.md with details on expanding homelab and installing Proxmox VE on mini PC for server hosting
- Added a dedicated **Projects** section to split WSL2 homelab and Proxmox VE lab apart
- Added a **Proxmox Virtualization Lab** section that summarizes what was implemented with Proxmox VE
- Updated architecture diagram to include Proxmox VE host
- Added a new folder **/proxmox-lab** to store documentation and scripts for the Proxmox VE lab
- Added PowerShell scripts that were used in the lab for setting up organizational units (OU), users and groups on the domain controller (DC) VM in Proxmox
- _Documentation for Proxmox lab and Elastic setup will be added soon, I spent 2 days on setting everything up including GPOs and I need some rest._

## 2026-06-10
- Adjusted colors of the architecture diagram to make it more visible
- Added Ansible playbook and scripts for deployment
- Restored repository files after they were accidently overwritten by `git pull force`

## 2026-06-09
- Added a new **Resouces** section
- Updated README.md with useful links and resources
- Added rollback.md in docs folder as a Rollback plan for each service installed
- Added architecture diagram to repository, made with Draw.io

## 2026-06-08
- Changelog has officially been made
- Changed **Prerequisite** heading to **Requirements and Environment** in README.md
- Added a new **docs** folder with markdown files for setting up services (setup.md) and troubleshooting guide (troubleshooting.md)

## 2026-05-22
- Created repository to store homelab scripts and documents
- Added scripts for setting up Nginx, Wireguard, and Apache
- Added info to README.md
