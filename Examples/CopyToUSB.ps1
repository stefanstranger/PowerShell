# ---------------------------------------------------
# Script: C:\Scripts\PS\CopyToUSB.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 09/24/2015 19:12:12
# Description: Copy file when USB is inserted
# Comments: Idea from Trevor Sullivan @pcgeek86
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

$CopystuffToUSB = {
    #Get info about inserted USB stick
    $wmiquery = 'select * from win32_logicaldisk where drivetype = 2'
    $usb = Get-WmiObject -namespace root\cimv2 -query  $wmiquery

    #Check if USB has Filesystem of fat if not do not copy files
    if ($usb.FileSystem -eq 'FAT32') {


    Write-Host -Object ('New USB Drive inserted in drive: {0}' -f $usb.deviceid)

  
    # Copy the object to the appropriate folder within the destination folder
    Copy-Item -Path 'C:\temp\USB_Part1.zip' -Destination $usb.DeviceID

  
    }
    
}

$EventQuery = 'Select * from __InstanceCreationEvent within 5 
    where TargetInstance ISA ''Win32_LogicalDisk'' and TargetInstance.DriveType = 2';


Get-EventSubscriber | Unregister-Event;
Register-WmiEvent -Query $EventQuery -Action $CopystuffToUSB -SourceIdentifier USBStick


#Register-WmiEvent -Query $EventQuery -SourceIdentifier USBStick

#Get-WmiObject -Query $EventQuery
$wmiquery = 'select * from win32_logicaldisk where drivetype = 2'
$usb = Get-WmiObject -namespace root\cimv2 -query  $wmiquery
$usb | fl *
