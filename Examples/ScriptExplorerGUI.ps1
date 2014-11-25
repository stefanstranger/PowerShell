# ---------------------------------------------------
# Script: C:\Scripts\PS\ScriptExplorerGUI.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 11/25/2014 09:43:27
# Description: GUI for PowerShell scripts
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
ISE -File (
    Get-ChildItem -Path C:\Scripts\PS\*.ps1 -Recurse  |  
    Out-GridView -OutputMode Single -Title "Select PowerShell Script to Open:" |
    Select-Object -ExpandProperty FullName
)