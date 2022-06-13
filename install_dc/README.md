# Installing the Domain Controller


1. Use `SConfig` to:
    - Change the Hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

2. Install the Active Directory Windows Feature

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

3. List/Add Windows trusted hosts
```shell
Get-Item wsman:\localhost\Client\TrustedHosts
Set-Item wsman:\localhost\Client\TrustedHosts -Value <ip-address/host>
```