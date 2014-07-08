#----------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\Examples\ProblemStepRecorder.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 07/08/2014 15:34:47
# Description: Simple Wrapper for Problem Step Recorder
# Comments: Initial idea, needs more options and features added.
# Disclamer: This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# ---------------------------------------------------

<#Problem Recorder Wrapper
psr.exe [/start |/stop][/output <fullfilepath>] [/sc (0|1)] [/maxsc <value>]
    [/sketch (0|1)] [/slides (0|1)] [/gui (o|1)]
    [/arcetl (0|1)] [/arcxml (0|1)] [/arcmht (0|1)]
    [/stopevent <eventname>] [/maxlogsize <value>] [/recordpid <pid>]
 

/start                        :Start Recording. (Outputpath flag SHOULD be specified)
/stop                        :Stop Recording.
/sc                          :Capture screenshots for recorded steps.
/maxsc                        :Maximum number of recent screen captures.
/maxlogsize                :Maximum log file size (in MB) before wrapping occurs.
/gui                        :Display control GUI.
/arcetl                        :Include raw ETW file in archive output.
/arcxml                        :Include MHT file in archive output.
/recordpid                :Record all actions associated with given PID.
/sketch                        :Sketch UI if no screenshot was saved.
/slides                        :Create slide show HTML pages.
/output                        :Store output of record session in given path.
/stopevent                :Event to signal after output files are generated.

PSR Usage Examples:

psr.exe
psr.exe /start /output fullfilepath.zip /sc1 /gui 0 /record <PID>
    /stopevent <eventname> /arcetl 1

psr.exe /start /output fullfilepath.xml /gui 0 /recordpid <PID>
    /stopevent <eventname>

psr.exe /start /output fullfilepath.xml /gui 0 /sc 1 /maxsc <number>
    /maxlogsize <value> /stopevent <eventname>

psr.exe /stop

Notes:
1.    Output path should include a directory path (e.g. '.\file.xml').
2.    Output file can either be a ZIP file or XML file
3.    Can't specify /arcxml /arcetl /arcmht /sc etc. if output is not a ZIP f
#>

$psrCommand = "C:\Windows\System32\psr.exe"
if (!(Test-Path $psrCommand)) {
        throw "psr.exe was not found at $psrCommand."
}
set-alias psr $psrCommand

Function Start-PSR
{
  param (
                [string] $outputFile = $(throw "ZipFile must be specified.")
        )
  
  psr /start /output $outputfile /gui 0 /sc 1 /sketch 1 /maxsc 100

}


Function Stop-PSR
{
  psr /stop
    
}