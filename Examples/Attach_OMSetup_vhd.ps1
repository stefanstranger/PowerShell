# ---------------------------------------------------
# Script: C:\Scripts\PS\Azure\Attach_OMSetup_vhd.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/05/2015 15:26:30
# Description: Create a local vhd, insert an iso file and upload to azure storage container and attach vhd to VM
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

#Variables:
$vhdpath = "d:\vhds\OMSetup.vhd"
$destinationVHD = "https://mystorage.blob.core.windows.net/opsmgr/opsmgrsetup.vhd"
$size = 1GB
$isopath = "D:\ISOs\en_system_center_2012_r2_operations_manager_x86_and_x64_dvd_2920299.iso"

#Create VHD
#Mount VHD
#Intialize Disk
#Create partition
#Format Volume
New-VHD -path $vhdpath -SizeBytes $size -Dynamic
Mount-VHD -Path $vhdpath 
Get-Disk -FriendlyName "Microsoft Virtual Disk" |
Initialize-Disk -PartitionStyle MBR -PassThru | 
New-Partition -UseMaximumSize -AssignDriveLetter:$False -MbrType IFS | 
Format-Volume -Confirm:$false -FileSystem NTFS -force | 
get-partition | Add-PartitionAccessPath -AssignDriveLetter -PassThru

#Copy OMSetup.iso to mounted disk
$Driveletter = (Get-Disk -FriendlyName "Microsoft Virtual Disk" | get-partition)
$Destination = $Driveletter.DriveLetter+":"
copy-item -path $isopath -Destination $Destination

#Dismount vhd
Dismount-VHD $VHDPath


#load Azure module
Import-Module Azure

#Authenticate through Windows Azure Active Directory and downloads associated subscriptions
Add-AzureAccount

#Upload vhd 
Add-AzureVhd -LocalFilePath $vhdpath -Destination $destinationVHD -NumberOfUploaderThreads 5


# Adds a new disk to the Microsoft Azure disk repository.
Add-AzureDisk -DiskName "OMSetup" -MediaLocation $destinationVHD -Label "OMSetup"

#Attach disk to VM
Get-AzureVM -service "service" -Name "vm" | Add-AzureDataDisk -Import -DiskName "OMsetup" -LUN 0 | Update-AzureVM

