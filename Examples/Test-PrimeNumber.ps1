#requires -Version 2
function Test-PrimeNumber
{
    <#
            .Synopsis
            Checks if integer is a Prime Number
            .DESCRIPTION
            Checks if integer is a Prime Number.
            A Prime Number can be divided evenly only by 1 or itself.
            And it must be a whole number greater than 1. 
            .EXAMPLE
            Test-PrimeNumber -Integer 7
            Returns the result of the integer 7 being a Prime Number
            .EXAMPLE
            2..10 | Test-PrimeNumber -Verbose   
            Shows for each of the range 2..10 if it is a prime number
            .EXAMPLE
            2..100 | Test-PrimeNumber | select @{L='Result';E={$_}} | Group-Object -Property Result -NoElement
            Shows the number of Prime Numbers in the range 2 till 100.
            .PARAMETER Integer
            An integer for which the function checks if it is a Prime Number
            .LINK
            http://www.mathsisfun.com/prime_numbers.html

    #>
    [CmdletBinding()]
    [Alias()]
    [OutputType([boolean])]
    Param
    (
        # Enter integer
        [Parameter(Mandatory = $true,
                ValueFromPipeline = $true,
        Position = 0)]
        [int]
        [ValidateScript({
                    $_ -ne 1
        })] #Checks if input integer is not 1
        $Integer
    )

    Begin
    {
        Write-Verbose 'Test-PrimeNumber function started'

    }
    Process
    {
        
        $j = 2
        $flag = $false        
        while ($j -le $Integer/2)
        {
            #Check if the modulus 2 (the remainder from a division operation) for the integer is 0
            #Example: Integer 3 (which is a Prime Number) 3 % 2 = 1
            if ($Integer % $j -eq 0) 
            {
                $flag = $true
                break
            }
            else
            {
                $j++
            }
        }

        if ($flag)
        {
            Write-Verbose "$Integer is not a prime number"
            return $false
        }
        else
        {
            Write-Verbose "$Integer is a prime number"
            return $true
        }
    }
    End
    {
        Write-Verbose 'Test-PrimeNumber function finished'
        Remove-Variable -Name j, integer
    }
}