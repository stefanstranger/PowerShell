#requires -Version 2

# ---------------------------------------------------
# Script: C:\Scripts\PS\Get-MPWiki.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 10/08/2015 12:12:12
# Description: Download MP info from MPWiki
#              http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx
# Comments: Initial version from Hans Zeitler (Microsoft)
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------


Function Get-MPWikiManagementPack
{
    <#
        .Synopsis
        Download Management Pack info from Microsoft Management Packs Wiki
        .DESCRIPTION
        Download Management Pack info from Microsoft Management Packs Wiki
        http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx
        .EXAMPLE
        Get-MPWikiManagementPack
        .EXAMPLE
        Get-MPWikiManagementPack | out-gridview
    #>
    [CmdletBinding()]
    [Alias()]
    [OutputType([string[]])]
    Param
    (
        # MPWikiURL
        [Parameter(Mandatory = $false,
                ValueFromPipelineByPropertyName = $false,
        Position = 0)]
        $MPWikeURL = 'http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx'
    )

    Begin
    {
        #The HtmlAgilityPack.dll should be in the folder where you are calling the function from
        $Path = (get-location).Path
        Write-Verbose 'Check for Html Agility Pack'
        if(!(Test-Path -Path "$Path\HtmlAgilityPack.dll"))
        {
            Write-Host 'Required Assembly HtmlAgilityPack.dll Missing' -ForegroundColor Red
            Write-Host 'Please download the HtmlAgiliyPack from http://htmlagilitypack.codeplex.com'
            Write-Host "And copy the HtmlAgilityPack.dll for .NET $($PSVersionTable.CLRVersion.Major).$($PSVersionTable.CLRVersion.Minor)"
            break

        }

        Add-Type -Path "$Path\HtmlAgilityPack.dll"

    }
    Process
    {
        $doc = New-Object -TypeName HtmlAgilityPack.HtmlDocument

        # Create a WebClient Object for downloading the files with
        $WebClient = New-Object -TypeName System.Net.WebClient

        Write-Verbose "Downloading content from $MPWikeURL..."
        
        # Download the HTML and save it to File for processing via HTMLAgility
        $MPBlogHTML = $WebClient.DownloadString($MPWikeURL)

        # Load into HTMLAgility Document Object
        $doc.LoadHtml($MPBlogHTML)
        Write-Verbose 'Finished downloading.'

        # Find the Management Pack Table and Get the Rows
        $TableRows = $doc.DocumentNode.SelectNodes("//table[@class='sortable']//tr")

        # Skip Header 
        $MPacks = $TableRows[1..($TableRows.Count-1)]

        # As the WebPage is EN-US make certain that the dates are converted Properly
        $CultureENUS = [CultureInfo]'en-US'
        $Global:ManagementPacks = foreach($node in $MPacks[0..($MPacks.count-2)])
        {
            $Name    = $node.SelectSingleNode('td[1]').InnerText
            $DLURL   = $node.SelectSingleNode('td[1]/a').GetAttributeValue('href','')
            $Version = $node.SelectSingleNode('td[2]').InnerText
            $Date    = $node.SelectSingleNode('td[3]').InnerText
            New-Object -TypeName PSObject -Property @{
                Name    = $Name
                Version = $Version
                Date    = [DateTime]::Parse($Date,$CultureENUS)
                URL     = $DLURL
            }
        }
        $ManagementPacks
    }
}
