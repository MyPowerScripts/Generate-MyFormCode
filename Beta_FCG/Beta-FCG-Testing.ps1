
Using namespace System.Collections

$Error.Clear()
Clear-Host

#region Class MyFormControlParameter
Class MyFormControlParameter
{
  [String]$Parameter
  [String]$PropertyType
  
  MyFormControlParameter ([String]$Parameter, [String]$PropertyType)
  {
    $This.Parameter = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($Parameter)
    $This.PropertyType = $PropertyType
  }
}
#endregion Class MyFormControlParameter

#region Class MyFormControlConstructor
Class MyFormControlConstructor
{
  [ArrayList]$Parameter = [ArrayList]::New()
  
  MyFormControlConstructor ([Object[]]$Parameter)
  {
    $This.Parameter.AddRange($Parameter)
  }
}
#endregion Class MyFormControlConstructor

#region Class MyFormControlProperty
Class MyFormControlProperty
{
  [String]$Name
  [String]$PropertyType
  [String]$BaseType
  [Object]$Default
  
  MyFormControlProperty ([String]$Name, [String]$PropertyType, [String]$BaseType, [Object]$Default)
  {
    $This.Name = $Name
    $This.PropertyType = $PropertyType
    $This.BaseType = $BaseType
    $This.Default = $Default
  }
}
#endregion Class MyFormControlProperty

#region Class MyFormControlItems
Class MyFormControlItems
{
  [String]$Medhod
  [ArrayList]$Parameter = [ArrayList]::New()
  
  MyFormControlItems ([String]$Medhod, [Object[]]$Parameter)
  {
    $This.Medhod = $Medhod
    $This.Parameter.AddRange($Parameter)
  }
}
#endregion Class MyFormControlItems

#region Class MyFormControlEvent
Class MyFormControlEvent
{
  [String]$Name
  [String]$AddMethod
  
  MyFormControlEvent ([String]$Name, [String]$AddMethod)
  {
    $This.Name = $Name
    $This.AddMethod = $AddMethod
  }
}
#endregion Class MyFormControlEvent

#region Class MyFormControl
Class MyFormControl
{
  [String]$Name
  [String]$FullName
  [ArrayList]$Constructors = [ArrayList]::New()
  [ArrayList]$Properties = [ArrayList]::New()
  [ArrayList]$Items = [ArrayList]::New()
  [ArrayList]$Events = [ArrayList]::New()
  
  MyFormControl ([String]$Name, [String]$FullName)
  {
    $This.Name = $Name
    $This.FullName = $FullName
  }
}
#endregion Class MyFormControl

