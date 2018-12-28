[array]$logonHours = (Get-ADUser HoursTemplate -Properties logonHours).logonHours
$users= Get-ADUser -Filter * -SearchBase "ou=Employees,dc=sesonline,dc=us"
$users | %{Get-ADUser -Identity $_ | Set-ADUser -Replace @{logonhours=$logonHours}}