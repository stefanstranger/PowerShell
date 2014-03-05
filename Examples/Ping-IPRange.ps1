# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\Ping-IPRange.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 03/05/2014 15:11:26
# Description: Using PowerShell Workflows available in PowerShell v3 and above to ping a subnet range.
# Comments: having fun with PowerShell Workflows :-)
# ---------------------------------------------------

Workflow Test-PingWF{
    param([string[]]$iprange)

    foreach -parallel($ip in $iprange)
    {
        "Pinging: $ip"
        Test-Connection -ipaddres $ip -Count 2 -ErrorAction SilentlyContinue
    }
}

Test-PingWF -iprange (1..254 | % {"10.10.10."+$_})