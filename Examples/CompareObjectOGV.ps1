# ---------------------------------------------------
# Script: C:\Users\Stefan\Documents\GitHub\PowerShell\Examples\CompareObjectOGV.ps1
# Tags: compare, PowerShell, GUI
# Version: 0.1
# Author: Stefan Stranger
# Date: 08/26/2016 15:19:03
# Description: Compare objects example
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

get-random -InputObject @(1..10) -Count 5 -OutVariable ref

get-random -InputObject @(1..10) -Count 5 -OutVariable dif

compare-object -ReferenceObject $ref -DifferenceObject $dif -IncludeEqual
  

compare-object -ReferenceObject $ref -DifferenceObject $dif -IncludeEqual |
    select @{l='ReferecencObject';e={if ($_.SideIndicator -eq '==' -or $_.SideIndicator -eq '<=' ) {$($_.InputObject)}}},
           @{l='DifferenceObject';e={if ($_.SideIndicator -eq '==' -or $_.SideIndicator -eq '=>' ) {$($_.InputObject)}}} | ogv -PassThru