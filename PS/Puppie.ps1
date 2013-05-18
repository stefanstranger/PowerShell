"test" | % {$cmd = "invoke-scriptcs";$arg1 = 'Console.ForegroundColor = ConsoleColor.Red;Console.WriteLine("'+"$_"+'");Console.ResetColor();';& $cmd $arg1}

Invoke-ScriptCS 'Console.ForegroundColor = ConsoleColor.Red; Console.WriteLine("Not Killing a puppie");Console.ResetColor();'

#$cmd = "invoke-scriptcs 'Console.WriteLine(""test"")`;'"

#$cmd = 'invoke-scriptcs ''Console.WriteLine("test");'''

#&$cmd

"test" | % {$cmd = "Write-Host "+"tst";&$cmd}

$cmd = "invoke-scriptcs"
$test = "test"
$arg1 = 'Console.ForegroundColor = ConsoleColor.Red;Console.WriteLine("'+"$test"+'");Console.ResetColor();'
#$arg1 = 'Console.WriteLine("'+"$test"+'");'
& $cmd $arg1