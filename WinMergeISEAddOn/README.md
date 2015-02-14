# Powershell WinMerge ISE Add-On 
- - -
This ISE Add-On adds integration with the WINMerge application into the ISE.

For more information about WinMerge go to: http://winmerge.org/

02/12/2015: - Initial version

02/14/2015: - Changed location default install WinMerge. Some visual improvements

![ScreenShot](https://raw.githubusercontent.com/stefanstranger/PowerShell/master/WinMergeISEAddOn/WinMergeWPF_opt.gif)

# Install
First install WinMerge using PowerShell OneGet or manually from http://winmerge.org

Change the following part of the WINMerge_WPF.ps1 file
# Variables
..
#Configure the path the location of WinMergeU.exe application.
$exe = "C:\Program Files (x86)\WinMerge\WinMergeU.exe"
..

Run .\WinMerge-ISEAddOn.ps1
