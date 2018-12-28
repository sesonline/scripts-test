$users= Get-ADUser -Filter * -SearchBase "ou=Branches,ou=Employees,dc=sesonline,dc=us"
$users | %{Get-ADUser -Identity $_ | Set-ADUser -Clear userWorkstations}