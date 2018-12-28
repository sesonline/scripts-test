$ouPath = 'OU=Departments,OU=FS_SESSRV03,OU=File Servers,DC=sesonline,DC=us'

$groups = Get-ADGroup -Filter * -SearchBase "$ouPath"
$outFile = '.\test-file.csv'

foreach ($group in $groups)
{
    $obj = New-Object -Type PSObject
    $obj | Add-Member –MemberType NoteProperty –Name Group –Value $group.Name -Force
    $obj | Add-Member –MemberType NoteProperty –Name Members –Value (Get-ADGroupMember $group | select name) -Force
    $obj | select Group -ExpandProperty members | Export-Csv $outFile -Append -NoTypeInformation
}