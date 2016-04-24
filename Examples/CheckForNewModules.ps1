#requires -Version 3 -Modules PowerShellGet

# ---------------------------------------------------
# Script: C:\Users\stefstr\OneDrive - Microsoft\Scripts\PS\CheckForNewModules.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/22/2016 11:33:31
# Description: Check for Module Updates on PSGallery
# Comments: Idea from Øyvind Kallstad
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

Workflow Check-Module 
{
    $AllModules = Get-Module -ListAvailable
    foreach -parallel ($module in $AllModules)
    {
        $foundModule = Find-Module -Name $module.Name -ErrorAction SilentlyContinue
        if ($foundModule) 
        {
            if ($module.Version -lt $foundModule.Version) 
            {
                "Update found for $($module.name) with version $($module.Version)"
            }
        }
    }
}

Check-Module -AsJob -JobName wfmodule

#Get-Job -name wfmodule | receive-job -keep
