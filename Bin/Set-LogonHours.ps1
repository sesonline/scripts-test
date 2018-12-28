# SetLogonHours.ps1
# PowerShell program to configure when users are allowed to logon
# to the domain in Active Directory.
# Author: Richard Mueller
# PowerShell Version 1.0
# August 10, 2011
# September 18, 2012 - Modify rounding of local time zone bias.
# April 29, 2013 - Account for negative time zone bias.

Trap{"Error assigning logonHours to $DN - $_"; Continue;}

# Create an array of 21 bytes, each of 8 bits, representing the 168 hours
# in a week.
$LH = New-Object 'Byte[]' 21

# Retrieve local Time Zone bias from machine registry in hours.
# This bias does not change with Daylight Savings Time.
$Bias = (Get-ItemProperty `
    -Path HKLM:\System\CurrentControlSet\Control\TimeZoneInformation).Bias
# Account for negative bias.
If ($Bias -gt 10080){$Bias = $Bias - 4294967296}
$Bias = [Math]::Round($Bias/60, 0, [MidpointRounding]::AwayFromZero)

# Read user DN's and binary string reprentations of the hours each user is
# allowed to logon to the domain. There should be one DN and 7 strings of
# 24 bits each, representing the 7 days (168 hours) in a week, on each line.
# A "0" means the user is not allowed to logon during the our, a "1" means
# the user can logon during the hour. The input hours are in local time.
Import-CSV LogonHours.csv | ForEach {
    $DN =  $_.DN
    $Sun = $_.Sun
    $Mon = $_.Mon
    $Tue = $_.Tue
    $Wed = $_.Wed
    $Thu = $_.Thu
    $Fri = $_.Fri
    $Sat = $_.Sat

    # Bind to the user object in AD.
    $User = [ADSI]"LDAP://$DN"
    If ($User.sAMAccountName -eq $Null) {"User not found: $DN"}
    Else
    {
        # Append binary strings, one for each day of the week, into one string.
        $Hours = "$Sun$Mon$Tue$Wed$Thu$Fri$Sat"
        # Remove any delimiters separating the hours.
        $Hours = $Hours.Replace(" ", "")
        $Hours = $Hours.Replace("-", "")
        $Hours = $Hours.Replace("/", "")
        $Hours = $Hours.Replace("\", "")
        $Hours = $Hours.Replace(",", "")
        $Hours = $Hours.Replace("+", "")

        # Adjust for time zone bias, to convert from local time to UTC.
        $Len = $Hours.Length
        If (($Len -ne 168) -or ($Hours -match"[^0-1]")) {"Invalid hours for $DN"}
        Else
        {
            If ($Bias -gt 0)
            {
                $Str1 = $Hours.SubString(0, $Len - $Bias)
                $Str2 = $Hours.SubString($Len - $Bias)
            }
            If ($Bias -lt 0)
            {
                $Str1 = $Hours.SubString(0, -$Bias)
                $Str2 = $Hours.SubString(-$Bias)
            }
            $Hours = "$Str2$Str1"

            # Populate binary array.
            For ($k = 0; $k -le 20; $k = $k + 1)
            {
                # Convert each 8 hours into one byte.
                $Value = $Hours.SubString(8*$k, 8)
                $Hrs = ""
                # Reverse the hours.
                For ($j = 0; $j -le 7; $j = $j + 1)
                {
                    $Hrs = $Value.SubString($j, 1) + $Hrs
                }
                $Byte = [Convert]::ToByte($Hrs, 2)
                $LH[$k] = $Byte
            }
            # Assign the resulting byte array to the logonHours
            # attribute of the user.
            $User.logonHours.Value = $LH
            $User.SetInfo()
        }
    }
}