# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\WinMerge.ps1
# Version: 0.2
# Author: Stefan Stranger
# Date: 02/09/2015 14:50:03
# Description: WinMerge ISE AddOn. Opens first 2 open tabs in ISE
# Comments: Download WinMergePortable from: http://sourceforge.net/projects/portableapps/files/WinMerge%20Portable/WinMergePortable_2.14.0.paf.exe
#           Install WinMergePortable and change below path to your WinMergePortable.exe folder. 
# Changes:
# TODO: Currently the first 2 ISE tabs are automatically used in WinMerge. Future edition should have some more advanced options.[fixed] 
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
{C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\CreateWinForm_0.1.ps1} , "ALT+W")