#region function Get-MyFormControls
function Get-MyFormControls ()
{
  <#
    .SYNOPSIS
      Get List of Windows Form Controls
    .DESCRIPTION
      Get List of Windows Form Controls
    .EXAMPLE
      Get-MyFormControls
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
  )
  Write-Verbose -Message "Enter Function Get-MyFormControls"
  
  # Get System.Windows.Forms.Form Assembly
  $Assembly = [System.Reflection.Assembly]::GetAssembly("System.Windows.Forms.Form")
  # Get List of Exported System.Windows.Forms Types
  $ExportedTypes = $Assembly.ExportedTypes | Where-Object -FilterScript { $PSitem.IsPublic -and $PSItem.IsClass -and (-not $PSItem.IsAbstract) -and ($PSItem.FullName -like "System.Windows.Forms*") } | Sort-Object -Property FullName
  # Check Each Expoted Type
  ForEach ($ExportedType in $ExportedTypes)
  {
    # Get Form Control Contructors
    $TmpConstructors = @($ExportedType.GetConstructors(("Instance", "Public")))
    if ((($ExportedType.GetInterface("IComponent")).IsPublic -or ($ExportedType.GetInterface("ISerializable")).IsPublic) -and ($TmpConstructors.Count -gt 0) -and (@($TmpConstructors | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
    {
      # Create Form Control Return Value
      $RetValue = [MyFormControl]::New($ExportedType.Name, $ExportedType.FullName)
      # Get Form Control Constructors
      ForEach ($TmpConstructor In $TmpConstructors)
      {
        $RetValue.Constructors.Add([MyFormControlConstructor]::New(@($TmpConstructor.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) }))) | Out-Null
      }
      # Get Form Control Property List
      $TmpProperties = $ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name -Unique
      $TmpControl = $ExportedType::New()
      ForEach ($TmpProperty In $TmpProperties)
      {
        $RetValue.Properties.Add([MyFormControlProperty]::New($TmpProperty.Name, $TmpProperty.PropertyType.FullName, $TmpProperty.PropertyType.BaseType.FullName, $TmpControl.PSObject.Properties[$TmpProperty.Name].Value)) | Out-Null
      }
      Try { $TmpControl.Dispose() } Catch {}
      # Get Form Control Items - Add / AddRange Methods
      $TmpItems = $ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.Name -notin @("Controls", "DataBindings") -and (-not $PSItem.CanWrite) -and $PSItem.PropertyType.GetInterface("ICollection").IsPublic } | Sort-Object -Property Name -Unique
      ForEach ($TmpItem In $TmpItems)
      {
        ForEach ($TmpAddItem In @($TmpItem.PropertyType.GetDeclaredMethods("Add")))
        {
          $RetValue.Items.Add([MyFormControlItems]::New("Add", @($TmpAddItem.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) }))) | Out-Null
        }
        ForEach ($TmpAddItem In @($TmpItem.PropertyType.GetDeclaredMethods("AddRange")))
        {
          $RetValue.Items.Add([MyFormControlItems]::New("AddRange", @($TmpAddItem.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) }))) | Out-Null
        }
      }
      # Get Form Control Events
      ForEach ($Event In @($ExportedType.GetEvents() | Sort-Object -Property Name -Unique))
      {
        $RetValue.Events.Add([MyFormControlEvent]::New($Event.Name, $Event.AddMethod.Name)) | Out-Null
      }
      # Return Form Confrom Info
      $RetValue
    }
  }
  
  Write-Verbose -Message "Exit Function Get-MyFormControls"
}
#endregion function Get-MyFormControls

$FormControlList = Get-MyFormControls
$FormControlList.Count


