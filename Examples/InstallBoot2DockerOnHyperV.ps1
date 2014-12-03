# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\InstallBoot2DockerOnHyperV.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 12/03/2014 10:51:25
# Description: Powershell script to create a Boot2Docker VM on HyperV
# Comments: First download the Boot2Docker.iso file from https://github.com/boot2docker/boot2docker/releases
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

#Variables
$vmname = "Boot2Docker"
$vhdpath = "D:\VMs\$vmname\Virtual Disks\boot2docker.vhdx"
$VMPath = "D:\VMs"
$VMSwitch = "Intel(R) Centrino(R) Advanced-N 6205 Virtual Switch"
$Boot2DockerISO = "D:\ISOs\boot2docker.iso"

New-item "D:\VMs\$vmname\Virtual Disks" -Type Directory


New-VHD -Path $vhdpath –Dynamic –SizeBytes 2GB

New-VM –Name $vmname –MemoryStartupBytes 1GB -NoVHD -Generation 1

Add-VMHardDiskDrive $vmname -Path $vhdpath

Add-VMNetworkAdapter -VMName $vmname -SwitchName $VMSwitch

Set-VMDvdDrive -VMName $vmname -Path $Boot2DockerISO -ControllerNumber 1 -ControllerLocation 0

Start-VM -Name $vmname
