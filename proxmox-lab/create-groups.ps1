# Replace the szhu and lab values with the name and extension of your domain
New-ADGroup -Name "IT-Staff" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=szhu,DC=lab"
New-ADGroup -Name "HR-Staff" -GroupScope Global -GroupCategory Security -Path "OU=HR,DC=szhu,DC=lab"
New-ADGroup -Name "Finance-Staff" -GroupScope Global -GroupCategory Security -Path "OU=Finance,DC=szhu,DC=lab"
New-ADGroup -Name "Marketing-Staff" -GroupScope Global -GroupCategory Security -Path "OU=Marketing,DC=szhu,DC=lab"
New-ADGroup -Name "Operations-Staff" -GroupScope Global -GroupCategory Security -Path "OU=Operations,DC=szhu,DC=lab"
New-ADGroup -Name "Sales-Staff" -GroupScope Global -GroupCategory Security -Path "OU=Sales,DC=szhu,DC=lab"
New-ADGroup -Name "Executive-Staff" -GroupScope Global -GroupCategory Security -Path "OU=Executive,DC=szhu,DC=lab"
New-ADGroup -Name "IT-Admin" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=szhu,DC=lab"
