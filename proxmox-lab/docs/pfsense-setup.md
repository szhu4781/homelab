# pfSense Setup
*This assumes that you have Proxmox installed and ready to go. Refer to **setup.md** for details on setting up Proxmox. **You are NOT required to setup Active Directory or any services through Ubuntu. However, you will need a VM installed with a browser and internet access.***

## Requirements
- Beelink Mini S13 (or equivalent mini PC with 16GB RAM, 500GB NVMe)
- Proxmox VE fully set up
- Proxmox web UI accessible
- A spare Cat6 Ethernet cord connected to the router from the mini PC
- pfSense 2.7.2 ISO file. Link to downloading ISO file: https://repo.ialab.dsu.edu/pfsense/

## 1. Create Linux Bridges for WAN and LAN
1. Go to the **Datacenter > proxmox > System > Network** to open up the Network details.
2. At the top of the details, click on **Create** and select **Linux Bridge** under the dropdown. This will display a prompt for creating the Linux Bridge.
3. Name the first Linux bridge **vmbr1** in the Name field.
4. In the Ports/Slaves field, enter the interface name associated with the spare Ethernet cable that is connected between the mini PC and router. For this specific project, the name format is something like `enpXsY` where 'pX' is the prefix and 'sY' is the slot. (X and Y are the prefix and slot numbers, so they will be different depending on which port the Ethernet cable is connected to for both the router and mini PC)
5. After inputting the name and port for vmbr1, click Create and create the bridge. This bridge will be used for the WAN interface.
6. Repeat the process from step 3 to 6 for the LAN interface Linux bridge. For the LAN bridge, only the name is needed, the port is not required, so the Ports/Slaves field can be skipped. Name the LAN bridge **vmbr2** and click Create.

After making the LAN bridge, there should be three Linux bridges: **vmbr0, vmbr1, and vmbr2**. vmbr0 is the default bridge, vmbr1 will be the WAN bridge for the WAN interface, and vmbr2 will be the LAN bridge for the LAN interface. The WAN and LAN interface will be setup during the pfSense installation process.

## 2. Setting up Router/Firewall VM
### VM Settings
Specs should be adjusted based on system requirement
| Setting | Value |
|---|---|
| Name | router |
| OS Type | Linux 6.x kernel |
| Machine | Default(i440x) |
| BIOS | Default(SeaBIOS) |
| Disk | 50GB SCSI, VirtIO SCSI single |
| CPU | 2 cores, host type |
| RAM | 2048 MB |
| Network | VirtIO, vmbr1, vmbr2 |
| CD/DVD | pfSense ISO |
| Qemu Agent | Enabled |
| TPM | v2.0 |

1. Go to **Datacenter > proxmox** and create a VM.
2. After creating the VM, go to the **router VM > Options** and disable KVM hardware virtualization.
3. Then go to Hardware and edit the network devices for net0 and net1. For net0, change the bridge to the WAN Linux bridge. For net1, change the bridge to the LAN Linux bridge.
4. Go to Console and start up the VM and give it some time to process itself.
5. After it finishes processing, accept the copyright notice and select the install pfSense option and hit OK to continue
6. For disk partition, select **Auto(ZFS) Guided Root-on-ZFS** and select OK and press Enter. For ZFS Configuration, select **Install Proceed with Installation** for the configure options and select **stripe Stripe - No Redundancy** for the virtual device type and select OK and press Enter.
7. A list of harddisk devices will display. If there's only one option, press Spacebar to select it and select OK and press Enter.
8. When it asks about the destroying the contents of the disk you just selected, select Yes and press Enter or press Y.
9. Wait for it to fetch the files and finish installation. Once installation finishes, select Yes and press Enter to open a shell, and it will ask to reboot into the installed system. Select Reboot and press Enter or press R and wait for it to reboot.

## 3. Configuring WAN and LAN Interfaces
1. After the VM finishes rebooting, the wizard will prompt whether if VLANs should be set up now. For this setup, press n for No and press Enter.
2. When it asks about the WAN and LAN interface names, type vtnet0 for the WAN interface and vtnet1 for the LAN interface.
3. After that, a list of menu options will appear where you can assign interfaces, set IP addresses of interfaces, reboot system, etc. It should also show the IPs of the WAN and LAN interfaces. For this setup, DHCP and IPv6 will be disabled. Enter 2 to configure the WAN and LAN interface settings.
4. Select 1 or 2, whichever one is for the WAN interface, then press Enter.
5. Press n for No when it asks to configure IPv4 address WAN interface via DHCP. Enter the IP address the DHCP provided (the IP address that was displayed on top of the menu options). Set the subnet for the WAN interface to 24.
6. It will then ask for the gateway address for the WAN. Enter the gateway IP address associated with _your_ router.
7. Press n for No when it asks to configure IPv6 address WAN interface via DHCP. Press Enter to when it asks to enter a IPv6 address.
8. It will then disable DHCP for both IPv4 and IPv6, making the IP address static for the WAN interface. When it asks to revert to HTTP as the webConfigurer protocol, you can enter y for Yes or n for No. Wait for the changes to be saved and press Enter when prompted which will bring you back to the pfSense menu options.
9. Repeat steps 3 and configure the LAN interface this time.
10. Enter the IP address for the LAN interface. Set subnet to 24. Enter the gateway IP address.
11. Press Enter if it asks a LAN IPv6 address. Enter y for Yes when it ask to enable DHCP server on LAN. This will then prompt a starting and ending IP address range for the IPv4 client. The start and end range is the LAN IPv4 address entered in step 10 except the last octet will be where the starting and ending range is set. _Ex: Start range - 10.0.0.10 and end range - 10.0.0.254._ For this setup, last octet range will be set between 10 to 254.
12. After inputting the ranges, wait for the changes to save and Press Enter.

## 4. pfSense Portal Setup
A VM will be required for this part. This could be a domain controller or just a client system VM with Windows 10/11 installed. _Refer to setup.md for details on setting up a VM._
1. With your non-firewall/router VM, go to Hardware and change the Network Device (net0) bridge to the LAN Linux bridge.
2. Start up the VM and sign in, then open up a browser and type in `http://<WAN_IP_ADDRESS>`. Replace `WAN_IP_ADDRESS` with the actual IP address from the LAN interface. This will bring up a sign in page for pfSense.
3. The default credentials for signing into pfSense are: **admin** for the username and **pfsense** for the password. All letters are lowercase for both username and password.
4. After signing in, you will be greeted by a dashboard detailing the hardware specs and system information. At the top of the page, go to **System > General Setup**, which directs you to the firewall setup page.
5. Give a name and domain for the hostname and the domain. Set the DNS server addresses to `8.8.8.8` and `8.8.4.4`. Change the timezone and language if needed.
6. Save the settings at the bottom of the page once finished.
7. Go to **System > User Manager**, then click on the pencil icon for the user **admin**.
8. Type in a new password for the admin user, scroll down to the bottom of the page, and save the changes.

## References
- [pfSense Network Setup on Proxmox](https://www.youtube.com/watch?v=_NofH6TjB3U&t=3s)
- [pfSense VM Setup](https://www.youtube.com/watch?v=RpCjlyvOt18)
- [WAN and LAN Interface Configuration](https://www.youtube.com/watch?v=1HRjOvCRaZ8)
- [Virtualizing with Proxmox® VE by Negate](https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html)
