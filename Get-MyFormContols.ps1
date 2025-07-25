
Using namespace System.Windows.Forms
Using namespace System.Drawing
Using namespace System.Collections
Using namespace System.Collections.Generic
Using namespace System.Collections.Specialized

[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#region ******** FCG Commands ********

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
  [List[MyFormControlParameter]]$Parameter = [List[MyFormControlParameter]]::New()
  
  MyFormControlConstructor ([MyFormControlParameter[]]$Parameter)
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
  [List[MyFormControlParameter]]$Parameter = [List[MyFormControlParameter]]::New()
  
  MyFormControlItems ([String]$Medhod, [MyFormControlParameter[]]$Parameter)
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
  [List[MyFormControlConstructor]]$Constructors = [List[MyFormControlConstructor]]::New()
  [List[MyFormControlProperty]]$Properties = [List[MyFormControlProperty]]::New()
  [List[MyFormControlItems]]$Items = [List[MyFormControlItems]]::New()
  [List[MyFormControlEvent]]$Events = [List[MyFormControlEvent]]::New()
  
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

#endregion ******** FCG Commands ********

