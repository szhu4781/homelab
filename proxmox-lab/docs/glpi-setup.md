# GLPI Setup Guide
### This setup involves GLPI version 10.0.17

## Prerequisites
- Ubuntu Server 24.04 VM (existing Nextcloud VM reused)
- Apache2 and MariaDB already installed (from Nextcloud setup)
- Available RAM: ~256-512MB
- Domain Controller reachable for LDAP integration

## 1. Install Dependencies
```
sudo apt update
sudo apt install -y apache2 php php-mysql php-curl php-gd php-intl php-ldap \
  php-mbstring php-xml php-zip php-bz2 php-imap php-apcu mariadb-server
```

## 2. Create the Database
```
sudo mysql -u root
```

```
CREATE DATABASE glpi;
CREATE USER 'glpi_admin'@'localhost' IDENTIFIED BY '<DB_PASSWORD>';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi_admin'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 3. Download and Extract GLPI
```
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
sudo tar -xzf glpi-10.0.17.tgz -C /var/www/
sudo chown -R www-data:www-data /var/www/glpi
```
**Note:** Check [GLPI releases](https://github.com/glpi-project/glpi/releases) for the current stable version before installing.

## 4. Configure Apache
```
sudo nano /etc/apache2/sites-available/glpi.conf
```

```
<VirtualHost *:8082>
    DocumentRoot /var/www/glpi/public
    ServerName glpi.home

    <Directory /var/www/glpi/public>
        Require all granted
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
</VirtualHost>
```
Enable the site and add the port:
```
sudo a2ensite glpi.conf
sudo a2enmod rewrite
echo "Listen 8082" | sudo tee -a /etc/apache2/ports.conf
sudo service apache2 restart
```

## 5. Add DNS Entry (Windows Host)
In PowerShell as Administrator on the Windows laptop:
```
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "10.0.0.115`tglpi.home"
```

## 6. Run the Web Installer

Navigate to `http://glpi.home:8082` in a browser and complete the installer:
1. Accept license
2. Select **Install** (not upgrade)
3. Resolve any compatibility warnings (see Troubleshooting below)
4. Database configuration:
   - **SQL server:** `localhost`
   - **SQL user:** `glpi_admin`
   - **SQL password:** `<DB_PASSWORD>`
   - **Database:** `glpi`
5. Complete installation
6. **Delete the install directory** when prompted (security requirement):
```
   sudo rm -rf /var/www/glpi/install
```

## 7. First Login
Default credentials:
- **Username:** `glpi`
- **Password:** `glpi`
Change the password immediately after first login. Also review/disable other 
default accounts (`glpi_admin`, `tech`, `normal`, `post-only`) under 
**Administration > Users**.

## 8. Configure Active Directory (LDAP) Integration
1. Go to **Setup > Authentication > LDAP directories**
2. Click **Add**
3. Configure:
| Field | Value |
|---|---|
| Name | <DOMAIN_NAME>.<DOMAIN_EXTENSION> |
| Server | 10.0.0.201 |
| Port | 389 |
| BaseDN | DC=<DOMAIN_NAME>,DC=<DOMAIN_EXTENSION> |
| RootDN | CN=Administrator,CN=Users,DC=<DOMAIN_NAME>,DC=<DOMAIN_EXTENSION> |
| Password | \<AD_ADMIN_PW\ |
| Login field | sAMAccountName |
| Sync field | sAMAccountName |

4. Find and click the **Test** button to verify connectivity
5. Save, then set the directory to **Active** (required for the import button to appear)

## 9. Import AD Users
1. Go to **Administration > Users**
2. Click the **LDAP Directory Link** button (appears once the LDAP directory is Active)
3. Select the directory with your domain name
4. Click **Search** — all AD users should appear
5. Select all users you would like to import
6. Choose **Import new users**
7. Click **Import**

All your selected domain users are now provisioned in GLPI and can authenticate using their AD credentials.

## 10. Configure Ticket Categories
Go to **Setup > Dropdowns > ITIL Categories** and create:
| Category | Type |
|---|---|
| Password Reset | Request |
| Hardware Issue | Incident |
| Software Request | Request |
| Network Issue | Incident |
| Access Request | Request |
| Security Incident | Incident |

You can create as many categories as you want.

## 11. Assign User Profiles
Go to **Administration > Users**, select a user, open the **Authorizations** 
tab, and assign a profile:

| Role | GLPI Profile |
|---|---|
| Executive / Admin | Super-Admin or Admin |
| IT staff | Technician |
| Department leads | Observer |
| General staff | Self-Service |

Bulk assignment: select multiple users on the Users list > **Actions** > **Add an authorization**.

## 12. Create Groups
Go to **Administration > Groups** and create groups matching the AD OU structure. Assign imported users to their respective group.

## ITIL Structure Reference
| Type | Purpose |
|---|---|
| **Incident** | Unplanned service interruption — restore service fast |
| **Request** | Planned, routine service request |
| **Problem** | Root cause investigation behind recurring incidents |
| **Change** | Planned modification to infrastructure/systems |
