# Demo Logical Operators
# Comparison Operators are short circuit operators.
# This means that if the expression on the left-hand side of the -end
# operator is $false, the expression on the right-hand is not evaluated.

#Compare the differences
if ((5 -lt 4) -and (1..10000 | % {if ($_ -eq "never"){}})){} #takes not long because left-hand is false

if ((3 -lt 4) -and (1..10000 | % {if ($_ -eq "never"){}})){} #take some time to finish
