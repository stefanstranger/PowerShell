#Install MineCraft in Container
#Steps from https://www.youtube.com/watch?v=J8Sw_xLPBE8
#More info: http://www.shotgunventure.com/?p=132
#Credits: Mitch Melton

#Create new VMSwitch
New-VMSwitch -Name DHCP -NetAdapterName Ethernet0
#Create new container
New-Container -Name MinecraftBase -ContainerImageName WindowsServerCore -switchName DHCP

#Start Minecraft Container
start-container -name MinecraftBase

#Get ipaddress from Container
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {Get-NetIPAddress | select IPv4Address}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {new-item c:\Minecraft -ItemType Directory}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {Invoke-WebRequest 'http://javadl.sun.com/webapps/download/AutoDL?BundleId=107944' -outfile c:\Minecraft\javainstall.exe -useBasicParsing}
$version = Invoke-WebRequest -Uri https://launchermeta.mojang.com/mc/game/version_manifest.json -UseBasicParsing | ConvertFrom-Json

#Check latest version
$version.latest

#Use latest version info from version info
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {Invoke-WebRequest 'http://s3.amazonaws.com/Minecraft.Download/versions/1.9.2/minecraft_server.1.9.2.jar' -outfile c:\Minecraft\Minecraftserver.jar}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {New-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer -name DisableRollback -Type DWORD -value 1}

#Install MineCraft
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {C:\Minecraft\javainstall.exe /s INSTALLDIR=c:\Java REBOOT=Disable}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {Get-ChildItem c:\java}
#Create Eula.txt
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {"By changing the setting below to TRUE you are identicating your agreement to our EULA (http://account.mojang.com/documents/minecraft_eula). `neula=true" | out-file -FilePath c:\minecraft\eula.txt -Encoding ascii}
#Configure Minecraft server properties
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {"#MinecraftServerProperties`nmotd-Container SERVER!!!! `nonline-mode=false" | Out-File c:\minecraft\server.properties -Encoding ascii}
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {"banned-players.json","banned-ips.json","ops.json","whitelist.json" | ForEach-Object {New-Item -ItemType File c:\minecraft\$_}}
#Start Minecraft Server
Invoke-Command -ContainerName MinecraftBase -RunAsAdministrator {Set-location C:\minecraft; c:\java\bin\java.exe -jar Minecraftserver.jar nogui }


