enum Ensure
{
   Absent
   Present
}
 
[DscResource()]
class ResourceName
{
   [DscResourceKey()]
   #Some Key Property
 
   [DscResourceMandatory()]
   #Some Mandatory property
 
   #Use of enumeration
   [Ensure] $Ensure
 
   #Set function similar to Set-TargetResource
   [void] Set()
   {
      #Set logic goes here
   }
 
   #Test function similar to Test-TargetResource
   [bool] Test()
   {
      #Test logic goes here
   }
 
   #Get function similar to Get-TargetResource
   [Hashtable] Get()
   {
      #Get logic goes here
   }
}
