param( [Parameter(Mandatory=$true)] $OutputJSONFILE )

# Create Array variables that reads data from txt file 
$group_names = [System.Collections.ArrayList](Get-Content "data/group_names.txt")
$first_names = [System.Collections.ArrayList](Get-Content "data/first_names.txt")
$last_names = [System.Collections.ArrayList](Get-Content "data/last_names.txt")
$passwords = [System.Collections.ArrayList](Get-Content "data/rockyou-top15k.txt")

# Create empty Array to store data
$groups = @()
$users = @()

$num_groups = 3

for ($i = 0; $i -lt $num_groups; $i++) {
    # randomly pulls data from $group_names variable
    $data = (Get-Random -InputObject $group_names)
    # Converts $data to hashtable with key = "name" and value = "$data"
    $hash_data = @{ "name" = "$data" }
    # Adds $hash_data to $groups Array 
    $groups += $hash_data
    # Removes $data from $group_names pool to prevent duplicates 
    $group_names.Remove($data)
}

$num_users = 3

for ($i = 0; $i -lt $num_users; $i++) {
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $new_user = @{
        "name" = "$first_name $last_name"
        "password" = "$password"
        "groups" = @( (Get-Random -InputObject $groups).name )
        }
    $users += $new_user
    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

# Write data to JSON format and save to $OutputJSONFILE
echo @{
       "domain" = "VirtualKnights.local"
       "groups" = $groups
       "users" = $users
} | ConvertTo-Json | Out-File $OutputJSONFILE