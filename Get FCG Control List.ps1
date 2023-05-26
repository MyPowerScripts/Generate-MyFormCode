Clear-Host
$X = [ordered]@{}

$L1 = [System.Collections.ArrayList]::New()
$L2 = [System.Collections.ArrayList]::New()

Clear-Host
$Assembly = [System.Reflection.Assembly]::GetAssembly("System.Windows.Forms.Form")
$ExportedTypes = $Assembly.ExportedTypes | Where-Object -FilterScript { $PSitem.IsPublic -and $PSItem.IsClass -and (-not $PSItem.IsAbstract) -and ($PSItem.FullName -like "System.Windows.Forms*") } | Sort-Object -Property FullName
ForEach ($ExportedType in $ExportedTypes)
{
  if ((($ExportedType.GetInterface("IComponent")).IsPublic) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
  {
    Write-Host
    Write-Host -Object $ExportedType.FullName -ForegroundColor Yellow
    ForEach ($Constructor in @($ExportedType.GetConstructors(("Instance", "Public"))))
    {
      Write-Host -ForegroundColor Cyan -Object "`t[$($ExportedType.FullName)]::New($($Constructor | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }))" 
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name))
    {
      Write-Host -ForegroundColor Green -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.Name -notin @("Controls", "DataBindings") -and -not $PSItem.CanWrite -and $PSItem.PropertyType.GetInterface("ICollection").IsPublic } | Sort-Object -Property Name))
    {
      Write-Host -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
      ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("Add"))
      {
        $AddText = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
        Write-Host -ForegroundColor Blue -Object "`t`t$($Property.Name).Add($AddText)"
      }
      ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("AddRange"))
      {
        $AddText = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
        Write-Host -ForegroundColor Magenta -Object "`t`t$($Property.Name).AddRange($AddText)"
      }
    }
  }
  elseif ((($ExportedType.GetInterface("ISerializable")).IsPublic) -and (-not $ExportedType.FullName.EndsWith("EventHandler", [System.StringComparison]::CurrentCultureIgnoreCase)) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
  {
    Write-Host
    Write-Host -Object $ExportedType.FullName -ForegroundColor Yellow
    ForEach ($Constructor in @($ExportedType.GetConstructors(("Instance", "Public"))))
    {
      Write-Host -ForegroundColor Cyan -Object "`t[$($ExportedType.FullName)]::New($($Constructor | ForEach-Object -Process { @($PSItem.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))"  }) -join ", " }))" 
    }
    ForEach($Property in @($ExportedType.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name))
    {
      Write-Host -ForegroundColor Green -Object "`t$($Property.Name) = $($Property.PropertyType.FullName)"
    }
  }
}

