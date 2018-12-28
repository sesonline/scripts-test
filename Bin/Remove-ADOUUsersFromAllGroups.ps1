$users= get-aduser -Filter * -SearchBase "ou=Terminated,dc=sesonline,dc=us"

Function RemoveMemberships

 {

 param([string]$SAMAccountName)  
 
 $user = Get-ADUser $SAMAccountName -properties memberof
 
 $userGroups = $user.memberof

 $userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}

 $userGroups = $null

 }


$users | %{RemoveMemberships $_.SAMAccountName}