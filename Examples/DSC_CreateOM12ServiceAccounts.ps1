# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\DSC_CreateOM12ServiceAccounts.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 12/02/2014 11:30:30
# Description: Creates OM12 Service Accounts and adds them to the Domain Admins Groups.
# Comments: Needs a ConfigurationData file.
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------
configuration OM12DomainUsers
{
   param
    (
        [Parameter(Mandatory)]
        [pscredential]$domainCred
        
    )
    
    Import-DscResource -ModuleName xActiveDirectory

    Node $AllNodes.Where{$_.Role -eq "Primary DC"}.Nodename
    {
        foreach ($User in $Node.Users)
        {
            xADUser $User.Username
            {
                Ensure = 'Present'                UserName = $User.Username
                Password = $domainCred
                DomainName = $Node.DomainName
                DomainAdministratorCredential = $domainCred
            }
        }
        

            Script AddServiceAccounts {
              GetScript = {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    $Users = $($using:Node.Users.UserName)
                    $Group = $($using:Node.GroupName)
                    Result = foreach ($User in $Users) {
                        (Get-ADPrincipalGroupMembership -Identity $User).Name
                    }

                 }
              }

              SetScript = {
                    $Users = $($using:Node.Users.UserName)
                    $Group = $($using:Node.GroupName)
                    foreach ($User in $Users) {
                        Write-Verbose "$User is being iterated for $Group"
                        $ADUser = Get-ADUser -Identity $User -ErrorAction SilentlyContinue;
                        if ($ADUser) {
                            Add-ADGroupMember -Identity $Group -Members $ADUser;
                        }
                            $ADUser = $null;
                        }
                    }

              TestScript = {
                    $Users = $($using:Node.Users.UserName)
                    $Group = $($using:Node.GroupName)
                    foreach ($User in $Users) {
                        Write-Verbose "$User is being checked for $Group"
                        if (Get-ADPrincipalGroupMembership -Identity $User | where-object {$_.Name -eq $Group})
                            {
                                $true
                                Write-Verbose "User $user is member of Group $Group"
                            }
                            else
                            {
                                $false
                                Write-Verbose "User $user is NOT member of Group $Group"
                                return $false
                            }
                    }
                    
                }
            }#End script


        #}#End foreach
    }

}

$cred = (Get-Credential -UserName Administrator -message "Enter Password")

# Compile MOF
OM12DomainUsers -domaincred $cred -ConfigurationData c:\scripts\4_CreateOM12ServiceAccountsConfigData.psd1 -OutputPath "$Env:Temp\OM12DomainUser" 

# Make it so!
Start-DscConfiguration -Path "$Env:Temp\OM12DomainUser" -Wait -Verbose -Debug -Force -ErrorAction Continue
