# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\WinMergeISEAddOn\WINMerge_WPF.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/12/2015 14:50:36
# Description: PowerShell script to generate WPF form for WinMerge-ISEAddOn
# Comments: Manually install WinMerge
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
ipmo showui

$tabs = $PSISe.PowerShellTabs.Files
$totalrows = $tabs.count + 3
$tabsrow = 1 

Set-UIStyle "L1" @{ FontFamily = "Helvetica"; FontSize = 14; FontWeight = "Bold" }
Set-UIStyle "C1" @{ FontFamily = "Helvetica"; FontSize = 12 }

New-Grid -Name WinMerge -ControlName 'Show-ISETab' -Rows $totalrows -Columns 2 -Show -On_Loaded {
    $window.title = "WinMerge ISE add-on" } {
    New-Label "Select 2 Open ISE tabs" -Row 0 -Column 0 -VisualStyle L1

    #Add Checkboxes for open ISE tabs
    foreach ($tab in $tabs)

        {
            $name = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
            New-Checkbox -Name $name -Content $tab.displayname -DataContext $tab -BorderThickness 1 -Row $tabsrow -Margin 2 -VisualStyle C1
            #[System.Windows.Forms.MessageBox]::Show($name,"WinMerge",0,"Information");
            $tabsrow++  
        } 

    #Ok and Cancel Buttons
    New-UniformGrid -Row $totalrows -ColumnSpan 2 -Columns 2 {
                   
            Button "Ok" -On_Click { 
                    #Retrieve checkbox variables.
                    #$checkboxes = get-variable ($tabs.Displayname -creplace '[^a-zA-Z0-9]', '')
                    $checkboxes = get-variable
                    #[System.Windows.Forms.MessageBox]::Show($($checkboxes.name),"Selected",0,"Information"); 
                    $selected = ($checkboxes.Value | ? ischecked -eq "$true").count
                    #[System.Windows.Forms.MessageBox]::Show($($selected),"Selected",0,"Information");           
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
                                #[System.Windows.Forms.MessageBox]::Show($($mychecks),"MyChecks",0,"Information");
                                $params
                                foreach ($check in $mychecks)
                                {
                                    #[System.Windows.Forms.MessageBox]::Show($($check),"Check",0,"Information");
                                    $FullPath = ($tabs | ? {($_.Displayname -creplace '[^a-zA-Z0-9]', '') -eq $($check)})
                                    [System.Windows.Forms.MessageBox]::Show($($FullPath.fullpath),"FullPath",0,"Information");
                                    #add fullpath to params variable
                                    $params += "'"+$FullPath.Fullpath+"'" + " "
                                   
                                }
                                 #[System.Windows.Forms.MessageBox]::Show($($params),"Params",0,"Information");
                                 Invoke-Expression "C:\Temp\WinMergePortable\WinMergePortable.exe $params"
                                
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

