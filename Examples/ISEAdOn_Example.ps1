$header = @"
# ---------------------------------------------------
# Script: $($psise.CurrentFile.FullPath)
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


