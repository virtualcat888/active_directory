# Useful PS commands

-Make PS session a Variable and copy items to remote PS session
```
$dc = New-PSSession -ComputerName <ip-address> -Credential (Get-Credential)

Copy-Item <file directory path> -ToSession $dc <remote directory path>

Enter-PSSession $dc
```

-AD Commands
```
Get-ADUser -Filter *

Get-ADGroup
```

-Get Variable type
```
$<variable>.GetType()
```

-Create 