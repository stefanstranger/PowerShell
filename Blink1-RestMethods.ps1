#'http://localhost:8934/blink1/pattern/add?pname=policeflash&pattern=0,%23ff0000,0.5,%230000ff,0.5'
#create pattern

invoke-WebRequest -Uri 'http://localhost:8934/blink1/pattern/add?pname=blink3green&pattern=3,%2300ff00,1.5,%23000000,0.5'


#Play Pattern
#'http://localhost:8934/blink1/pattern/play?pname=policeflash'
$url = "http://localhost:8934/blink1/pattern/play?pname=blink3green"
invoke-WebRequest -Uri $url

#Turn Pattern off
invoke-WebRequest -Uri 'http://localhost:8934/blink1/pattern/stop?pname=policeflash'

#Get Patterns
Invoke-RestMethod -Uri "http://localhost:8934/blink1/patterns" | select -ExpandProperty patterns


#Turn off
Invoke-RestMethod -Uri "http://localhost:8934/blink1/off"

#Get Blink1 ID
Invoke-RestMethod -Uri "http://localhost:8934/blink1/id"

#FadeToRGB
Invoke-RestMethod -Uri "http://localhost:8934/blink1/fadeToRGB"

invoke-WebRequest -Uri 'http://localhost:8934/blink1/fadeToRGB'

#Call Color Picker Copy Pattern
$patterns = Invoke-RestMethod -Uri "http://localhost:8934/blink1/patterns" | select -ExpandProperty patterns
invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/play?pname=$($patterns.name[0])"

#Set Blink1 Color
invoke-WebRequest -Uri "http://localhost:8934/blink1/fadeToRGB?rgb=%23ffcc00" #white

#Fade in 1 sec to 0000FF colour
invoke-WebRequest -Uri "http://localhost:8934/blink1/fadeToRGB?rgb=%230000FF&time=1.0"

invoke-WebRequest -Uri "http://localhost:8934/blink1/fadeToRGB?rgb=%23ff0000" #red

#Foo-Bar does not work
#Invoke-RestMethod -Uri "http://localhost:8934/blink1/foo%2Fbar"

#Random RGB Creator
(1..3 | Foreach {[string](Get-Random -Maximum 255)} | join-string -Separator " ").replace(" ",",")

#HEx
(1..3 | Foreach {[string](Get-Random -Maximum 255)} | % {"{0:x}" -f $_} | join-string -Separator " ").replace(" ",",")

0,0,0 | % {"{0:x}" -f $_}


#"{0:x}" -f 250


# Let's create "blink3green" = "blink green 3 times, 1.5 secs on, 0.5 secs off".
# 'http://localhost:8934/blink1/pattern/add?pname=blink3green&pattern=3,%2300ff00,1.5,%23000000,0.5'
# "http://localhost:8934/blink1/pattern/add?pname=blink3redgreenoff&pattern=3,#FF312F,0.50,#24FF20,0.50,#000000,0.50"
Invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/add?pname=blink3redgreenoff&pattern=3,%23FF312F,0.50,%2324FF20,0.50,%23000000,0.50"

Function Set-Blink1Pattern ($name,$repeat=0,$time,$colorinhex)
{
    $body = "pname=$name&pattern=$repeat,%23$colorinhex,$time,%230000ff,0.5"
    invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/add?$body"
}

#Set-Blink1Pattern -Name Test -Repeat 3 -Time 1.5 -colorinhex 00ff00


Function Start-Blink1Pattern ($name)
{
    invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/play?pname=$($name)"
}

Function Stop-Blink1Pattern ($name)
{
    invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/stop?pname=$($name)"
}

Function Get-Blink1Pattern
{
    Invoke-RestMethod -Uri "http://localhost:8934/blink1/patterns" | select -ExpandProperty patterns
}


#Start-Blink1Pattern -name Test

Function Stop-Blink1
{
    Invoke-RestMethod -Uri "http://localhost:8934/blink1/off"
}

Function Get-Blink1Id
{
    Invoke-RestMethod -Uri "http://localhost:8934/blink1/id"
}

Function Get-Blink1IFTTT
{
    $ifttt = Invoke-RestMethod "http://api.thingm.com/blink1/events/0D9CDDFF1A001EC2"

    $ifttt.events | select blink1_id, name, source, @{L="Date";E={[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($ifttt.events.date))}}
}


#When trigger is tested every 15 mins the last date time should be greater then current time minus 15 minutes.
#((Get-Blink1IFTTT).date -gt (get-date).AddMinutes(-15))

While ($true)
{

    if (((Get-Blink1IFTTT).Name -eq "TestBlink1") -and ((Get-Blink1IFTTT).date -lt (get-date).AddMinutes(-15))  ){Start-Blink1Pattern -Name blink3redgreenoff | Out-Null}
    sleep 60
}


$script = {while ($true){invoke-WebRequest -Uri "http://localhost:8934/blink1/pattern/play?pname=TestBlink1IFTTT";sleep 10}}

$blink1job = Start-Job -Name Test2 -ScriptBlock $script

$Blink1IFTTTJob = Start-Job -Name Blink1IFTTT -ScriptBlock {while ($true){if (((Get-Blink1IFTTT).Name -eq "TestBlink1") -and ((Get-Blink1IFTTT).date -lt (get-date).AddMinutes(-15))  ){Start-Blink1Pattern -Name blink3redgreenoff};sleep 60}}

$job = Start-Job -ScriptBlock {while ($true){Get-Blink1IFTTT;sleep 60}}
Receive-Job -Job $job

$testJob = Start-Job -Name Test -ScriptBlock {while ($true){Get-Process;sleep 60}}

Function Get-RandomColor
{
    $count = [Enum]::GetValues([System.Drawing.KnownColor]).Count
    $randomcolor = [System.Drawing.KnownColor](Get-Random -Minimum 1 -Maximum $count)
    [System.Drawing.Color]::FromKnownColor($randomcolor)
}


