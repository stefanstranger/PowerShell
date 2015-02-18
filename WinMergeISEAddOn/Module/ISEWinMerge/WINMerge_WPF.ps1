# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\WinMergeISEAddOn\WINMerge_WPF.ps1
# Version: 0.2
# Author: Stefan Stranger
# Date: 02/14/2015 14:50:36
# Description: PowerShell script to generate WPF form for WinMerge-ISEAddOn
# Comments: Manually install WinMerge
# Changes: Changed path to WinMerge.
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
ipmo showui

# Variables
$tabs = $PSISe.PowerShellTabs.Files
$totalrows = $tabs.count + 3
$tabsrow = 1
#Configure the path the location of WinMergeU.exe application.
$exe = "C:\Program Files (x86)\WinMerge\WinMergeU.exe"

#WPF Object Styles
Set-UIStyle "L1" @{ FontFamily = "Helvetica"; FontSize = 14; FontWeight = "Bold"; ForeGround = "#6E0504" }
Set-UIStyle "C1" @{ FontFamily = "Helvetica"; FontSize = 12 }

# Grid Style
$gridparam = @{
    Name = "WinMerge"
    ControlName = "Show-ISETab"
    Background = '#FFD82F' #WinMerge color
    Rows = $totalrows
    Columns =  2
}


New-Grid @gridparam -Show -On_Loaded {
    $window.title = "WinMerge ISE add-on" } {
    New-Label "Select 2 Open ISE tabs" -Row 0 -Column 0 -VisualStyle L1

    #Add Checkboxes for open ISE tabs
    foreach ($tab in $tabs)

        {
            #Remove non ascii characters from open filenames. Checkbox objects cannot have non-ascii characters in their name.
            $name = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
            New-Checkbox -Name $name -Content $tab.displayname -DataContext $tab -BorderThickness 1 -Row $tabsrow -Margin 2 -VisualStyle C1
            $tabsrow++  
        } 

    #Ok and Cancel Buttons
    New-UniformGrid -Row $totalrows -ColumnSpan 2 -Columns 2 {
                   
            Button "Ok" -On_Click { 
                    #Retrieve checkbox variables.
                    $checkboxes = get-variable
                    $selected = ($checkboxes.Value | ? ischecked -eq "$true").count

                    #Check if only 2 tabs in WPF form are selected.
                    if ($selected -ne 2)
                        {
                            [System.Windows.Forms.MessageBox]::Show("Only 2 checkboxes allowed!","WinMerge",0,"Warning");
                            $Window | Close-Control
                        }
                        else 
                        {
                            #Check selected Checkboxes
                            if ($checkboxes.Value | ? ischecked -eq "$true")
                            {
                                $mychecks = ($checkboxes.Value | ? ischecked -eq "$true").Name
                                [array]$params = @()
                                foreach ($check in $mychecks)
                                {
                                    $FullPath = ($tabs | ? {($_.Displayname -creplace '[^a-zA-Z0-9]', '') -eq $($check)})
                                    $params += $FullPath.Fullpath
                                   
                                }
                                $param1 = [string]$params[0]
                                $param2 = [string]$params[1]
                                #Call WinMerge application
                                $exe = "C:\Program Files (x86)\WinMerge\WinMergeU.exe"
                                &$exe $param1 $param2                              
                                
                            }
                            else
                            {
                                [System.Windows.Forms.MessageBox]::Show("Shoot","MyChecks",0,"Warning");
                                $parent | Set-UIValue -passThru | Close-Control
                            }
                        }

                    } -IsDefault -Margin 5 -Row $totalrows -Column 0 #-ColumnSpan 1

            Button "Cancel" -On_Click {            
                $parent |  Set-UIValue -passThru | Close-Control          
            } -IsDefault -Margin 5 -Row $totalrows -Column 1 #-ColumnSpan 2
        }
}