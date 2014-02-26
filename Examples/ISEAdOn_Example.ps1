# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\ISEAdOn_Example.ps1
# Version:
# Author: Stefan Stranger
# Date: 02/26/2014 10:18:13
# Description:
# Comments: Current file is currently not working. It's retrieving the value of the script that loads the add-on.
# ---------------------------------------------------

$header = @"
# ---------------------------------------------------
# Script: $($psise.currentfile.fullpath)
# Version:
# Author: Stefan Stranger
# Date: $(get-date)
# Description:
# Comments:
# ---------------------------------------------------
"@

[void]$psise.
    CurrentPowerShellTab.
    AddOnsMenu.
    SubMenus.
    Add("Insert Standard Header",
{$PSISE.CurrentFile.Editor.InsertText($header)} , "ALT+H") 
