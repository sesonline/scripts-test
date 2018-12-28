$users= Get-ADUser -Filter * -SearchBase "ou=Employees,dc=sesonline,dc=us"
$users | %{Get-ADUser -Identity $_ | Set-ADUser -Replace @{ipPhone="cn=$($_.name),o=SES"}}