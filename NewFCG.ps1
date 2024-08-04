Clear-Host
$X = [ordered]@{}

$L1 = [System.Collections.ArrayList]::New()
$L2 = [System.Collections.ArrayList]::New()

Clear-Host


[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')


Add-Type -AssemblyName System.Windows.Forms

$Assembly = [System.Reflection.Assembly]::GetAssembly("System.Windows.Forms.Form")
$ExportedTypes = $Assembly.ExportedTypes | Where-Object -FilterScript { $PSitem.IsPublic -and $PSItem.IsClass -and (-not $PSItem.IsAbstract) -and ($PSItem.FullName -like "System.Windows.Forms*") } | Sort-Object -Property FullName
ForEach ($ExportedType in $ExportedTypes)
{
  if ((($ExportedType.GetInterface("IComponent")).IsPublic) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
  {
    #Write-Host
    Write-Host -Object $ExportedType.FullName -ForegroundColor Yellow
    ForEach ($Constructor in @($ExportedType.GetConstructors(("Instance", "Public"))))
    {
      # Create
      #Write-Host -ForegroundColor Cyan -Object "`t[$($ExportedType.FullName)]::New($($Constructor | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }))" 
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name))
    {
      # Properties
      Write-Host -ForegroundColor Green -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.Name -notin @("Controls", "DataBindings") -and -not $PSItem.CanWrite -and $PSItem.PropertyType.GetInterface("ICollection").IsPublic } | Sort-Object -Property Name))
    {
      #Write-Host -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
      ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("Add"))
      {
        # Add Item
        $AddText = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
        #Write-Host -ForegroundColor Blue -Object "`t`t$($Property.Name).Add($AddText)"
      }
      ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("AddRange"))
      {
        # Add Items
        $AddText = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
        #Write-Host -ForegroundColor Magenta -Object "`t`t$($Property.Name).AddRange($AddText)"
      }
    }
  }
  elseif ((($ExportedType.GetInterface("ISerializable")).IsPublic) -and (-not $ExportedType.FullName.EndsWith("EventHandler", [System.StringComparison]::CurrentCultureIgnoreCase)) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
  {
    #Write-Host
    Write-Host -Object $ExportedType.FullName -ForegroundColor Yellow
    ForEach ($Constructor in @($ExportedType.GetConstructors(("Instance", "Public"))))
    {
      # Create
      #Write-Host -ForegroundColor Cyan -Object "`t[$($ExportedType.FullName)]::New($($Constructor | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }))" 
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name))
    {
      # Properties
      #Write-Host -ForegroundColor Green -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
    }
  }
}

$Host.EnterNestedPrompt()




if ($Property.Name -eq "Items")
{
  $Host.EnterNestedPrompt()
}


if ((($C.GetInterface("ISerializable")).IsPublic) -and (@($C.GetConstructors(("Instance", "Public"))).Count))
{
  #$C.FullName
}
#@($I.PropertyType.GetDeclaredMethods("Add"))[0].ReturnType.FullName

$C = $B | Where-Object -FilterScript { ($PSItem.FullName -like "System.Windows.Forms*") -and (-not $PSItem.IsAbstract) } | Sort-Object -Property Name
ForEach ($D in $C)
{
  ForEach ($E in $D.ImplementedInterfaces)
  {
    if ($E.IsPublic -and (($E.Name -eq "ISerializable" -and (-not $D.IsSealed)) -or ($E.Name -eq "IComponent")))
    {
      ForEach ($F in $D.DeclaredConstructors)
      {
        if ($F.IsPublic)
        {
          $D.FullName
          $Properties = $D.GetProperties() | Where-Object -FilterScript { $PSItem.CanWrite -or $PSItem.PropertyType.Name -match "Collection" } | Select-Object -Property Name, @{"Name" = "Type"; "Expression" = { $PSItem.PropertyType } }, @{"Name" = "Enum"; "Expression" = { $PSItem.PropertyType.IsEnum } }, @{"Name" = "Collection"; "Expression" = { $PSItem.GetMethod.ReturnParameter.ParameterType.Name -match "Collection" } } | Sort-Object -Property Name
          $Constructors = $D.DeclaredConstructors | Where-Object -FilterScript { $PSItem.IsPublic } | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }
          ForEach ($Constructor in $Constructors)
          {
            #"[$($D.FullName)]::New($Constructor)"
          }
          ForEach ($Property in $Properties | Where-Object -FilterScript { $PSItem.Collection })
          {
            $AddMedthods = $Property.Type.DeclaredMethods | Where-Object -FilterScript { $PSItem.IsPublic -and $PSItem.Name -eq "Add" } | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }
            ForEach ($AddMedthod in $AddMedthods)
            {
              #"`t$($Property.Name).Add($AddMedthod)"
            }
            $AddRangeMedthods = $Property.Type.DeclaredMethods | Where-Object -FilterScript { $PSItem.IsPublic -and $PSItem.Name -eq "AddRange" } | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }
            ForEach ($AddRangeMedthod in $AddRangeMedthods)
            {
              #"`t$($Property.Name).AddRange($AddRangeMedthod)"
            }
          }
          $Events= $D.GetEvents() | Select-Object -Property Name, @{"Name" = "Type"; "Expression" = { $PSItem.EventHandlerType }}, @{"Name" = "Add"; "Expression" = { $PSItem.AddMethod.Name } }, @{"Name" = "Remove"; "Expression" = { $PSItem.RemoveMethod.Name } } | Sort-Object -Property Name
          $X.Add($D.Name, [PSCustomObject]@{"Type" = $D; "Properties" = $Properties; "Events" = $Events})
          ""
          Break
        }
      }
    }
  }
}

