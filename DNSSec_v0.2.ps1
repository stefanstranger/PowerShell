<#
.Synopsis
   DNSSec Debugger using Verisign webpage
.DESCRIPTION
   The DNSSEC Debugger is a Web-based tool for ensuring that the "chain of trust" is intact for a particular DNSSEC enabled domain name. 
   The tool shows a step-by-step validation of a given domain name and highlights any problems found.
.EXAMPLE
   Test-DNSSec -DomainName www.verisign.com
.EXAMPLE
   Test-DNSSec -DomainName www.stranger.nl
.LINKS
   http://dnssec-debugger.verisignlabs.com/
#>
function Test-Dnssec
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        $DomainName
    )

    $url = "http://dnssec-debugger.verisignlabs.com/$DomainName"

    $result = Invoke-WebRequest $URL

    $result.ParsedHtml.getElementsByTagName("tr") | 
        Where-Object "classname" -match "^L0" | 
            Select-Object -ExpandProperty InnerText | 
                ForEach-Object {if ($_ -match "^No")
                    {
                        write-host $_ -ForegroundColor red
                    }
                    else 
                    {
                        Write-Host $_
                    }
                }
}

