#Create winform
#Assemblies
$assemblies = @'
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion
'@

#$assemblies
#End Assemblies

#Empty variables
$code,$tabs,$checkboxes,$displaynames,$ifstatements, $switchs, $counter = $null

#Objects
#Add checkbox object for each open ISE tab
$Checkboxes = $null
$tabs = $PSISe.PowerShellTabs.Files
foreach ($tab in $tabs) 
{
  #remove non ascii characters
  $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
  $Checkboxes += '$' + $displayname + " = New-Object System.Windows.Forms.CheckBox; `n"
}

#$Checkboxes

$objects = @"
#region Generated Form Objects
`$form1 = New-Object System.Windows.Forms.Form
$checkboxes
`$button2 = New-Object System.Windows.Forms.Button
`$button1 = New-Object System.Windows.Forms.Button
`$label1 = New-Object System.Windows.Forms.Label
`$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects
"@

#$objects
#End Objects

#Code
$displaynames = @()
foreach ($tab in $tabs) 
{
    $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
    $displaynames += '$' + $displayname 
    $Checkboxes += '$' + ($tab.Displayname).Replace(" ","") + " = New-Object System.Windows.Forms.CheckBox; `n"
}

foreach ($tab in $tabs) 
{
  $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''

$ifstatement = @"
if (`$$($displayname).checked){`$numberofselectedcheckboxes++}
"@

[string]$ifstatements += "$ifstatement `n"
}


foreach ($tab in $tabs) 
{
  $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
$switch = @"`$$displayname
"@
[string]$switchs += $switch + ","
}

$switchs = $switchs.Substring(0,$switchs.Length-1)

$counter = 0
foreach ($tab in $tabs) 
{

  $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''

$switchstatement = @"
{(`$$($displayname).checked)} {`$params += "'" + `$(`$tabs[$counter].FullPath) + "'"}
"@

$counter++

[string]$switchstatements += "$switchstatement `n"
}




$events = @"
#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.

`$button1_OnClick=
{
    
  `$numberofselectedcheckboxes = 0
  $ifstatements

  if (`$numberofselectedcheckboxes -le 1)
  {
    [System.Windows.Forms.MessageBox]::Show("No or only one Checkbox Selected!");
    `$form1.close()
  }
  elseif (`$numberofselectedcheckboxes -gt 2)
  {
    [System.Windows.Forms.MessageBox]::Show("Only 2 checkboxes allowed!");
  }

  else {
   
   `$params = @()
    Switch ($switchs)
    {
      $switchstatements
    }  
    
    `$params = (`$params | select -Unique) -join " "
    #Open WinMerge
    Invoke-Expression "C:\Temp\WinMergePortable\WinMergePortable.exe `$params" 

  }
  `$form1.close()

}

`$button2_OnClick= 
{
#TODO: Place custom script here
`$form1.close()
}

`$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	`$form1.WindowState = `$InitialFormWindowState
}

`$System_Drawing_Size = New-Object System.Drawing.Size
`$System_Drawing_Size.Height = $y+70
`$System_Drawing_Size.Width = 259
`$form1.ClientSize = `$System_Drawing_Size
`$form1.DataBindings.DefaultDataSourceUpdateMode = 0
`$form1.Name = "form1"
`$form1.Text = "Open WinMerge"

"@


#End Events



##################################################################

$tabs = $PSISe.PowerShellTabs.Files
$counter = 0
$y = 40
foreach ($tab in $tabs) 
{
  $displayname = ($tab.Displayname) -creplace '[^a-zA-Z0-9]', ''
  $counter++
  $y = $y+31

$checkboxtemplate = @"

`$$($displayname).DataBindings.DefaultDataSourceUpdateMode = 0

`$System_Drawing_Point = New-Object System.Drawing.Point
`$System_Drawing_Point.X = 23
`$System_Drawing_Point.Y = $y
`$$($displayname).Location = `$System_Drawing_Point
`$$($displayname).Name = "$($displayname)"
`$System_Drawing_Size = New-Object System.Drawing.Size
`$System_Drawing_Size.Height = 24
`$System_Drawing_Size.Width = 104
`$$($displayname).Size = `$System_Drawing_Size
`$$($displayname).TabIndex = $counter
`$$($displayname).Text = "Tab $counter"
`$$($displayname).UseVisualStyleBackColor = `$True

`$form1.Controls.Add(`$$($displayname))
"@

#Add each $checkboxtemplate to string
[string]$checkboxtemplates += "$checkboxtemplate `n"
}

#final part
$final = @"

`$button2.DataBindings.DefaultDataSourceUpdateMode = 0

`$System_Drawing_Point = New-Object System.Drawing.Point
`$System_Drawing_Point.X = 150
`$System_Drawing_Point.Y = $y+40
`$button2.Location = `$System_Drawing_Point
`$button2.Name = "button2"
`$System_Drawing_Size = New-Object System.Drawing.Size
`$System_Drawing_Size.Height = 23
`$System_Drawing_Size.Width = 75
`$button2.Size = `$System_Drawing_Size
`$button2.TabIndex = 6
`$button2.Text = "Cancel"
`$button2.UseVisualStyleBackColor = `$True
`$button2.add_Click(`$button2_OnClick)

`$form1.Controls.Add(`$button2)


`$button1.DataBindings.DefaultDataSourceUpdateMode = 0

`$System_Drawing_Point = New-Object System.Drawing.Point
`$System_Drawing_Point.X = 33
`$System_Drawing_Point.Y = $y+40
`$button1.Location = `$System_Drawing_Point
`$button1.Name = "button1"
`$System_Drawing_Size = New-Object System.Drawing.Size
`$System_Drawing_Size.Height = 23
`$System_Drawing_Size.Width = 75
`$button1.Size = `$System_Drawing_Size
`$button1.TabIndex = 5
`$button1.Text = "OK"
`$button1.UseVisualStyleBackColor = `$True
`$button1.add_Click(`$button1_OnClick)

`$form1.Controls.Add(`$button1)

`$label1.DataBindings.DefaultDataSourceUpdateMode = 0

`$System_Drawing_Point = New-Object System.Drawing.Point
`$System_Drawing_Point.X = 23
`$System_Drawing_Point.Y = 13
`$label1.Location = `$System_Drawing_Point
`$label1.Name = "label1"
`$System_Drawing_Size = New-Object System.Drawing.Size
`$System_Drawing_Size.Height = 23
`$System_Drawing_Size.Width = 171
`$label1.Size = `$System_Drawing_Size
`$label1.TabIndex = 1
`$label1.Text = "Select two open ISE tabs"

`$form1.Controls.Add(`$label1)

#endregion Generated Form Code

#Save the initial state of the form
`$InitialFormWindowState = `$form1.WindowState
#Init the OnLoad event to correct the initial state of the form
`$form1.add_Load($`OnLoadForm_StateCorrection)
#Show the Form
`$form1.ShowDialog()| Out-Null
"@

#$final

$code = @"
$assemblies
$objects
$events
$checkboxtemplates
$final
"@

Invoke-Expression $code