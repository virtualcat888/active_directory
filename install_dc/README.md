# Installing the Domain Controller

References: https://xpertstec.com/how-to-install-active-directory-windows-server-core-2022/


Use `SConfig` to:
    - Change the Hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address


-Install the Active Directory Windows Feature
```
Get-WindowsFeature | ? {$_.Name -LIKE "AD*"}

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

-Get IP address and change DNS server IP
```
Get-NetIPAddress

Set-DnsClientServerAddress -InterfaceIndex <index #> -ServerAddresses <ip-address>
```

-Get and set trusted hosts
```
Get-Item WSMan:\localhost\Client\TrustedHosts

set-item WSMan:\localhost\Client\TrustedHosts -value <ip-address>
```

-Enable and enter remote PS session
```
# Verify you have set remote host as trusted hosts
New-PSSession -ComputerName <ip-address> -Credential (Get-Credential)

Get-PSSession

Enter-PSSession <id>
```

-Get adapter status, disable IPv6 on the adapter
```
Get-NetAdapter

Disable-Netadapterbinding -InterfaceAlias "<name>" -ComponentID ms_tcpip6
```

-Import ADDS module and Install first domain controller in new forest
```
Import-Module ADDSDeployment

Install-ADDSForest
```