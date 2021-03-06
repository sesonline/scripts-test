Get-ADGroupMember -Identity “Administration_Public_ReadOnly” | Format-Table Name
Get-ADGroupMember -Identity “Branch_Employees” | Format-Table Name
Get-ADGroupMember -Identity “Branch_Employees” | Get-ADUser | ForEach-Object {Remove-ADGroupMember -Identity “Administration_Public_ReadOnly” -Members $_ -Confirm:$False}
Get-ADGroupMember -Identity “Administration_Public_ReadOnly” | Format-Table Name
Get-ADGroupMember -Identity “Branch_Employees” | Format-Table Name