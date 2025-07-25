
Function Invoke-MyPause
{
  <#
    .SYNOPSIS
      Pause Script for Specified Number of Seconds
    .DESCRIPTION
      Pause Script for Specified Number of Seconds
    .PARAMETER Seconds
    .EXAMPLE
      Invoke-MyPause [-Seconds $Seconds]
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Int]$Seconds = 60
  )
  Write-Verbose -Message "Enter Function Invoke-MyPause"
  
  $TmpPause = [System.Diagnostics.Stopwatch]::StartNew()
  while ($TmpPause.Elapsed.TotalSeconds -lt $Seconds)
  {
    [System.Threading.Thread]::Sleep(10)
    [System.Windows.Forms.Application]::DoEvents()
  }
  $TmpPause.Stop()
  
  Write-Verbose -Message "Exit Function Invoke-MyPause"
}

#region function Invoke-MyPause
function Invoke-MyPause
{
  <#
    .SYNOPSIS
      Pause Script for Specified Number of Seconds
    .DESCRIPTION
      Pause Script for Specified Number of Seconds
    .PARAMETER Seconds
    .PARAMETER ScriptBlock
    .EXAMPLE
      Invoke-MyPause [-Seconds $Seconds]
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Int]$Seconds = 60,
    [ScriptBlock]$ScriptBlock = { $True }
  )
  Write-Verbose -Message "Enter Function Invoke-MyPause"
  
  $TmpPause = [System.Diagnostics.Stopwatch]::StartNew()
  Do
  {
    [System.Threading.Thread]::Sleep(10)
    $WaitCheck = $ScriptBlock.Invoke()
    [System.Windows.Forms.Application]::DoEvents()
  }
  while (($TmpPause.Elapsed.TotalSeconds -lt $Seconds) -and $WaitCheck)
  $TmpPause.Stop()
  
  Write-Verbose -Message "Exit Function Invoke-MyPause"
}
#endregion function Invoke-MyPause

