$users= Get-ADUser -Filter * -SearchBase "ou=Branch Offices,ou=Employees,dc=sesonline,dc=us"
$users | %{Add-ADGroupMember "Branch Offices_Public_ReadOnly" -Member $_}