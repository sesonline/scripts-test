<#
    .SYNOPSIS 
    Sets the NIC which is active on the company domain to acquire its IP via DHCP
    .EXAMPLE
    Set-DynamicIPAddress
    Sets the active NIC to use DHCP, does not take parameters
#>


$nic = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "DNSDomain = 'sesonline.us'"
$nic.SetDNSServerSearchOrder() | out-null
$nic.SetDNSDomain() | out-null
$nic.SetDynamicDNSRegistration() | out-null
$nic.SetGateways() | out-null
$nic.EnableDHCP() | out-null