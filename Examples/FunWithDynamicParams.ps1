# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\FunWithDynamicParams.ps1
# Version: 0.1.
# Author: Stefan Stranger
# Date: 04/01/2015 13:26:19
# Description: Having fun with Dynamic Parameters
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
Function Use-LessIntelliSense 
{
  [CmdletBinding()]
  Param()
  DynamicParam {
    $randomParam = (Get-Random -InputObject (65..90|ForEach-Object -Process {
          [char]$_ 
    }) -Count 1) + 
    [string]::Concat((Get-Random -InputObject (97..122|ForEach-Object -Process {
            [char]$_
    }) -Count 8))
    $attributes = New-Object -TypeName System.Management.Automation.ParameterAttribute
    $attributes.Mandatory = $true
    $attributes.HelpMessage = 'Random parameter name'
    $attributes.ParameterSetName = 'Random'
    $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
    $attributeCollection.Add($attributes)
    $random = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ($randomParam, [int], $attributeCollection)
    $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
    $paramDictionary.Add($randomParam, $random)
    return $paramDictionary
  }
  Begin {
  }
  Process {
  }
  End {
  }
}
