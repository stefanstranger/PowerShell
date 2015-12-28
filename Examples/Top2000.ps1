<#
.Synopsis
   Top2000 lijst
.DESCRIPTION
   Overzicht van de Top2000
.EXAMPLE
   Get-Top2000
   Overzicht van de Top2000 van het jaar 2015
.EXAMPLE
   Get-Top2000 -jaar 2014
   Overzicht van de Top2000 van het jaar 2014
.URL
   http://www.nporadio2.nl/top2000
#>
function Get-Top2000
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   Position=0)]
        [string]
        $jaar='2015'
    )

    Begin
    {
        $urltop2000 = "http://www.nporadio2.nl/index.php?option=com_ajax&plugin=Top2000&format=json&year=$jaar"
        write-verbose "Retrieving $urltop2000"
    }
    Process
    {
        ((Invoke-RestMethod -Uri $urltop2000) | select-object -ExpandProperty data) | select-object @{L='Song';E={$_.s}}, @{L='Artiest';E={$_.a}}, @{L='Jaar';E={$_.yr}}, @{L='Positie';E={$_.pos}}, @{L='Verloop';E={$_.prv}}
    }
    End
    {
        write-verbose "Finished downloading top2000 from $jaar"
    }
}