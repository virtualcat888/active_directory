# Installing the Domain Controller

References: https://xpertstec.com/how-to-install-active-directory-windows-server-core-2022/


Use `SConfig` to:
    - Change the Hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

1.Install the Active Directory Windows Feature
```
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

2.Get IP address and change DNS server IP
```
Get-NetIPAddress
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses <ip-address>
```

3.Get and set trusted hosts
```
get-item WSMan:\localhost\Client\TrustedHosts
set-item WSMan:\localhost\Client\TrustedHosts -value <ip-address>
```

4.Get adapter status, disable IPv6 on the adapter
```
Get-NetAdapter
Disable-Netadapterbinding -InterfaceAlias "<name>" -ComponentID ms_tcpip6
```

5.Import ADDS module and Install first domain controller in new forest
```
Import-Module ADDSDeployment
Install-ADDSForest
```