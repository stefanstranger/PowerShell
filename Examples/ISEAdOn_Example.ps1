# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\ISEAdOn_Example.ps1
# Version:
# Author: Stefan Stranger
# Date: 02/26/2014 10:18:13
# Description:
# Comments: Current file is currently not working. It's retrieving the value of the script that loads the add-on.
# ---------------------------------------------------

[void]$psise.
    CurrentPowerShellTab.
    AddOnsMenu.
    SubMenus.
    Add("Insert Standard Header",
{C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\scriptheader.ps1;$PSISE.CurrentFile.Editor.InsertText($header)} , "ALT+H") 
