<#
    Requires ILSpy
    Tested with version 2.1.0.1603
    http://ilspy.net/
    You'll need to adjust this to your ILSpy path
    Get-Date | Get-Member AddTicks | Get-MemberBody
#>

[void][System.Reflection.Assembly]::LoadFrom("C:\ilspy\ILSpy.exe") 

function Get-MemberBody
{
    [CmdletBinding()]
    param(
    [Parameter(ParameterSetName="MI")]
    [System.Reflection.MemberInfo]$memberInfo,
    [Parameter(ParameterSetName="MD",ValueFromPipeline=$true)]
    [Microsoft.PowerShell.Commands.MemberDefinition]$memberDefinition)

    Process 
    {
        if ($memberDefinition -ne $null)
        {
            $type = [AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | ? FullName -eq $memberDefinition.TypeName
            $declaringTypeName = $type.FullName
            $assembly = $type.Assembly.CodeBase.Replace("file:///", "").Replace("/", "\")
            $memberName = $memberDefinition.Name
            $memberType = $memberDefinition.MemberType
        }
        else 
        {
            $assembly = $memberInfo.DeclaringType.Assembly.CodeBase.Replace("file:///", "").Replace("/", "\")
            $memberName = $memberInfo.Name
            $declaringTypeName = $memberInfo.DeclaringType.FullName
        }

        $AssemblyDefinition = [Mono.Cecil.AssemblyDefinition]::ReadAssembly($assembly)

        $Context = New-Object ICSharpCode.Decompiler.DecompilerContext -ArgumentList $AssemblyDefinition.MainModule
        $TextOutput = New-Object ICSharpCode.Decompiler.PlainTextOutput
        $Opts = New-Object ICSharpCode.ILSpy.DecompilationOptions
        $Lang = New-Object ICSharpCode.ILSpy.CSharpLanguage
        
        try 
        {
            if ($memberType -eq "Method")
            {
                $CecilMethod = $AssemblyDefinition.MainModule.Types | ? FullName -eq $declaringTypeName | Select -ExpandProperty Methods | ? Name -eq $memberName
                $Lang.DecompileMethod($CecilMethod,$TextOutput,$Opts)
            }

            if ($memberType -eq "Property")
            {
                $CecilMember = $AssemblyDefinition.MainModule.Types | ? FullName -eq $declaringTypeName | Select -ExpandProperty Properties | ? Name -eq $memberName
                $Lang.DecompileProperty($CecilMember,$TextOutput,$Opts)
            }

            if ($memberType -eq "Event")
            {
                $CecilMember = $AssemblyDefinition.MainModule.Types | ? FullName -eq $declaringTypeName | Select -ExpandProperty Events | ? Name -eq $memberName
                $Lang.DecompileEvent($CecilMember,$TextOutput,$Opts)
            }

            if ($memberType -eq "Field")
            {
                $CecilMember = $AssemblyDefinition.MainModule.Types | ? FullName -eq $declaringTypeName | Select -ExpandProperty Fields | ? Name -eq $memberName
                $Lang.DecompileField($CecilMember,$TextOutput,$Opts)
            }
        }
        catch
        {
            Write-Error (New-Object -TypeName System.Exception -ArgumentList "Failed to decompile $declaringTypeName.$memberName", $Error[0].Exception)
        }
        $TextOutput.ToString()
    }
}
