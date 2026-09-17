# pfSense Setup
*This assumes that you have Proxmox installed and ready to go. Refer to **setup.md** for details on setting up Proxmox. **You are NOT required to setup Active Directory or any services through Ubuntu. This setup involves a dedicated firewall-router VM, that does not depend on other VMs.***

## Requirements
- Beelink Mini S13 (or equivalent mini PC with 16GB RAM, 500GB NVMe)
- Proxmox VE fully set up
- Proxmox web UI accessible
- A spare Cat6 Ethernet cord connected to the router from the mini PC
- - pfSense 2.7.2 ISO file. Link to downloading ISO file: https://repo.ialab.dsu.edu/pfsense/

## 1. Create Linux Bridges for WAN and LAN
1. Navigate to your main proxmox node. This is usually found under the Datacenter at the resource tree on the left.
2. Click on the proxmox node, then click on **System** with a dropdown arrow from the sidebar next to the resource tree sidebar to open a dropdown. Select **Network** from the dropdown. 
3. After clicking on **Network** from the dropdown, the Network settings for the proxmox node should appear. Click on the button labelled **Create** with a dropdown arrow and select Linux Bridge.
4. You will be then be prompted to name your Linux Bridge and assign a IP or port to the bridge. For this setup, only a name and port are needed. Name the first Linux bridge **vmbr1** in the Name field.
5. For the Ports/Slaves field of the **vmbr1** bridge, enter the interface name associated with the spare Ethernet cable that is connected between the mini PC and router. For this specific project, the name format is something like `enpXsY` where 'pX' is the prefix and 'sY' is the slot. (X and Y are the prefix and slot numbers, so they will be different depending on which port the Ethernet cable is connected to for both the router and mini PC)
6. After inputting the name and port for **vmbr1**, click Create and create the bridge. This bridge will be used for the WAN interface.
7. Repeat the process from step 3 to 6 for the LAN interface Linux bridge. For the LAN bridge, only the name is needed, the port is not required, so the Ports/Slaves field can be skipped. Name the LAN bridge **vmbr2** and click Create.
8. After making the LAN bridge, there should be three Linux bridges: **vmbr0, vmbr1, and vmbr2**. vmbr0 is the default bridge, vmbr1 will be the WAN bridge for the WAN interface, and vmbr2 will be the LAN bridge for the LAN interface.

*The WAN and LAN interface will be setup during the pfSense installation process.* 

## 2. Setting up Router/Firewall VM
1. 
