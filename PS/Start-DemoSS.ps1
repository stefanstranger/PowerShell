###########################################################################
# Original Version: 1.1
# Updated to Version 2.0, Maximo Trinidad, 02/09/2012
#--------------------------------------------------------------------------
# Comments:
# 1. Customized the foreground color to Cyan and backgroundColor to Black.
# 2. Created a Dump color to default to White.
# 3. Added to put back the default foreground and background colors.
# 4. Commented out the '(!) Suspense' option because Studio Shell can't
#    handle "$host.NestedPrompt".
# 5. Modify the Help menu to acomodate changes.
# 6. Commented out all "$Host.UI.RawUI.WindowTitle".
# 7. Replaced all "[System.Console]::ReadLine()" with "Read-Host".
# 8. Added an end of results 'write-host"-- Press Enter to continue --"'
#    follow with a read-host similate a pause.
###########################################################################
 
function Start-Demo
{
  param($file=".\demo.txt", [int]$command=0)
 
  ## - Saved previous default Host Colors:
  $defaultForegroundColor = $host.UI.RawUI.ForegroundColor;
  $defaultBackgroundColor = $host.UI.RawUI.BackgroundColor;
 
  ## - Customizing Host Colors:
  $host.UI.RawUI.ForegroundColor = "Cyan";
  $host.UI.RawUI.BackgroundColor = "Black";
  $CommentColor = "Green"
  $MetaCommandColor = "Cyan"
  $DumpColor = "White"
  Clear-Host
 
  ## - setting demo variables:
  $_Random = New-Object System.Random
  $_lines = @(Get-Content $file)
  $_starttime = [DateTime]::now
  $_PretendTyping = $true
  $_InterkeyPause = 100
  Write-Host -for $CommentColor @"
NOTE: Start-Demo replaces the typing but runs the actual commands.
.
<Demo [$file] Started.  Type `"?`" for help>
"@
 
  # We use a FOR and an INDEX ($_i) instead of a FOREACH because
  # it is possible to start at a different location and/or jump
  # around in the order.
  for ($_i = $Command; $_i -lt $_lines.count; $_i++)
  {
    if ($_lines[$_i].StartsWith("#"))
    {
        Write-Host -NoNewLine $("`n[$_i]PS> ")
        Write-Host -NoNewLine -Foreground $CommentColor $($($_Lines[$_i]) + "  ")
        continue
    }else
    {
        # Put the current command in the Window Title along with the demo duration
        $_Duration = [DateTime]::Now - $_StartTime
        #X  - $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]    {2}" -f [int]$_Duration.TotalMinutes, `
        #       [int]$_Duration.Seconds, $($_Lines[$_i])
        Write-Host -NoNewLine $("`n[$_i]PS> ")
        $_SimulatedLine = $($_Lines[$_i]) + "  "
        for ($_j = 0; $_j -lt $_SimulatedLine.Length; $_j++)
        {
           Write-Host -NoNewLine $_SimulatedLine[$_j]
           if ($_PretendTyping)
           {
               if ([System.Console]::KeyAvailable)
               {
                   $_PretendTyping = $False
               }
               else
               {
                   Start-Sleep -milliseconds $(10 + $_Random.Next($_InterkeyPause))
               }
           }
        } # For $_j
        $_PretendTyping = $true
    } # else
 
    #X - $_OldColor = $host.UI.RawUI.ForeGroundColor
    $host.UI.RawUI.ForeGroundColor = $MetaCommandColor
    #X - $_input=[System.Console]::ReadLine().TrimStart()
    $_input= Read-Host
    #X - $host.UI.RawUI.ForeGroundColor = $_OldColor
 
    switch ($_input)
    {
################ HELP with DEMO
      "?"
          {
            Write-Host -ForeGroundColor Yellow @"
--------------------------------------------------------------------------------
Help Running Demo: $file
.
(#x) Goto Command #x    (b) Backup     (?) Help
(fx) Find cmds using X  (q) Quit       (s) Skip
(t)  Timecheck          (d) Dump demo  (px) Typing Pause Interval
.
NOTE 1: Any key cancels "Pretend typing" for that line.  Use <SPACE> unless you
        want to run a one of these meta-commands.
.
NOTE 2: After cmd output, enter <CR> to move to the next line in the demo.
        This avoids the audience getting distracted by the next command
        as you explain what happened with this command.
.
NOTE 3: The line to be run is displayed in the Window Title BEFORE it is typed.
        This lets you know what to explain as it is typing.
---------------------------------------------------------------------------------
"@;
            Write-Host "-- Press Enter to continue --" -BackgroundColor white `
                -ForegroundColor Magenta;
            Read-Host; cls;
            $_i -= 1
          }
 
      #################### PAUSE
      {$_.StartsWith("p")}
          {
               $_InterkeyPause = [int]$_.substring(1)
               $_i -= 1
          }
 
      ####################  Backup
      "b" {
                if($_i -gt 0)
                {
                    $_i --
 
                    while (($_i -gt 0) -and ($_lines[$($_i)].StartsWith("#")))
                    {   $_i -= 1
                    }
                }
 
                $_i --
                $_PretendTyping = $false
          }
 
      ####################  QUIT
      "q"
          {
            Write-Host -ForeGroundColor $CommentColor "<Quit demo>"
              $host.UI.RawUI.ForegroundColor = $defaultForegroundColor;
              $host.UI.RawUI.BackgroundColor = $defaultBackgroundColor;
              cls;
            return
          }
 
      ####################  SKIP
      "s"
          {
            Write-Host -ForeGroundColor $CommentColor "<Skipping Cmd>"
          }
 
      ####################  DUMP the DEMO
      "d"
         {
            for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
            {
               if ($_i -eq $_ni)
               {   Write-Host -ForeGroundColor Yellow "$("*" * 25) >Interrupted< $("*" * 25)"
               }
               Write-Host -ForeGroundColor $DumpColor ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
            }
            $_i -= 1
            Write-Host "-- Press Enter to continue --" -BackgroundColor white `
                -ForegroundColor Magenta;
            Read-Host; cls;
          }
 
      ####################  TIMECHECK
      "t"
          {
             $_Duration = [DateTime]::Now - $_StartTime
             Write-Host -ForeGroundColor $CommentColor $(
                "Demo has run {0} Minutes and {1} Seconds`nYou are at line {2} of {3} " -f
                    [int]$_Duration.TotalMinutes,
                    [int]$_Duration.Seconds,
                    $_i,
                    ($_lines.Count - 1)
             )
             $_i -= 1
          }
 
      ####################  FIND commands in Demo
      {$_.StartsWith("f")}
          {
            for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
            {
               if ($_lines[$_ni] -match $_.SubString(1))
               {
                  Write-Host -ForeGroundColor $CommentColor ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
               }
            }
            $_i -= 1
          }
 
#      ####################  SUSPEND
# --> not working in StudioShell: help (!)  Suspend (not working)
#
#      {$_.StartsWith("!")}
#          {
#             if ($_.Length -eq 1)
#             {
#                 Write-Host -ForeGroundColor $CommentColor "<Suspended demo - type 'Exit' to resume>"
#                 function Prompt {"[Demo Suspended]`nPS>"}
#                 $host.EnterNestedPrompt()
#             }else
#             {
#                 trap [System.Exception] {Write-Error $_;continue;}
#                 Invoke-Expression $(".{" + $_.SubString(1) + "}| out-host")
#             }
#             $_i -= 1
#          }
 
      ####################  GO TO
      {$_.StartsWith("#")}
          {
             $_i = [int]($_.SubString(1)) - 1
             continue
          }
 
      ####################  EXECUTE
      default
          {
             trap [System.Exception] {Write-Error $_;continue;}
             Invoke-Expression $(".{" + $_lines[$_i] + "}| out-host")
             Write-Host "-- Press Enter to continue --" -BackgroundColor white -ForegroundColor Magenta;
             $_Duration = [DateTime]::Now - $_StartTime
             #X - $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]    {2}" -f [int]$_Duration.TotalMinutes, `
             #      [int]$_Duration.Seconds, $($_Lines[$_i])
             #X - [System.Console]::ReadLine()
             Read-Host;
          }
    } # Switch
  } # for
  ## Next three list to put backl the console default colors and do a clear screen:
  $host.UI.RawUI.ForegroundColor = $defaultForegroundColor;
  $host.UI.RawUI.BackgroundColor = $defaultBackgroundColor;
  cls;
  $_Duration = [DateTime]::Now - $_StartTime
  Write-Host -ForeGroundColor $CommentColor $("<Demo Complete {0} Minutes and {1} Seconds>" `
    -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds)
  Write-Host -ForeGroundColor $CommentColor $([DateTime]::now)
} # function
