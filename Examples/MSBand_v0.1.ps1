# ---------------------------------------------------
# Script: C:\Scripts\PS\MSBand\MSBand_v0.1ps1.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 12/22/2014 19:12:12
# Description: Connect to your Microsoft Band using PowerShell
# Comments: Download the Microsoft Band Sync app for Windows Software from http://www.microsoft.com/en-us/download/details.aspx?id=44579
#           Idea from https://twitter.com/JustinAngel/status/529876592479047682/photo/1 via @justinangel
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

<#Steps:
    1. Connect to you MS Band using the Microsoft Band Sync app for Windows Software.
    2. Quit Band Sync app for Windows Software
    3. Run PowerShell commands
#>

#Load Microsoft Band Sync app for Windows Software assembly
add-type -Path "C:\Program Files (x86)\Microsoft Band Sync\Microsoft.Cargo.Client.Desktop8.dll"


#Get Connected Deviced
$MSBands = [Microsoft.Cargo.Client.CargoClient]::GetConnectedDevicesAsync()

#Initalize Cargo Client for MSBand
$MSBandClient = [Microsoft.Cargo.Client.CargoClient]::CreateAsync($MSBands.Result[0])
$MSBandClient.Result

#Get Members
$MSBandClient.Result | Get-Member

#Get Firmware Versions
$MSBandClient.Result.FirmwareVersions

#GetDeviceTheme
$MSBandClient.Result.GetDeviceTheme()

#Get TimeZone
$MSBandClient.Result.GetDeviceTimeZone()

#Get Last Run Statistics
$MSBandClient.Result.GetLastRunStatistics()

#Send Email Notification
$MSBandClient.Result.SendEmailNotification("Testing","Sending a message from PowerShell",(Get-Date))



