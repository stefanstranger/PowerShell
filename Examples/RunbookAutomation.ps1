#requires -Version 3 -Modules AzureRM.Automation, AzureRM.profile, AzureRM.Resources

# ---------------------------------------------------
# Script: C:\Users\stefstr\OneDrive - Microsoft\Scripts\PS\NN\RunbookAutomation.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 06/10/2016 13:01:29
# Description: Script to test Runbooks
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

#Login to Azure
Add-AzureRmAccount

#Select Azure Subscription
$subscriptionId = 
(Get-AzureRmSubscription |
    Out-GridView `
    -Title 'Select an Azure Subscription ...' `
-PassThru).SubscriptionId

Set-AzureRmContext -SubscriptionId $subscriptionId

#Select ResourceGroup 
$ResourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru


#Select AutomationAccount
$AutomationAccount = Get-AzureRmAutomationAccount -ResourceGroupName $ResourceGroup.ResourceGroupName | Out-GridView -PassThru 

#Retrieve Runbooks
$runbook = Get-AzureRmAutomationRunbook -ResourceGroupName $ResourceGroup.ResourceGroupName -AutomationAccountName $AutomationAccount.AutomationAccountName | 
Out-GridView -Title 'Select Runbook' -PassThru


#Show Runbook info
$runbook


#Enable Verbose logging
$runbook |
    Set-AzureRmAutomationRunbook -LogVerbose $true


#Start Runbook
$runbook | 
    Start-AzureRmAutomationRunbook -Wait


#Check status Runbook
$Result = (Get-AzureRMAutomationJob -ResourceGroupName $ResourceGroup.ResourceGroupName -AutomationAccountName $AutomationAccount.AutomationAccountName)[0]
$Result

#Get All Output
Get-AzureRmAutomationJob -id $Result.JobId $ResourceGroup.ResourceGroupName -AutomationAccountName $AutomationAccount.AutomationAccountName |
        Get-AzureRmAutomationJobOutput |
            Select-Object -Property Summary, Type, Time

#Disable Verbose Output
$runbook | Set-AzureRmAutomationRunbook -LogVerbose $false
