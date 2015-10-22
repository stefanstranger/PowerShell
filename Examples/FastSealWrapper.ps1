# ---------------------------------------------------
# Script: C:\Scripts\PS\FastSealWrapper.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 10/21/2015 19:12:12 (Backtothefuture)
# Description: Wrapper function around FastSeal tool to Seal Operations Manager MP xml files
# Comments: You need to use sn.exe to create a key file first
#           Check https://technet.microsoft.com/en-us/library/hh457550.aspx on how to create a keyfile
#           Use FastSeal.exe from Silects MP Author tool found in folder C:\Program Files\Silect\MP Author\MPSeal
#           Download MP Author from: http://www.silect.com/mp-author
#           If you have the fastseal.exe tool installed in another folder change the fastseal variable on line 57 of script.
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------


Function FastSeal-MP
<#
.Synopsis
   Function to Seal OpsMgr Management Packs
.DESCRIPTION
   Wrapper Function around the FastSeal tool to easily seal Operations Manager Management Pack XML files.
.EXAMPLE   
    FastSeal-MP -MPFileName C:\temp\MPSeal\Fake.MP\Fake.MP.xml -KeyFileName C:\temp\MPSeal\pairkey.snk -OutDir C:\temp\mpseal\Output -CompanyName "Stranger"
    Seals the Fake.MP.xml with KeyFile pairkey.snk and stores the Fake.MP.mp files in C:\temp\mpseal\Output folder
.EXAMPLE
   dir C:\temp\MPSeal\Input | FastSeal-MP -KeyFileName C:\temp\MPSeal\pairkey.snk -OutDir C:\temp\mpseal\Output -CompanyName "Stranger"
   Pipes the results from the MP xml files stored in the C:\temp\MPSeal\Input folder and seals the MPs.
#>
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias("FullName")] 
        [String[]]
        $MPFileName,
        # OutDir
        [string]
        $Outdir,
         # KeyFileName
        [string]
        $KeyFileName,
         # CompanyName
        [string]
        $CompanyName
    )
    Begin
    {
        $FastSeal = "C:\Program Files\Silect\MP Author\MPSeal\FastSeal.exe"
    }
    process{
        $command = "'$FastSeal' " + "$MPFileName /KeyFile $KeyFileName /CompanyName $companyName /OutDir $OutDir"
        $ErrorActionPreference = 'silentlycontinue'
        & $FastSeal $MPFileName /KeyFile $KeyFileName /OutDir $OutDir /Company $companyName
        $erroraction = 'continue'
        $error[0]
    }
    End
    {

    }
}

