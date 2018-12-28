[String]$updateServer1 = "sessrv04c.sesonline.us"
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 8530
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")` | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($updateServer1,$useSecureConnection,$portNumber);
$cleanupScope = new-object Microsoft.UpdateServices.Administration.CleanupScope;
$cleanupScope.DeclineSupersededUpdates = $false
$cleanupScope.DeclineExpiredUpdates = $false
$cleanupScope.CleanupObsoleteUpdates = $true
$cleanupScope.CompressUpdates = $true
$cleanupScope.CleanupObsoleteComputers = $false
$cleanupScope.CleanupUnneededContentFiles = $false
$cleanupManager = $wsus.GetCleanupManager();
$cleanupManager.PerformCleanup($cleanupScope);