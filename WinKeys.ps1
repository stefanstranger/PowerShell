# ---------------------------------------------------
# Script: WinKeys.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 09-06-2013
# Description: PowerShell Script with Function called Win to run WinKey Combinations from PowerShell
# Comments: Use this in RDP Sessions from within PowerShell
# Video usage url: http://www.youtube.com/watch?v=sI5h3ZGRAtI
# Idea to use PInvoke from StackOverflow
# http://stackoverflow.com/questions/6407584/sendkeys-send-and-windows-key
# http://stackoverflow.com/questions/742262/what-can-i-do-with-c-sharp-and-powershell
# ---------------------------------------------------


$source = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyboardSend
{


    public class KeyboardSend
    {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

        private const int KEYEVENTF_EXTENDEDKEY = 1;
        private const int KEYEVENTF_KEYUP = 2;

        public static void KeyDown(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY, 0);
        }

        public static void KeyUp(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        }
    }
}

"@

Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"

Function Win ($Key)
{
    [KeyboardSend.KeyboardSend]::KeyDown("LWin")
    [KeyboardSend.KeyboardSend]::KeyDown("$Key")
    [KeyboardSend.KeyboardSend]::KeyUp("LWin")

}

