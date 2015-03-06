# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\ISESteroids_Context-Menu_BackTicks.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 03/06/2015 10:04:40
# Description: Testing new SteroidsContext Menu cmdlet for Preview Version 2.0.15.4
# Comments: 
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
Add-SteroidsContextMenuCommand -DisplayName 'Check for backticks' -ToolTip 'Check for backticks' -TokenType String -ScriptBlock {
  $content = $psISE.CurrentFile.Editor.Text
  $count = ([regex]::matches($content, '`')).count
  [System.Windows.Forms.MessageBox]::Show("$count backticks found","ISESteroids",0,"Information");
  
}