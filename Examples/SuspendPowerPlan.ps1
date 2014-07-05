﻿# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\SuspendPowerPlan.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 07/05/2014 15:01:57
# Description: Helper Function to Suspend Power Plan when running PowerShell scripts
# Comments:
# Disclamer: This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# ---------------------------------------------------


<#
.Synopsis
   Function to suspend your currrent Power Plan settings when running a PowerShell script.
.DESCRIPTION
   Function to suspend your currrent Power Plan settings when running a PowerShell script.
   Scenario: When downloading files using Robocopy from PowerShell you don't want your
   laptop to go into sleep mode.
.EXAMPLE
   Suspend-PowerPlan -script c:\scripts\mylongrunningscript.ps1
   Run mylongrunningscript with sleep idle timeout prevented
.EXAMPLE
   Suspend-Powerplan -script c:\scripts\mylongrunningscript.ps1 -option Display -Verbose
   Run mylongrunningscript with Display idle timeout prevented and verbose messages
.LINK
  http://www.microsofttranslator.com/bv.aspx?from=ru&to=en&a=http%3A%2F%2Fsocial.technet.microsoft.com%2FForums%2Fen-US%2F1f4754cb-37bf-4e1d-a59f-ec0f1aaf9d1c%2Fsetthreadexecutionstate-powershell%3FThread%3A1f4754cb-37bf-4e1d-a59f-ec0f1aaf9d1c%3DMicrosoft.Forums.Data.Models.Discussion%26ThreadViewModel%3A1f4754cb-37bf-4e1d-a59f-ec0f1aaf9d1c%3DMicrosoft.Forums.CachedViewModels.ThreadPageViewModel%26forum%3Dscrlangru
#>
function Suspend-Powerplan
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        $script,
        [ValidateSet("Away","Display","System")]
        [string]$option
         
    )

    $code=@' 
[DllImport("kernel32.dll", CharSet = CharSet.Auto,SetLastError = true)]
  public static extern void SetThreadExecutionState(uint esFlags);
'@

    $ste = Add-Type -memberDefinition $code -name System -namespace Win32 -passThru 
    $ES_CONTINUOUS = [uint32]"0x80000000" #Requests that the other EXECUTION_STATE flags set remain in effect until SetThreadExecutionState is called again with the ES_CONTINUOUS flag set and one of the other EXECUTION_STATE flags cleared.
    $ES_AWAYMODE_REQUIRED = [uint32]"0x00000040" #Requests Away Mode to be enabled.
    $ES_DISPLAY_REQUIRED = [uint32]"0x00000002" #Requests display availability (display idle timeout is prevented).
    $ES_SYSTEM_REQUIRED = [uint32]"0x00000001" #Requests system availability (sleep idle timeout is prevented).

    Switch ($option)
    {
      "Away" {$setting = $ES_AWAYMODE_REQUIRED}
      "Display" {$setting = $ES_DISPLAY_REQUIRED}
      "System" {$setting = $ES_SYSTEM_REQUIRED}
      Default {$setting = $ES_SYSTEM_REQUIRED}

    }

    Write-Verbose "Power Plan suspended with option: $option"

    $ste::SetThreadExecutionState($ES_CONTINUOUS -bor $setting)


    #do something
    Write-Verbose "Executing $script"

    &$script

    Write-Verbose "Power Plan suspension ended"
    $ste::SetThreadExecutionState($ES_CONTINUOUS)


}

