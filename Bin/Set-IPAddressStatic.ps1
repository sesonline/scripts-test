<#
    .SYNOPSIS
    Sets the NIC which is active on the company domain to a static IP address
    .EXAMPLE
    Set-StaticIPAddress 192.168.1.100 255.255.255.0 192.162.1.1 8.8.8.8 8.8.4.4
    Sets the active NIC to the given static IP address, subnet mask, gateway, DNS 1, and DNS 2
#>


param (
[string]$strIPAddress, 
[string]$strSubnet, 
[string]$strGateway, 
[string]$strDNSServer1, 
[string]$strDNSServer2)
    $nic = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "DNSDomain = 'sesonline.us'"
    $nic.SetDNSServerSearchOrder(@($strDNSServer1, $strDNSServer2)) | out-null
    $nic.SetDNSDomain("sesonline.us") | out-null
    $nic.EnableStatic($strIPAddress, $strSubnet) | out-null
    $nic.SetGateways($strGateway, 1) | out-null