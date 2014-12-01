# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\InstallDSCResourceWave8.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 12/01/2014 11:21:09
# Description: Install DSC Resource Wave 8 using DSC
# Comments: Idea from http://trevorsullivan.net/2014/08/21/use-powershell-dsc-to-install-dsc-resources/
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

configuration DSCWave {
    Archive DSCWave {
        DependsOn = '[Script]DSCWave';
        Ensure = 'Present';
        Path = "$env:windir\temp\DSC Resource Kit Wave 8 11102014.zip";
        Destination = "$env:ProgramFiles\WindowsPowerShell\Modules";
    }

    Script DSCWave {
        GetScript = { @{ Result = (Test-Path -Path "$env:windir\temp\DSC Resource Kit Wave 8 11102014.zip"); } };
        SetScript = {
            $Uri = 'https://gallery.technet.microsoft.com/DSC-Resource-Kit-All-c449312d/file/129525/1/DSC%20Resource%20Kit%20Wave%208%2011102014.zip';
            $OutFile = "$env:windir\temp\DSC Resource Kit Wave 8 11102014.zip";
            Invoke-WebRequest -Uri $Uri -OutFile $OutFile;
            Unblock-File -Path $OutFile;
            };
        TestScript = { Test-Path -Path "$env:windir\temp\DSC Resource Kit Wave 8 11102014.zip"; }
    }
    
    File DSCWave {
        DependsOn = '[Script]DSCWave';
        Ensure = 'Present';
        DestinationPath = "$env:ProgramFiles\WindowsPowerShell\Modules";
        SourcePath = "$env:ProgramFiles\WindowsPowerShell\Modules\All Resources";
        Recurse = $true

    }

    Script RemoveDSCFolder {
      GetScript = {
        GetScript = $GetScript
        SetScript = $SetScript
        TestScript = $TestScript
        $SourcePath = "$env:ProgramFiles\WindowsPowerShell\Modules\All Resources"
        Result = Test-Path $SourcePath
      }

      SetScript = {
        $SourcePath = "$env:ProgramFiles\WindowsPowerShell\Modules\All Resources"
        Remove-Item $SourcePath -Recurse -Force
        }

      TestScript = {
        $SourcePath = "$env:ProgramFiles\WindowsPowerShell\Modules\All Resources"
        (!(Test-Path $SourcePath))
      }
    }
    
}


# Compile MOF
DSCWave -OutputPath "$Env:Temp\DSCWave" 

# Make it so!
Start-DscConfiguration -Path "$Env:Temp\DSCWave" -Wait -Verbose -Force -ErrorAction Continue