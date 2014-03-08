#Requires -RunAsAdministrator
# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\DSC\Resources\cBgInfo\cBgInfoExample.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 03/08/2014 16:30:17
# Description: Installs SysInternals tool BgInfo and created a shortcut in Startup menu
# Comments: You first need to download the BgInfo.zip file from: http://technet.microsoft.com/en-us/sysinternals/bb897557.aspx
#           Secondly you need to create a BgInfo Configuration File (default.bgi) and a shortcut file to BgInfo with the following configuration.
#           Target: "C:\Program Files\BgInfo\Bginfo.exe" default.bgi /timer:0 /NOLICPROMPT
#           This DSC Script executes 3 steps.
#           1. Unzips the BgInfo.zip to "C:\Program Files\BgInfo" folder.
#           2. Copies pre-created BgInfo info config file (default.bgi) to C:\Program Files\BgInfo folder
#           3. Copies pre-configured BgInfo Shortcut file to "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" folder
# Disclamer: Note that this is provided “AS-IS” with no warranties at all. This is not a production ready solution, just an idea and an example.
# ---------------------------------------------------

Configuration BgInfoZipConfig
{
    param ([Parameter(Mandatory=$true)]
           [string]$SourcePath,
           [Parameter(Mandatory)]
           [string]$DestinationPath,
           [string]$computername="localhost")
    

    Node ($computername)
        {

            Archive cBgInfoZip {
            Ensure = "Present"
            Path = "$SourcePath\BgInfo.zip"
            Destination = "$DestinationPath"
            Force = $True
        }

        }
 }

$SourcePath = "C:\Users\stefstr\Documents\GitHub\PowerShell\DSC\Scripts\cBgInfo\SourceFiles"
$DestinationPath = "C:\Program Files\BgInfo"


BgInfoZipConfig -SourcePath $SourcePath -DestinationPath $DestinationPath -computername $($env:computername) -OutputPath "$Env:Temp\BgInfoConfig"
Start-DscConfiguration -Path "$Env:Temp\BgInfoConfig" -Wait -Force -Verbose -ErrorAction Continue


#Copy default.bgi file

Configuration BgInfoFileCopyConfig
{
    param(
            [parameter(Mandatory)]
            [string]$SourceFilePath,
            [parameter(Mandatory=$true)]
            [string]$DestinationPath,
            [string]$ComputerName
         )

    Node ($ComputerName) 
    {
        File DirectoryCopy 
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Type = "File" # Default is "File".
            Recurse = $false # Ensure presence of subdirectories, too
            SourcePath = "$SourceFilePath\default.bgi"
            DestinationPath = $DestinationPath 
        }

        Log AfterFileCopy 
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }
    }
}

$SourceFilePath = "C:\Users\stefstr\Documents\GitHub\PowerShell\DSC\Scripts\cBgInfo\SourceFiles"
$DestinationPath = "C:\Program Files\BgInfo"

BgInfoFileCopyConfig -SourceFilePath $SourceFilePath -DestinationPath $DestinationPath -computername $($env:computername) -OutputPath "$Env:Temp\BgInfoFileCopyConfig"
Start-DscConfiguration -Path "$Env:Temp\BgInfoFileCopyConfig" -Wait -Force -Verbose -ErrorAction Continue

#Copy shortcut to C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

Configuration BgInfoShortCutCopyConfig
{
    param(
            [parameter(Mandatory)]
            [string]$SourceFilePath,
            [parameter(Mandatory=$true)]
            [string]$DestinationPath,
            [string]$ComputerName
         )

    Node ($ComputerName) 
    {
        File DirectoryCopy 
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Type = "File" # Default is "File".
            Recurse = $false # Ensure presence of subdirectories, too
            SourcePath = "$SourceFilePath\Bginfo.exe.lnk"
            DestinationPath = $DestinationPath 
        }

        Log AfterFileCopy 
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }
    }
}

$SourceFilePath = "C:\Users\stefstr\Documents\GitHub\PowerShell\DSC\Scripts\cBgInfo\SourceFiles"
$DestinationPath = "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

BgInfoShortCutCopyConfig -SourceFilePath $SourceFilePath -DestinationPath $DestinationPath -computername $($env:computername) -OutputPath "$Env:Temp\BgInfoShortCutCopyConfig"
Start-DscConfiguration -Path "$Env:Temp\BgInfoShortCutCopyConfig" -Wait -Force -Verbose -ErrorAction Continue