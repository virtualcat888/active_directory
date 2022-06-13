# Installing the Domain Controller

References: https://xpertstec.com/how-to-install-active-directory-windows-server-core-2022/


1. Use `SConfig` to:
    - Change the Hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

2. Install the Active Directory Windows Feature

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

3. Import ADDS module and Install first domain controller in new forest
```shell
Import-Module ADDSDeployment
Install-ADDSForest
```