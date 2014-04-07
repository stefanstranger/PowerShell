# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\Find-Package-Project-Website.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 04/07/2014 21:45:57
# Description: Helper Function to find Package Project Website for OneGet Find-Package Cmdlet
# Comments:
# Disclamer: This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# ---------------------------------------------------

#Help function to open internet explorer
Function Start-IE
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $url)

    Process
    {
        start $url
    }

}



Function Find-PackageSite
{
<#
.Synopsis
   Find OneGet Package Site
.DESCRIPTION
   Function to find the url for the Package Site from the OneGet Find-Package Cmdlet
.EXAMPLE
   Find-PackageSite -Name Console2 -Source Chocolatey
   This command gets the Project website url for the Console2 package from Chocolatey resource
   PS C:\Scripts\PS> Find-PackageSite -Name Console2 -Source Chocolatey
   http://sourceforge.net/projects/console/ 
.EXAMPLE
   Find-PackageSite -Name Console2 -Source "https://www.nuget.org/api/v2/"
   This command gets the Project website url for the Console2 package from Nuget resource
   PS C:\Scripts\PS> Find-PackageSite -Name Console2 -Source "https://www.nuget.org/api/v2/"
   http://sourceforge.net/projects/console/
.EXAMPLE
   Find-Package -Name console2 -source chocolatey | Find-PackageSite
   The results from the OneGet Find-Package cmdlet with source parameter are send through the pipeline
   to the Find-PackageSite function.
   PS C:\Scripts\PS> Find-Package -Name console2 -source chocolatey | Find-PackageSite
   http://sourceforge.net/projects/console/
.EXAMPLE
   Find-Package -Name console2 | Find-PackageSite
   PS C:\Scripts\PS> Find-Package -Name console2 | Find-PackageSite
   http://sourceforge.net/projects/console/
   http://sourceforge.net/projects/console/
.EXAMPLE
   Find-Package -Name console2 -Source Chocolatey | Find-PackageSite | Start-IE
   The result from the OneGet Find-Package Cmdlet with source parameter is send through the pipeline
   to the Find-PackageSite function which is piped to the Start-IE Function to open the URL in Internet Explorer.
#>

    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Name parameter
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $name,
        # Name parameter
        [Parameter(Mandatory=$false,
                  ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $Source)

    Process
    {
        #check if parameter has name property.
        if ($name.name)
        {
          $name = $name.name
        }

        #check source
        if ($source.source)
        {
          $source = $source.source
        }

        Write-Verbose "Using source: $source"

        if ($source -eq "Chocolatey")
        {
            write-verbose "Calling http://chocolatey.org/packages/$($name)"
            ((invoke-webrequest "http://chocolatey.org/packages/$($name)").links | ? {$_.outertext -eq ' Project Site'}).href      
        }
        if ($source -eq "https://www.nuget.org/api/v2/")
        {
            write-verbose "Calling http://www.nuget.org/packages/$($name)"
            ((invoke-webrequest "http://www.nuget.org/packages/$($name)").links | ? {$_.outertext -eq ' Project Site'}).href   
        }
        if (!$source)
        {
            write-verbose "Calling http://chocolatey.org/packages/$($name)"
            ((invoke-webrequest "http://chocolatey.org/packages/$($name)").links | ? {$_.outertext -eq ' Project Site'}).href 
            write-verbose "Calling http://www.nuget.org/packages/$($name)"
            ((invoke-webrequest "http://www.nuget.org/packages/$($name)").links | ? {$_.outertext -eq ' Project Site'}).href  

        }

    }

}
