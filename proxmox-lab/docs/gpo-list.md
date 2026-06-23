# Group Policy Object Configuration

## Default Domain Policy
- Minimum password length: 12
- Password complexity: Enabled
- Account lockout threshold: 5 attempts
- Lockout duration: 15 minutes

## Screen Saver Policy
- Screen saver is forced with executable srcnsave.src
- Screen saver is protected by password
- Global screen saver timeout is set to 15 minutes with the exception of the Executive, Finance, and HR department
- Screen saver for Executive, Finance, and HR departments are set to 5 minutes instead

## Security Hardening GPOs
- Disabled SMBv1
- Prevented LAN Manager hash storage
- Disabled guest account
- Blocked access to Control Panel
- Denied removable media access
- Disabled anonymous SID enumeration
- Advanced security auditing enabled
- Windows Firewall enforced (inbound traffic blocked for all networks, only outbound traffic is allowed)
- Prohibited user installs
- Disabled command prompt access
- Disabled forced system restarts
