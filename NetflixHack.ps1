#requires -version 5.0

# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\PowerShell\NetflixHack.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 02/05/2016 10:04:42
# Description: The Netflix ID Bible – Every Category on Netflix
#              Url: http://whatsonnetflix.com/netflix-hacks/the-netflix-id-bible-every-category-on-netflix/
#              One of the complaints we often hear from our users is they actually spend more time looking for content rather than watching it. This quick little Netflix hack aims to help fix this problem.  While Netflix is becoming better at predicting what you want to watch, sometimes a specific category can be hard to find.
#              How this works is you grab the url from the Netflix search page:
#              http://www.netflix.com/WiAltGenre?agid=INSERTNUMBER 
#
#              New url is  http://www.netflix.com/browse/genre/INSERTNUMBER
#
#              Simply insert the number of the specific category you want to view.
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

Function Start-IE
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Url to open in browser
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $url)

    Process
    {
        start $url
    }

}

# define a sample-driven template describing the data structure:
$template = @'
{Genre*:1365} = {Desciption:Action & Adventure}
{Genre*:77232} = {Description:Asian Action Movies}
'@

#Load data from MP Wiki website
$url = 'http://whatsonnetflix.com/netflix-hacks/the-netflix-id-bible-every-category-on-netflix/'
$html = ((Invoke-WebRequest $url).AllElements).innertext
$html |  Out-String |
            ConvertFrom-String -TemplateContent $template | select * -Unique |
                Out-GridView -Title 'Netflix Genre Overview' -PassThru |
                    Select @{L='Url';E={"http://www.netflix.com/browse/genre/$($_.Genre)"}} |
                        Start-IE