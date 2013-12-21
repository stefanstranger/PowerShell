add-type -Path "C:\Users\stefstr\Documents\GitHub\flintlock\flint\flint.dll"

$pebble = new-object -TypeName flint.Pebble("COM4","692E")

$pebble.Connect()

$pebble.NotificationMail("PowerShell","Message from PowerShell","How cool is this? :-)")

#Lock Workstation Function
#http://gallery.technet.microsoft.com/ScriptCenter/a2178d49-79cd-4b3d-918a-47e9c6800262/
Function Lock-WorkStation {
#Requires -Version 2.0
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@

$LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
$LockWorkStation::LockWorkStation() | Out-Null
}

while ($true)
{

    if (!($pebble.Alive))
    {
        Lock-Workstation
    }

    sleep 10

}