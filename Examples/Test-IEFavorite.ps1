# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\Test-IEFavorite.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 05/18/2015 10:01:28
# Description: Testing IE favorites with Test-Uri cmdlet
# Comments: Retrieving IE favorite code from http://madprops.org/blog/List-Your-Favorites-in-PowerShell/
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

gci $env:userprofile\favorites -rec -inc *.url |
    ? {select-string -inp $_ -quiet "^URL=http"} | 
    select @{Name="Name"; Expression={[IO.Path]::GetFileNameWithoutExtension($_.FullName)}},
        @{Name="URL"; Expression={get-content $_ | ? {$_ -match "^URL=http"} | % {$_.Substring(4)}}} | 
        % {test-uri -Uri $_.URL}