$A | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }

$A.

$X.TableLayoutPanel.GetProperties() | Where-Object -Property CanWrite -Value $True -EQ | Sort-Object -Property name

$X.Form.GetProperties() | Where-Object -FilterScript { $PSItem.PropertyType.Name -in @("ControlCollection", "ObjectCollection") } | Select-Object -property Name | Sort-Object -Property name

$X.Form.GetProperties() | Where-Object -Property Name -Value "ShowIcon" -EQ | Sort-Object -Property name


$X.Form.GetProperties() | Where-Object -Property CanWrite -Value $True -EQ | Sort-Object -Property name

$X.Form.GetProperties() | Where-Object -FilterScript { $PSItem.CanWrite -or $PSItem.PropertyType.Name -match "Collection" } | Select-Object -property name | Sort-Object -Property name













































Using namespace System.Collections

$Error.Clear()
Clear-Host

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

#region Class MyFormControlProperty
Class MyFormControlProperty
{
  [String]$Name
  [String]$PropertyType
  [Object]$Default
  MyFormControlProperty ([String]$Name, [String]$PropertyType, [Object]$Default)
  {
    $This.Name = $Name
    $This.PropertyType = $PropertyType
    $This.Default = $Default
  }
}
#endregion Class MyFormControlProperty

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
  [System.Collections.Generic.List[MyFormControlParameter]]$Parameter = [System.Collections.Generic.List[MyFormControlParameter]]::New()
  MyFormControlConstructor ([MyFormControlParameter[]]$Parameter)
  {
    $This.Parameter.AddRange($Parameter)
  }
}
#endregion Class MyFormControlConstructor

#region Class MyFormControlItems
Class MyFormControlItems
{
  [String]$Medhod
  [System.Collections.Generic.List[MyFormControlParameter]]$Parameter = [System.Collections.Generic.List[MyFormControlParameter]]::New()
  MyFormControlItems ([String]$Medhod, [MyFormControlParameter[]]$Parameter)
  {
    $This.Medhod = $Medhod
    $This.Parameter.AddRange($Parameter)
  }
}
#endregion Class MyFormControlItems

#region Class MyFormControl
Class MyFormControl
{
  [String]$Name
  [String]$FullName
  [System.Collections.Generic.List[MyFormControlConstructor]]$Constructors = [System.Collections.Generic.List[MyFormControlConstructor]]::New()
  [System.Collections.Generic.List[MyFormControlProperty]]$Properties = [System.Collections.Generic.List[MyFormControlProperty]]::New()
  [System.Collections.Generic.List[MyFormControlItems]]$Items = [System.Collections.Generic.List[MyFormControlItems]]::New()
  [System.Collections.Generic.List[MyFormControlEvent]]$Events = [System.Collections.Generic.List[MyFormControlEvent]]::New()
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
    $TmpConstructors = @($ExportedType.GetConstructors(("Instance", "Public")))
    if ((($ExportedType.GetInterface("IComponent")).IsPublic -or ($ExportedType.GetInterface("ISerializable")).IsPublic) -and ($TmpConstructors.Count -gt 0) -and (@($TmpConstructors | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
    {
      # Create Form Control Return Value
      $RetValue = [MyFormControl]::New($ExportedType.Name, $ExportedType.FullName)
      # Get Form Control Constructors
      ForEach ($TmpConstructor In @($ExportedType.GetConstructors(("Instance", "Public"))))
      {
        $RetValue.Constructors.Add([MyFormControlConstructor]::New(@($TmpConstructor.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) }))) | Out-Null
      }
      # Get Form Control Property List
      $TmpProperties = $ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name -Unique
      $TmpControl = $ExportedType::New()
      ForEach ($TmpProperty In $TmpProperties)
      {
        $RetValue.Properties.Add([MyFormControlProperty]::New($TmpProperty.Name, $TmpProperty.PropertyType.FullName, $TmpControl.PSObject.Properties[$TmpProperty.Name].Value)) | Out-Null
      }
      Try { $TmpControl.Dispose() } Catch {}
      # Get Form Control Items - Add / AddRange
      $TmpItems = $ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.Name -notin @("Controls", "DataBindings") -and -not $PSItem.CanWrite -and $PSItem.PropertyType.GetInterface("ICollection").IsPublic } | Sort-Object -Property Name -Unique
      ForEach ($TmpItem In $TmpItems)
      {
        ForEach ($TmpAddItem In @($TmpItem.PropertyType.GetDeclaredMethods("Add")))
        {
          $RetValue.Items.Add([MyFormControlItems]::New("Add", ([MyFormControlParameter[]]@($TmpAddItem.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) })))) | Out-Null
        }
        ForEach ($TmpAddItem In @($TmpItem.PropertyType.GetDeclaredMethods("AddRange")))
        {
          $RetValue.Items.Add([MyFormControlItems]::New("AddRange", ([MyFormControlParameter[]]@($TmpAddItem.GetParameters() | ForEach-Object -Process { [MyFormControlParameter]::New($PSItem.Name, $PSItem.ParameterType.FullName) })))) | Out-Null
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

