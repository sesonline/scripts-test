#Change server name and port number and $True if it is on SSL
[String]$updateServer1 = "sessrv04c.sesonline.us"
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 8530
# Load .NET assembly
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$count = 0
# Connect to WSUS Server
$updateServer = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($updateServer1,$useSecureConnection,$portNumber)
write-host "<<<Connected sucessfully >>>" -foregroundcolor "yellow"
$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
$u=$updateServer.GetUpdates($updatescope)
foreach ($u1 in $u) {
  if (($u1.IsSuperseded -eq �True�) -and ($u1.IsDeclined -ne �True�)) {
    write-host Decline Update : $u1.Title
    $u1.Decline()
    $count=$count + 1
    }
}
write-host Total Declined Updates: $count
trap {
  write-host "Error Occurred"
  write-host "Exception Message: "
  write-host $_.Exception.Message
  write-host $_.Exception.StackTrace
  exit
}