# Replace the "szhu" and "lab" with the name and extension of your domain
# Users in the Executive Department

# CEO
New-ADUser -Name "Shengwei Zhu" `
    -GivenName "Shengwei" `
    -Surname "Zhu" `
    -SamAccountName "szhu" `
    -UserPrincipalName "szhu@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# COO
New-ADUser -Name "Edward Wagner" `
    -GivenName "Edward" `
    -Surname "Wagner" `
    -SamAccountName "ewagner" `
    -UserPrincipalName "ewagner@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# CFO
New-ADUser -Name "James Kwon" `
    -GivenName "James" `
    -Surname "Kwon" `
    -SamAccountName "jkwon" `
    -UserPrincipalName "jkwon@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# CTO
New-ADUser -Name "Alexis Johnson" `
    -GivenName "Alexis" `
    -Surname "Johnson" `
    -SamAccountName "ajohnson" `
    -UserPrincipalName "ajohnson@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# CMO
New-ADUser -Name "Lily Williams" `
    -GivenName "Lily" `
    -Surname "Williams" `
    -SamAccountName "lwilliams" `
    -UserPrincipalName "lwilliams@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# CHRO
New-ADUser -Name "Amanda Garcia" `
    -GivenName "Amanda" `
    -Surname "Garcia" `
    -SamAccountName "agarcia" `
    -UserPrincipalName "agarcia@szhu.lab" `
    -Path "OU=Executive,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# Users in HR Department
New-ADUser -Name "Lee Nguyen" `
    -GivenName "Lee" `
    -Surname "Nguyen" `
    -SamAccountName "lnguyen" `
    -UserPrincipalName "lnguyen@szhu.lab" `
    -Path "OU=HR,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "James Calvin" `
    -GivenName "James" `
    -Surname "Calvin" `
    -SamAccountName "jcalvin" `
    -UserPrincipalName "jcalvin@szhu.lab" `
    -Path "OU=HR,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Lucas Smith" `
    -GivenName "Lucas" `
    -Surname "Smith" `
    -SamAccountName "lsmith" `
    -UserPrincipalName "lsmith@szhu.lab" `
    -Path "OU=HR,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true


# Users in Finance
New-ADUser -Name "Kate Williams" `
    -GivenName "Kate" `
    -Surname "Williams" `
    -SamAccountName "kwilliams" `
    -UserPrincipalName "kwilliams@szhu.lab" `
    -Path "OU=Finance,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Roy Brown" `
    -GivenName "Roy" `
    -Surname "Brown" `
    -SamAccountName "rbrown" `
    -UserPrincipalName "rbrown@szhu.lab" `
    -Path "OU=Finance,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Christopher Lee" `
    -GivenName "Christopher" `
    -Surname "Lee" `
    -SamAccountName "clee" `
    -UserPrincipalName "clee@szhu.lab" `
    -Path "OU=Finance,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# Users in IT
New-ADUser -Name "John Davis" `
    -GivenName "John" `
    -Surname "Davis" `
    -SamAccountName "jdavis" `
    -UserPrincipalName "jdavis@szhu.lab" `
    -Path "OU=IT,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Daniel Martinez" `
    -GivenName "Daniel" `
    -Surname "Martinez" `
    -SamAccountName "dmartinez" `
    -UserPrincipalName "dmartinez@szhu.lab" `
    -Path "OU=IT,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "James Elliot" `
    -GivenName "James" `
    -Surname "Elliot" `
    -SamAccountName "jelliot" `
    -UserPrincipalName "jelliot@szhu.lab" `
    -Path "OU=IT,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# Users in Marketing
New-ADUser -Name "Jonathan Wang" `
    -GivenName "Johnathan" `
    -Surname "Wang" `
    -SamAccountName "jwang" `
    -UserPrincipalName "jwang@szhu.lab" `
    -Path "OU=Marketing,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Amy Lee" `
    -GivenName "Amy" `
    -Surname "Lee" `
    -SamAccountName "alee" `
    -UserPrincipalName "alee@szhu.lab" `
    -Path "OU=Marketing,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Tyler Jones" `
    -GivenName "Tyler" `
    -Surname "Jones" `
    -SamAccountName "tjones" `
    -UserPrincipalName "tjones@szhu.lab" `
    -Path "OU=Marketing,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# Users in Operations
New-ADUser -Name "Thomas Anderson" `
    -GivenName "Thomas" `
    -Surname "Anderson" `
    -SamAccountName "tanderson" `
    -UserPrincipalName "tanderson@szhu.lab" `
    -Path "OU=Operations,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Jake Knight" `
    -GivenName "Jake" `
    -Surname "Knight" `
    -SamAccountName "jknight" `
    -UserPrincipalName "jknight@szhu.lab" `
    -Path "OU=Operations,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Stephanie Lo" `
    -GivenName "Stephanie" `
    -Surname "Lo" `
    -SamAccountName "slo" `
    -UserPrincipalName "slo.lab" `
    -Path "OU=Operations,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Katie McCathy" `
    -GivenName "Katie" `
    -Surname "McCathy" `
    -SamAccountName "kmccathy" `
    -UserPrincipalName "kmccathy@szhu.lab" `
    -Path "OU=Operations,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

# Users in Sales
New-ADUser -Name "Devin Kim" `
    -GivenName "Devin" `
    -Surname "Kim" `
    -SamAccountName "dkim" `
    -UserPrincipalName "dkim@szhu.lab" `
    -Path "OU=Sales,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Richard Fox" `
    -GivenName "Richard" `
    -Surname "Fox" `
    -SamAccountName "rfox" `
    -UserPrincipalName "rfox@szhu.lab" `
    -Path "OU=Sales,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Jon Anderson" `
    -GivenName "Jon" `
    -Surname "Anderson" `
    -SamAccountName "janderson" `
    -UserPrincipalName "janderson@szhu.lab" `
    -Path "OU=Sales,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true

New-ADUser -Name "Sabrina Bright" `
    -GivenName "Sabrina" `
    -Surname "Bright" `
    -SamAccountName "sbright" `
    -UserPrincipalName "sbright@szhu.lab" `
    -Path "OU=Sales,DC=szhu,DC=lab" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -ChangePasswordAtLogon $true
    
