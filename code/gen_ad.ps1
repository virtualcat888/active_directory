# Mandatory parameter to reference a JSON file
param( [Parameter(Mandatory=$true)] $JSONFile) 

# Function to create AD group object
function CreateADGroup() {
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    # PS cmlet to create AD group with global scope
    New-ADGroup -name $name -GroupScope Global
}

# Function to create AD user
function CreateADUser() {
    param( [Parameter(Mandatory=$true)] $userObject )

    # pulls name, password from JSON object
    $name = $userObject.name
    $password = $userObject.password
    # Splits name object to firstname, last name
    $firstname, $lastname = $name.split(" ")

    #Generate a "first initial, last name" structure for username
    $username = ($firstname[0] + $lastname).ToLower()
    $SamAccountName = $username
    $principalname = $username

    #PS cmdlet to Create the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount
    
    #Add user to its appropriate group
    foreach($group_name in $userObject.groups) {

        try {
            # Check to see if the $group_name object exists
            Get-ADGroup -Identity "$group_name"
            # Add user to the group
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            # throws warning if $group_name object not found
            Write-Warning "User $name NOT added to group, $group_name it does not exist"
        }
    }
}


$json = ( Get-Content $JSONFile | ConvertFrom-JSON )

$Global:Domain = $json.domain 

# Loop thru the groups in the referenced JSON file and create the AD groups using function created
foreach ( $group in $json.groups ){
    CreateADGroup $group
}

# Loop thru the users in the referenced JSON file and create the AD groups using function created
foreach ( $user in $json.users ){
    CreateADUser $user
}

