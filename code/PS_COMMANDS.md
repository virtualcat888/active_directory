# Useful PS commands

-Make PS session a Variable and copy items to remote PS session
```
$dc = New-PSSession <ip-address> -Credential (Get-Credential)
Copy-Item <file directory path> -ToSession $dc <remote directory path>
```