param ([string]$groupA, [string]$groupB)
Get-ADGroupMember -Identity $groupA | Format-Table Name
Get-ADGroupMember -Identity $groupB | Format-Table Name
Get-ADGroupMember -Identity $groupB | Get-ADUser | ForEach-Object {Remove-ADGroupMember -Identity $groupA -Members $_ -Confirm:$False}
Get-ADGroupMember -Identity $groupA | Format-Table Name
Get-ADGroupMember -Identity $groupB | Format-Table Name