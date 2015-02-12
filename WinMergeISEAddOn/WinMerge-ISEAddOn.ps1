# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\WinMergeISEAddOn\WinMerge-ISEAddOn.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/12/2015 14:51:50
# Description: WINMerge ISE AddOn
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

[void]$psise.
    CurrentPowerShellTab.
    AddOnsMenu.
    SubMenus.
    Add("Open WINMERGE",
{C:\Users\stefstr\Documents\GitHub\PowerShell\WinMergeISEAddOn\WINMerge_WPF.ps1} , "ALT+W")