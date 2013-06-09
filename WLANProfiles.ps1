$result = iex "cmd.exe /c `" netsh wlan show profiles `""

# Do some regex magix
# Create new wlan profile object
$WLANProfiles = @()


($result -match "All User Profile.*")| % {
    $Object = New-Object PSObject                                  
    $Object | add-member Noteproperty "Name" -Value ($_).split(":")[1].substring(1)
    $WLANProfiles = $WLANProfiles + $Object
}


$resultprofiles = @()
#Get more detailed info on WLAN Profiles
$WLANProfiles | % {write-debug ($_.name); 
    $profiles = iex "cmd.exe /c `" netsh wlan show profiles name=$($_.name)`""
    $resultprofiles += $profiles
}

# Do some regex magix again on the results.
$myprofiles =@()
$profileObject = New-Object PSObject                                  
    $profileObject | add-member Noteproperty "Name" -Value (($resultprofiles -match "[\d\s]{4}Name.*").split(":")[1] -replace "\A\s+")
    $profileObject | add-member Noteproperty "ConnectionMode" -Value (($resultprofiles -match "[\d\s]Connection mode.*").split(":")[1] -replace "\A\s+")
    $profileObject | add-member Noteproperty "Authentication" -Value (($resultprofiles -match "[\d\s]Authentication.*").split(":")[1] -replace "\A\s+")
    $myprofiles = $myprofiles + $profileObject

$myprofiles

#$name = ($resultprofiles -match "[\d\s]{4}Name.*").split(":")[1] -replace "\A\s+" #striped whitespace

#$connectionmode = ($resultprofiles -match "[\d\s]Connection mode.*").split(":")[1] -replace "\A\s+" #striped whitespace

#$authentication = ($resultprofiles -match "[\d\s]Authentication.*").split(":")[1] -replace "\A\s+" #striped whitespace