#region function New-MyFormFunction
Function New-MyFormFunction ()
{
  <#
    .SYNOPSIS
      Generates a Form Control Event Function
    .DESCRIPTION
      Generates a Form Control Event Function
    .PARAMETER ScriptCode
    .PARAMETER ControlName
    .PARAMETER MyFormControl
    .PARAMETER MyFormControlEvent
    .EXAMPLE
      New-MyFormFunction -ScriptCode $ScriptCode -ControlName $ControlName -MyFormControl $MyFormControl -MyFormControlEvent $MyFormControlEvent
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [parameter(Mandatory = $True)]
    [String]$ScriptCode,
    [parameter(Mandatory = $True)]
    [String]$ControlName,
    [parameter(Mandatory = $True)]
    [MyFormControl]$MyFormControl,
    [parameter(Mandatory = $True)]
    [MyFormControlEvent[]]$MyFormControlEvent
  )
  Write-Verbose -Message "Enter Function New-MyFormFunction"
  
  # Create New StringBuilder
  $StringBuilder = [System.Text.StringBuilder]::New()
  
  ForEach ($Event In $MyFormControlEvent)
  {
    # Function Name
    If ($MyFormControl.Name -eq "Form")
    {
      $FunctionName = "$($ScriptCode)$($MyFormControl.Name)$($Event.Name)"
    }
    Else
    {
      $FunctionName = "$($ScriptCode)$($ControlName)$($MyFormControl.Name)$($Event.Name)"
    }
    
    #region ---- Generate Event Function Code -----
    [Void]$StringBuilder.AppendLine("#region ---- Function Start-$($FunctionName) ----")
    [Void]$StringBuilder.AppendLine("function Start-$($FunctionName)")
    [Void]$StringBuilder.AppendLine("{")
    [Void]$StringBuilder.AppendLine("  <#")
    [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
    [Void]$StringBuilder.AppendLine("      $($Event.Name) Event for the $($ScriptCode)$($ControlName) $($MyFormControl.Name) Control")
    [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
    [Void]$StringBuilder.AppendLine("      $($Event.Name) Event for the $($ScriptCode)$($ControlName) $($MyFormControl.Name) Control")
    [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
    [Void]$StringBuilder.AppendLine("       The $($MyFormControl.Name) Control that fired the $($Event.Name) Event")
    [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
    [Void]$StringBuilder.AppendLine("       The Event Arguments for the $($MyFormControl.Name) $($Event.Name) Event")
    [Void]$StringBuilder.AppendLine("    .EXAMPLE")
    [Void]$StringBuilder.AppendLine("       Start-$($FunctionName) -Sender `$Sender -EventArg `$EventArg")
    [Void]$StringBuilder.AppendLine("    .NOTES")
    [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName)")
    [Void]$StringBuilder.AppendLine("  #>")
    [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
    [Void]$StringBuilder.AppendLine("  param (")
    [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
    [Void]$StringBuilder.AppendLine("    [$($MyFormControl.Fullname)]`$Sender,")
    [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
    [Void]$StringBuilder.AppendLine("    [Object]`$EventArg")
    [Void]$StringBuilder.AppendLine("  )")
    [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter $($Event.Name) Event for ```$$($ScriptCode)$($ControlName)$($MyFormControl.Name)`"")
    [Void]$StringBuilder.AppendLine("")
    
    # ----------------------------------
    # Incerement / Reset Auto Exit Count
    # ----------------------------------
    If (($MyFormControl.Name -eq "Timer") -and ($Event.Name -eq "Tick"))
    {
      [Void]$StringBuilder.AppendLine("  # Incerement Auto Exit Count")
      [Void]$StringBuilder.AppendLine("  [MyConfig]::AutoExit += 1")
      [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Auto Exit in `$([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) Minutes`"")
      [Void]$StringBuilder.AppendLine("  if ([MyConfig]::AutoExit -ge [MyConfig]::AutoExitMax)")
      [Void]$StringBuilder.AppendLine("  {")
      [Void]$StringBuilder.AppendLine("    `$$($ScriptCode)Form.Close()")
      [Void]$StringBuilder.AppendLine("  }")
      [Void]$StringBuilder.AppendLine("  ElseIf (([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) -le 5)")
      [Void]$StringBuilder.AppendLine("  {")
      [Void]$StringBuilder.AppendLine("    `$$($ScriptCode)BtmStatusStrip.Items[`"Status`"].Text = `"Auto Exit in `$([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) Minutes`"")
      [Void]$StringBuilder.AppendLine("  }")
    }
    Else
    {
      [Void]$StringBuilder.AppendLine("  # Reset Auto Exit Count")
      [Void]$StringBuilder.AppendLine("  [MyConfig]::AutoExit = 0")
    }
    [Void]$StringBuilder.AppendLine("")
    
    # ------------------------------------------
    # Add Form Control Event Customizations Here
    # ------------------------------------------
    #region Form Control Event Customizations
    Switch ($MyFormControl.Name)
    {
      "ControlName"
      {
        Switch ($Event.Name)
        {
          "EventName"
          {
            Break
          }
          Default
          {
            Break
          }
        }
        Break
      }
      Default
      {
        Break
      }
    }
    #endregion Form Control Event Customizations
    
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit $($Event.Name) Event for ```$$($ScriptCode)$($ControlName)$($MyFormControl.Name)`"")
    [Void]$StringBuilder.AppendLine("}")
    [Void]$StringBuilder.AppendLine("#endregion ==== Function Start-$($FunctionName) ====")
    [Void]$StringBuilder.AppendLine("`$$($ScriptCode)$($ControlName)$($MyFormControl.Name).$($Event.AddMethod)({Start-$($FunctionName) -Sender `$This -EventArg `$PSItem})")
    [Void]$StringBuilder.AppendLine("")
    #endregion ==== Generate Event Function Code ====
  }
  
  # Return Generated Code
  $StringBuilder.ToString()
  $StringBuilder.Clear()
  
  Write-Verbose -Message "Exit Function New-MyFormFunction"
}
#endregion function New-MyFormFunction

#region function New-MyFormControl
Function New-MyFormControl ()
{
  <#
    .SYNOPSIS
      Generates a Form Control
    .DESCRIPTION
      Generates a Form Control
    .PARAMETER ScriptCode
    .PARAMETER ControlName
    .PARAMETER MyFormControl
    .EXAMPLE
      New-MyFormControl -ScriptCode $ScriptCode -ControlName $ControlName -MyFormControl $MyFormControl
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [parameter(Mandatory = $True)]
    [String]$ScriptCode,
    [parameter(Mandatory = $True)]
    [String]$ControlName,
    [parameter(Mandatory = $True)]
    [MyFormControl]$MyFormControl,
    [parameter(Mandatory = $True)]
    [MyFormControlEvent[]]$MyFormControlEvent
  )
  Write-Verbose -Message "Enter Function New-MyFormControl"
  
  # Create New StringBuilder
  $StringBuilder = [System.Text.StringBuilder]::New()
  
  # Return Generated Code
  $StringBuilder.ToString()
  $StringBuilder.Clear()
  
  Write-Verbose -Message "Exit Function New-MyFormControl"
}
#endregion function New-MyFormControl


$Host.EnterNestedPrompt()
Exit


#region ******** Sample Functions ********

#region function Verb-Noun
Function Verb-Noun ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Verb-Noun -Value "String"
    .NOTES
      Original Function By %YourName%
      
      %Date% - Initial Release
  #>
  [CmdletBinding(DefaultParameterSetName = "ByValue")]
  Param (
    [parameter(Mandatory = $False, ParameterSetName = "ByValue")]
    [String[]]$Value = "Default Value"
  )
  Write-Verbose -Message "Enter Function Verb-Noun"
  
  # Loop and Proccess all Values
  ForEach ($Item In $Value)
  {
  }
  
  Write-Verbose -Message "Exit Function Verb-Noun"
}
#endregion function Verb-Noun

#region function Verb-NounPiped
Function Verb-NounPiped()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Verb-NounPiped -Value "String"
    .EXAMPLE
      $Value | Verb-NounPiped
    .NOTES
      Original Function By %YourName%
      
      %Date% - Initial Release
  #>
  [CmdletBinding(DefaultParameterSetName = "ByValue")]
  Param (
    [parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, ParameterSetName = "ByValue")]
    [String[]]$Value = "Default Value"
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Verb-NounPiped Begin Block"
    # This Code is Executed Once when the Function Begins
    
    Write-Verbose -Message "Exit Function Verb-NounPiped Begin Block"
  }
  Process
  {
    Write-Verbose -Message "Enter Function Verb-NounPiped Process Block"
    
    # Loop and Proccess all Values
    ForEach ($Item In $Value)
    {
    }
    
    Write-Verbose -Message "Exit Function Verb-NounPiped Process Block"
  }
  End
  {
    Write-Verbose -Message "Enter Function Verb-NounPiped End Block"
    # This Code is Executed Once whent he Function Ends
    
    Write-Verbose -Message "Exit Function Verb-NounPiped End Block"
  }
}
#endregion function Verb-NounPiped

#endregion ******** Sample Functions ********
