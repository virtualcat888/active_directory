param( [Parameter(Mandatory=$true)] $JSONFile) 

function CreateADGroup() {
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}
function CreateADUser() {
    param( [Parameter(Mandatory=$true)] $userObject )

    # pull name from JSON object
    $name = $userObject.name
    $password = $userObject.password
    $firstname, $lastname = $name.split(" ")

    #Generate a "first initial, last name" structure for username
    $username = ($firstname[0] + $lastname).ToLower()
    $SamAccountName = $username
    $principalname = $username

    #Create the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount
    
    #Add user to its appropriate group
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $name NOT added to group $group_name because it does not exist"
        }
    }
}


$json = ( Get-Content $JSONFile | ConvertFrom-JSON )

$Global:Domain = $json.domain 

foreach ( $group in $json.groups ){
    CreateADGroup $group
}

foreach ( $user in $json.users ){
    CreateADUser $user
}
