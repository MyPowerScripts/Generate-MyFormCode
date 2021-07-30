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
