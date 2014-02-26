#requires -version 4
#requires -runasadministrator

# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\ExportBitlocker.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/26/2014 14:18:50
# Description: Function to export Bitlocker Keys for storing in files.
# Comments:
# ---------------------------------------------------

<#
.Synopsis
   Backup Bitlocker key and store on OneDrive
.DESCRIPTION
   Script to backup bitlocker and store the bitlocker key on OneDrive
.EXAMPLE
   Backup-BitlockerToOneDrive -DriveLetter C:
   Shows Bitlocker key for DriveLetter C: in PowerShell host.
.EXAMPLE
   Backup-BitlockerToOneDrive -DriveLetter c: | export-csv -path c:\temp\bitlocker.csv -notypeinformation
   Exports Bitlocker key for Driveletter C: to bitlocker.csv file on c:\temp folder without any typeinformation
.EXAMPLE
   "c:","d:" | Backup-BitlockerToOneDrive | export-csv -path c:\temp\bitlocker.csv -notypeinformation -Append
   Exports and appends the Bitlocker keys for Driveletter C: and D: using the pipeline to bitlocker.csv file on c:\temp folder without any typeinformation with verbose info 
.EXAMPLE
    #Function need to run elevated. Let's create an option
    $option = New-ScheduledJobOption -RunElevated 

    #Register BackupBitlocker Job
    Register-ScheduledJob -name BackupBitlocker -ScriptBlock {
        . C:\Scripts\PS\Bitlocker\ExportBitlocker.ps1
        Backup-BitlockerToOneDrive -DriveLetter C: | export-csv -path C:\users\stefstr\SkyDrive\Bitlocker\backupbitlocker.csv -Append
    } -ScheduledJobOption $option

    #Create Trigger
    $4amtrigger = New-JobTrigger -At  4pm -Daily

    #Associate a Job Trigger
    Add-JobTrigger -Name BackupBitlocker -Trigger $4amtrigger
#>
function Backup-BitlockerToOneDrive
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string]
        $DriveLetter
    )

    Begin
    {
        Write-Verbose "Starting Backup-BitLockerToOneDrive Function"

    }
    Process
    {
        Write-Verbose "Bitlocker PowerShell object is being created"
        $bitlockerobject = new-object -type psobject -Property @{Driveletter="";RecoveryPassWord="";BackupDate="";Computername=""}
        $bitlockerobject.ComputerName = $($env:COMPUTERNAME)
        $bitlockerobject.BackupDate = $(Get-Date)    
        $bitlockerobject.Driveletter = $DriveLetter
        $bitlockerobject.RecoveryPassWord = [string]$((Get-BitLockerVolume -MountPoint $driveletter).KeyProtector.recoverypassword)
        $bitlockerobject
    }
    End
    {
        Write-Verbose "Finished Backup-BitLockerToOneDrive Function"
    }
}
