# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\CompareGetHelp.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 03/02/2015 15:45:03
# Description: Compare different Get-Help parameters.
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
get-help dir | out-string -OutVariable helptext | out-null
get-help dir -full | out-string -OutVariable helptextfull | out-null

compare-object (([regex]::matches($helptext, "\b[A-Z]+") | 
    %{if ($_.value.length -gt 3){$_.value}}) | 
        select -Unique) (([regex]::matches($helptextfull, "\b[A-Z]+") | 
            %{if ($_.value.length -gt 3){$_.value}}) | 
                select -Unique) -IncludeEqual

