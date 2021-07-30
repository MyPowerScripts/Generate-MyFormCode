#requires -version 3.0

<#
  .SYNOPSIS
    Utility to Generate Form Code 
  .DESCRIPTION
    Utility to Generate Form Code 
  .EXAMPLE
  .NOTES
    My Script MyFCG Version 5.x by Ken Sweet on 08/14/2020
    Created with "My Form Code Generator" Version 5.0.0.3
#>
#[CmdletBinding()]
#param (
#)

$ErrorActionPreference = "Stop"

# Comment Out $VerbosePreference Line for Production Deployment
$VerbosePreference = "Continue"

# Comment Out $DebugPreference Line for Production Deployment
$DebugPreference = "Continue"

# Clear Previous Error Messages
$Error.Clear()

[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

[System.Windows.Forms.Application]::EnableVisualStyles()

#region >>>>>>>>>>>>>>>> MyFCG Configuration <<<<<<<<<<<<<<<<
$MyFCGConfig = [Ordered]@{ }

# Default Form Run Mode
$MyFCGConfig.Production = $True

$MyFCGConfig.ScriptName = "My PS3 Form Code Generator"
$MyFCGConfig.ScriptVersion = "5.0.0.4"
$MyFCGConfig.ScriptAuthor = "Ken Sweet"

# Default Form Settings
$MyFCGConfig.FormSpacer = 2
$MyFCGConfig.FormMinWidth = 70
$MyFCGConfig.FormMinHeight = 40
$MyFCGConfig.InfoMinWidth = 18
$MyFCGConfig.EventHeight = 14
$MyFCGConfig.DefScriptName = ""
$MyFCGConfig.CodeFont = "Courier New"
$MyFCGConfig.DefaultEvents = @{ }

# Default Font
$MyFCGConfig.FontFamily = "Verdana"
$MyFCGConfig.FontSize = 10
$MyFCGConfig.FontTitle = 1.5

# Default Form Color Mode
$MyFCGConfig.DarkMode = ((Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -ErrorAction "SilentlyContinue").AppsUseLightTheme -eq "0")

# Form Auto Exit
$MyFCGConfig.AutoExit = 0
$MyFCGConfig.AutoExitMax = 60
$MyFCGConfig.AutoExitTic = 60000

# Current DateTime Offset
$MyFCGConfig.DateTimeOffset = [System.DateTimeOffset]::Now

$MyFCGConfig.Colors = @{}

$MyFCGConfig.Font = @{}

#endregion ================ MyFCG Configuration  ================

#region >>>>>>>>>>>>>>>> Set MyFCG Default Colors <<<<<<<<<<<<<<<<

# [System.Drawing.Color]::LightCoral
# [System.Drawing.Color]::DodgerBlue

if ($MyFCGConfig.DarkMode)
{
  $MyFCGConfig.Colors.Add("Back", ([System.Drawing.Color]::FromArgb(16, 16, 16)))
  $MyFCGConfig.Colors.Add("Fore", ([System.Drawing.Color]::LightCoral))
  $MyFCGConfig.Colors.Add("LabelFore", ([System.Drawing.Color]::LightCoral))
  $MyFCGConfig.Colors.Add("ErrorFore", ([System.Drawing.Color]::Red))
  $MyFCGConfig.Colors.Add("TitleBack", ([System.Drawing.Color]::DarkGray))
  $MyFCGConfig.Colors.Add("TitleFore", ([System.Drawing.Color]::Black))
  $MyFCGConfig.Colors.Add("GroupFore", ([System.Drawing.Color]::LightCoral))
  $MyFCGConfig.Colors.Add("TextBack", ([System.Drawing.Color]::Gainsboro))
  $MyFCGConfig.Colors.Add("TextFore", ([System.Drawing.Color]::Black))
  $MyFCGConfig.Colors.Add("ButtonBack", ([System.Drawing.Color]::DarkGray))
  $MyFCGConfig.Colors.Add("ButtonFore", ([System.Drawing.Color]::Black))
}
else
{
  $MyFCGConfig.Colors.Add("Back", ([System.Drawing.Color]::White))
  $MyFCGConfig.Colors.Add("Fore", ([System.Drawing.Color]::Navy))
  $MyFCGConfig.Colors.Add("LabelFore", ([System.Drawing.Color]::Navy))
  $MyFCGConfig.Colors.Add("ErrorFore", ([System.Drawing.Color]::Red))
  $MyFCGConfig.Colors.Add("TitleBack", ([System.Drawing.Color]::LightBlue))
  $MyFCGConfig.Colors.Add("TitleFore", ([System.Drawing.Color]::Navy))
  $MyFCGConfig.Colors.Add("GroupFore", ([System.Drawing.Color]::Navy))
  $MyFCGConfig.Colors.Add("TextBack", ([System.Drawing.Color]::White))
  $MyFCGConfig.Colors.Add("TextFore", ([System.Drawing.Color]::Black))
  $MyFCGConfig.Colors.Add("ButtonBack", ([System.Drawing.Color]::Gainsboro))
  $MyFCGConfig.Colors.Add("ButtonFore", ([System.Drawing.Color]::Navy))
}

#endregion ================ Set MyFCG Default Colors ================

#region >>>>>>>>>>>>>>>> Set MyFCG Default Font Data <<<<<<<<<<<<<<<<

$TempBoldFont = New-Object -TypeName System.Drawing.Font($MyFCGConfig.FontFamily, $MyFCGConfig.FontSize, [System.Drawing.FontStyle]::Bold)
$TempGraphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
$TempMeasureString = $TempGraphics.MeasureString("X", $TempBoldFont)
$MyFCGConfig.Font.Add("Regular", (New-Object -TypeName System.Drawing.Font($MyFCGConfig.FontFamily, $MyFCGConfig.FontSize, [System.Drawing.FontStyle]::Regular)))
$MyFCGConfig.Font.Add("Bold", ($TempBoldFont))
$MyFCGConfig.Font.Add("Title", (New-Object -TypeName System.Drawing.Font($MyFCGConfig.FontFamily, ($MyFCGConfig.FontSize * $MyFCGConfig.FontTitle), [System.Drawing.FontStyle]::Bold)))
$MyFCGConfig.Font.Add("Ratio", ($TempGraphics.DpiX / 96))
$MyFCGConfig.Font.Add("Width", ([Math]::Floor($TempMeasureString.Width)))
$MyFCGConfig.Font.Add("Height", ([Math]::Ceiling($TempMeasureString.Height)))
$TempBoldFont = $Null
$TempMeasureString = $Null
$TempGraphics.Dispose()
$TempGraphics = $Null

#endregion ================ Set MyFCG Default Font Data ================

#region >>>>>>>>>>>>>>>> Windows APIs <<<<<<<<<<<<<<<<

#region ******** [Console.Window] ********

#[Void][Console.Window]::Hide()
#[Void][Console.Window]::Show()

$MyCode = @"
using System;
using System.Runtime.InteropServices;

namespace Console
{
  public class Window
  {
    [DllImport("Kernel32.dll")]
    private static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public static bool Hide()
    {
      return ShowWindowAsync(GetConsoleWindow(), 0);
    }

    public static bool Show()
    {
      return ShowWindowAsync(GetConsoleWindow(), 5);
    }
  }
}
"@
Add-Type -TypeDefinition $MyCode -Debug:$False
#endregion ******** [Console.Window] ********

#region ******** [Extract.MyIcon] ********

#$TempCount = [Extract.MyIcon]::IconCount("C:\Windows\System32\shell32.dll")
#$TempIcon = [Extract.MyIcon]::IconReturn("C:\Windows\System32\shell32.dll", 1, $False)

$MyCode = @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace Extract
{
  public class MyIcon
  {
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool DestroyIcon(IntPtr hIcon);

    [DllImport("shell32.dll", CharSet = CharSet.Auto)]
    private static extern uint ExtractIconEx(string szFileName, int nIconIndex, IntPtr[] phiconLarge, IntPtr[] phiconSmall, uint nIcons);

    public static int IconCount(string FileName)
    {
      try
      {
        IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };
        IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };
        return (int)ExtractIconEx(FileName, -1, LIcons, SIcons, 1);
      }
      catch
      {
      }
      return 0;
    }

    public static Icon IconReturn(string FileName, int IconNum, bool GetLarge)
    {
      IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };
      IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };
      Icon RetData = null;
      try
      {
        int IconCount = (int)ExtractIconEx(FileName, IconNum, LIcons, SIcons, 1);
        if (GetLarge)
        {
          if (IconCount > 0 && LIcons[0] != IntPtr.Zero)
          {
            RetData = (Icon)Icon.FromHandle(LIcons[0]).Clone();
          }
        }
        else
        {
          if (IconCount > 0 && SIcons[0] != IntPtr.Zero)
          {
            RetData = (Icon)Icon.FromHandle(SIcons[0]).Clone();
          }
        }
      }
      catch
      {
      }
      finally
      {
        foreach (IntPtr ptr in LIcons)
        {
          if (ptr != IntPtr.Zero)
          {
            DestroyIcon(ptr);
          }
        }
        foreach (IntPtr ptr in SIcons)
        {
          if (ptr != IntPtr.Zero)
          {
            DestroyIcon(ptr);
          }
        }
      }
      return RetData;
    }

    public static Icon IconReturn(string FileName, int IconNum)
    {
      return IconReturn(FileName, IconNum, false);
    }
  }
}
"@
if ($Host.Version.Major -le 5)
{
  Add-Type -TypeDefinition $MyCode -ReferencedAssemblies System.Drawing -Debug:$False
}
#endregion ******** [Extract.MyIcon] ********

#endregion ================ Windows APIs ================

#region >>>>>>>>>>>>>>>> My Custom Functions <<<<<<<<<<<<<<<<

#region function New-MenuItem
function New-MenuItem()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER ImageIndex
    .PARAMETER ImageKey
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER Check
    .PARAMETER ClickOnCheck
    .PARAMETER ShortcutKeys
    .PARAMETER Disable
    .PARAMETER Font
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuItem -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [parameter(Mandatory = $True, ParameterSetName = "Icon")]
    [System.Drawing.Icon]$Icon,
    [parameter(Mandatory = $True, ParameterSetName = "ImageIndex")]
    [Int]$ImageIndex,
    [parameter(Mandatory = $True, ParameterSetName = "ImageKey")]
    [String]$ImageKey,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [Switch]$Check,
    [Switch]$ClickOnCheck,
    [System.Windows.Forms.Keys]$ShortcutKeys = "None",
    [System.Drawing.Font]$Font = $MyFCGConfig.Font.Regular,
    [System.Drawing.Color]$BackColor = $MyFCGConfig.Colors.Back,
    [System.Drawing.Color]$ForeColor = $MyFCGConfig.Colors.Fore,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuItem"
  
  #region $TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]
  $TempMenuItem = New-Object -TypeName System.Windows.Forms.ToolStripMenuItem($Text)
  
  if ($Menu.GetType().Name -eq "ToolStripMenuItem")
  {
    [Void]$Menu.DropDownItems.Add($TempMenuItem)
    if ($Menu.DropDown.Items.Count -eq 1)
    {
      $Menu.DropDown.BackColor = $Menu.BackColor
      $Menu.DropDown.ForeColor = $Menu.ForeColor
      $Menu.DropDown.ImageList = $Menu.Owner.ImageList
    }
  }
  else
  {
    [Void]$Menu.Items.Add($TempMenuItem)
  }
  
  If ($PSBoundParameters.ContainsKey("Name"))
  {
    $TempMenuItem.Name = $Name
  }
  else
  {
    $TempMenuItem.Name = $Text
  }
  
  $TempMenuItem.ShortcutKeys = $ShortcutKeys
  $TempMenuItem.Tag = $Tag
  $TempMenuItem.ToolTipText = $ToolTip
  $TempMenuItem.TextAlign = $Alignment
  $TempMenuItem.Checked = $Check.IsPresent
  $TempMenuItem.CheckOnClick = $ClickOnCheck.IsPresent
  $TempMenuItem.DisplayStyle = $DisplayStyle
  $TempMenuItem.Enabled = (-not $Disable.IsPresent)
  
  if ($PSBoundParameters.ContainsKey("BackColor"))
  {
    $TempMenuItem.BackColor = $BackColor
  }
  if ($PSBoundParameters.ContainsKey("ForeColor"))
  {
    $TempMenuItem.ForeColor = $ForeColor
  }
  if ($PSBoundParameters.ContainsKey("Font"))
  {
    $TempMenuItem.Font = $Font
  }
  
  If ($PSCmdlet.ParameterSetName -eq "Default")
  {
    $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
  }
  else
  {
    Switch ($PSCmdlet.ParameterSetName)
    {
      "Icon"
      {
        $TempMenuItem.Image = $Icon
        Break
      }
      "ImageIndex"
      {
        $TempMenuItem.ImageIndex = $ImageIndex
        Break
      }
      "ImageKey"
      {
        $TempMenuItem.ImageKey = $ImageKey
        Break
      }
    }
    $TempMenuItem.ImageAlign = $Alignment
    $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
  }
  #endregion $TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]
  
  If ($PassThru.IsPresent)
  {
    $TempMenuItem
  }
  
  $TempMenuItem = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function New-MenuItem"
}
#endregion function New-MenuItem

#region function New-MenuLabel
function New-MenuLabel()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER Font
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuLabel -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [System.Drawing.Icon]$Icon,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [System.Drawing.Font]$Font = $MyFCGConfig.Font.Regular,
    [System.Drawing.Color]$BackColor = $MyFCGConfig.Colors.Back,
    [System.Drawing.Color]$ForeColor = $MyFCGConfig.Colors.Fore,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuLabel"
  
  #region $TempMenuLabel = [System.Windows.Forms.ToolStripLabel]
  $TempMenuLabel = New-Object -TypeName System.Windows.Forms.ToolStripLabel($Text)
  
  if ($Menu.GetType().Name -eq "ToolStripMenuItem")
  {
    [Void]$Menu.DropDownItems.Add($TempMenuLabel)
  }
  else
  {
    [Void]$Menu.Items.Add($TempMenuLabel)
  }
  
  If ($PSBoundParameters.ContainsKey("Name"))
  {
    $TempMenuLabel.Name = $Name
  }
  else
  {
    $TempMenuLabel.Name = $Text
  }
  
  $TempMenuLabel.TextAlign = $Alignment
  $TempMenuLabel.Tag = $Tag
  $TempMenuLabel.ToolTipText = $ToolTip
  $TempMenuLabel.DisplayStyle = $DisplayStyle
  $TempMenuLabel.Enabled = (-not $Disable.IsPresent)
  
  if ($PSBoundParameters.ContainsKey("BackColor"))
  {
    $TempMenuLabel.BackColor = $BackColor
  }
  if ($PSBoundParameters.ContainsKey("ForeColor"))
  {
    $TempMenuLabel.ForeColor = $ForeColor
  }
  if ($PSBoundParameters.ContainsKey("Font"))
  {
    $TempMenuLabel.Font = $Font
  }
  
  if ($PSBoundParameters.ContainsKey("Icon"))
  {
    $TempMenuLabel.Image = $Icon
    $TempMenuLabel.ImageAlign = $Alignment
    $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
  }
  else
  {
    $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
  }
  #endregion $TempMenuLabel = [System.Windows.Forms.ToolStripLabel]
  
  If ($PassThru)
  {
    $TempMenuLabel
  }
  
  $TempMenuLabel = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function New-MenuLabel"
}
#endregion function New-MenuLabel

#region function New-MenuSeparator
function New-MenuSeparator()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .PARAMETER Menu
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .EXAMPLE
      New-MenuSeparator -Menu $Menu
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [System.Drawing.Color]$BackColor = $MyFCGConfig.Colors.Back,
    [System.Drawing.Color]$ForeColor = $MyFCGConfig.Colors.Fore
  )
  Write-Verbose -Message "Enter Function New-MenuSeparator"
  
  #region $TempSeparator = [System.Windows.Forms.ToolStripSeparator]
  $TempSeparator = New-Object -TypeName System.Windows.Forms.ToolStripSeparator
  
  if ($Menu.GetType().Name -eq "ToolStripMenuItem")
  {
    [Void]$Menu.DropDownItems.Add($TempSeparator)
  }
  else
  {
    [Void]$Menu.Items.Add($TempSeparator)
  }
  
  $TempSeparator.Name = "TempSeparator"
  $TempSeparator.Text = "TempSeparator"
  
  if ($PSBoundParameters.ContainsKey("BackColor"))
  {
    $TempSeparator.BackColor = $BackColor
  }
  if ($PSBoundParameters.ContainsKey("ForeColor"))
  {
    $TempSeparator.ForeColor = $ForeColor
  }
  #endregion $TempSeparator = [System.Windows.Forms.ToolStripSeparator]
  
  $TempSeparator = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function New-MenuSeparator"
}
#endregion function New-MenuSeparator

#region function Decode-MyData
function Decode-MyData()
{
  <#
    .SYNOPSIS
      Decode Base64 String Data
    .DESCRIPTION
      Decode Base64 String Data
    .PARAMETER Data
      Data to Decompress
    .EXAMPLE
      Decode-MyData -Data "String"
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Switch]$AsString
  )
  Write-Verbose -Message "Enter Function Decode-MyData"
  
  $CompressedData = [System.Convert]::FromBase64String($Data)
  $MemoryStream = New-Object -TypeName System.IO.MemoryStream
  $MemoryStream.Write($CompressedData, 0, $CompressedData.Length)
  [Void]$MemoryStream.Seek(0, 0)
  $StreamReader = New-Object -TypeName System.IO.StreamReader($MemoryStream, [System.Text.Encoding]::UTF8)
  
  if ($AsString.IsPresent)
  {
    $StreamReader.ReadToEnd()
  }
  else
  {
    $ArrayList = New-Object -TypeName System.Collections.ArrayList
    $Buffer = New-Object -TypeName Char[] -ArgumentList 4096
    While ($StreamReader.EndOfStream -eq $False)
    {
      $Bytes = $StreamReader.Read($Buffer, 0, 4096)
      if ($Bytes)
      {
        $ArrayList.AddRange($Buffer[0 .. ($Bytes - 1)])
      }
    }
    $ArrayList
    $ArrayList.Clear()
  }
  
  $StreamReader.Close()
  $MemoryStream.Close()
  $MemoryStream = $Null
  $StreamReader = $Null
  $CompressedData = $Null
  $ArrayList = $Null
  $Buffer = $Null
  $Bytes = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Decode-MyData"
}
#endregion function Decode-MyData

#endregion ================ My Custom Functions ================

#region >>>>>>>>>>>>>>>> MyFCG Custom Code <<<<<<<<<<<<<<<<

#region ******** $MyFCGFormIcon ********
# Icons for Forms are 16x16
$MyFCGFormIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAi3EhFIxzJm2Pejh/kHs5f5B7OX+Qezl/kHs5f5B7OX+Qezl/j3o4f4xz
KG2LciUUAAAAAAAAAAAAAAAAjXMkFpeGU+Soo6D/qKSi/6ikov+opKL/qKSi/6ikov+opKL/qKSi/6ikov+oo6D/mIZT5I93LRYAAAAAAAAAAJB3K3azrqz/v7u6/725uP+9ubj/vbm4/725uP+9ubj/vbm4/725
uP+9ubj/v7u6/7OurP+SejF2AAAAAAAAAACXgDuHw8C//3x4d/91cXD/dXFw/3VxcP91cXD/dXFw/3VxcP91cXD/dXFw/3x4d//DwL//mYNBhwAAAAAAAAAAmoQ/h7y5uP9xbWz/cW1s/3FtbP9xbWz/cW1s/3Ft
bP9xbWz/cW1s/3FtbP9xbWz/vLm4/52HRocAAAAAAAAAAJ6IQ4e9u7n/Z2Rj/3Bta/9oaWb/ZWNh/2VhYP9lYWD/ZWFg/2VhYP9lYWD/ZWFg/727uf+hjEqHAAAAAAAAAACijEeHv7y7/2hlZP+fnZz/b4d9/11f
XP9YVVT/WFVU/1hVVP9YVVT/WFVU/1hVVP+/vLv/pZBOhwAAAAAAAAAAppBLh8C9vP+DkZn/Noaw/410HP9KVWP/JlGg/0pIR/9KSEf/SkhH/0pIR/9KSEf/wL28/6mUUocAAAAAAAAAAKmTTofCv77/oqKh/6Wo
qP+Vkor/cXBw/1dZXf9LSEf/Q0A//0NAP/9IRUT/VFJQ/8K/vv+tmFaHAAAAAAAAAACkjEB24N7d/3Bubf95d3b/eXd2/3l3dv95d3b/eXd2/3l3dv95d3b/eXd2/3Bubf/g3t3/qJJKdgAAAAAAAAAAooo+FsS1
guTu7ev/5OPj/+Tj4//k4+P/5OPj/+Tj4//k4+P/5OPj/+Tj4//u7ev/xLWD5KmSSxYAAAAAAAAAAAAAAACljkQUqpRMbbmnan+6qGx/uqhsf7qobH+6qGx/uqhsf7qobH+5p2t/q5ZPbaiSShQAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA//+sQf//rEHAA6xBgAGsQYABrEGAAaxBgAGsQYABrEGAAaxBgAGsQYABrEGAAaxBgAGsQcADrEH//6xB//+sQQ==
"@
#endregion ******** $MyFCGFormIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($MyFCGFormIcon)))

#region ******** $ExitIcon ********
$ExitIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1ToVAgWar/F0B5/wAAAFcAAABNAAAAIQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAABxQnCIfWKjvI1+x/xY8cv8AAABDAAAAPgAAADoAAAAmAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcUp/TIV6x/ylktP8VOW3/AAAALgAAACkAAAAjAAAAHgAAABgAAAAFAAAAAAAA
AAAAAAAAAAAAAAAAAAAjYLP/HlSg/yVkt/8ybrz/FDhq/wAAADgAAAAuAAAAJAAAABgAAAAJI2Cz/wAAAAAAAAAAAAAAAAAAAAAAAAAAJWS3/yFZpv8par3/O3fC/xM1Zf8AAAA4AAAALgAAACQAAAAYAAAACQ6F
RP8AcwD/AAAAAAAAAAAAAAAAAAAAAGRziP8kXqr/LG/C/0Bup/85SmL/AAAAOAAAAC4AAAAkAAAAGACUAKQAmQD/AHMA/wAAAAAAAAAAAAAAAAAAAAAqar7/J2Ov/y90yP9adpb/Tl93/wAAADgAAAAuAAAAJACE
AG8AmQD/a8lw/wBzAP8AcwD/AHMA/wBzAP8AcwD/LG3B/ylmtP8yec3/VJHV/xQ2Z/8AAAA4AAAALgB7AHcAmQD/V8Bb/0q8T/9Yw17/X8Zm/2bKbv910H3/AHMA/y1ww/8rarf/NH3Q/1yZ2/8UNmf/AAAAOAAA
AC4AmQD/fs6A/0K4Rv82tDv/PrhE/0a8TP9QwVf/Zspu/wBzAP8vcsb/LWy6/zeA0/9koOD/FDZn/wAAADgAAAAuAHsAdwCZAP+Az4L/ccp0/2zIcP93zXz/ftCC/2jJbv8AcwD/MHTI/y5uvP84gtb/YaDh/xQ2
Z/8AAAA4AAAALgAAACQAhABvAJkA/4TQhv8AmQD/AJkA/wCZAP8AmQD/AJkA/2Z2i/8vcL7/P4jZ/4m/7v8vYpa/AAAAOAAAAC4AAAAkAAAAGACUAKQAmQD/AJkA/wAAAAAAAAAAAAAAAAAAAAAxdsr/M3TA/3ey
6P9xnsO/AAMFRgAAADgAAAAuAAAAJAAAABgAAAAJEoxM/wCZAP8AAAAAAAAAAAAAAAAAAAAAMnfL/0yMz/9FgsDeAAMFRgADBUYAAAA4AAAALgAAACQAAAAYAAAACTJ3y/8AAAAAAAAAAAAAAAAAAAAAAAAAADJ3
y/8yd8v/MnfL/zJ3y/8yd8v/MnfL/zJ3y/8yd8v/MnfL/zJ3y/8yd8v/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAwP+sQYA/rEGAH6xBAB+sQQAPrEEAD6xBAACsQQAArEEAAKxBAACsQQAArEEAD6xBAA+sQQAfrEEAH6xB//+sQQ==
"@
#endregion ******** $ExitIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($ExitIcon)))

#region ******** $HelpIcon ********
$HelpIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC6XSwQvF8sgMFiLd/IZzH/0nI7/9Z7Q//UeD7/0W8yz9VyM2AAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAC2Wiswulwr38lgKP/WaCv/2nE1/998P//jiUr/6Jlb/+ypbv/kl1r/23s7z9x3NRAAAAAAAAAAAAAAAACyVykwuVkr78xbKf/SYSX/1mkq/+CPXv/w4t7/8NrM/+uWUv/vnFL/9bRu//W9
f//ffj3P23Y1EAAAAAAAAAAAs1cqz8heMf/OWiL/0mEk/9ZpKv/lrIz/8Ojo//Do6P/spnD/75pO//SlVv/5uG//8bZ3/9h0NK8AAAAArlMoYLxeM//LWyj/zlke/9FgJP/VZyn/23c7/+rFsf/qvJ3/6IxE/+yV
S//xnVH/9KNV//S2df/fjVD/03AzMKxSKK/Ia0L/ylMb/81XHf/QXiL/1GUn/+Sri//x6ur/8enp/+WGQP/pjkb/7JRK/+6YTf/unFP/56Bm/9BuMo+yWzP/0XhP/8tUHf/MVRz/z1sg/9NiJf/gmXL/8uvr//Lq
6v/mm2f/5YY//+eLQ//pjkX/6Y5F/+eZXv/MazG/tWA5/9J4Tv/QZTL/zVgh/85YHv/RXiP/1GUn/+7UyP/z7Oz/79bK/+GERP/igTz/44M+/+ODPv/iilD/yWkwv7VhO//Vflb/0GY0/9FnNP/RYy3/z10j/9Jg
JP/YdkD/8uXi//Pt7f/sx7P/3Xc1/955Nv/eeTb/3ntD/8VmL7+qUyzf2o5s/9BlNP/RZjT/0mg0/9NrNf/UajL/1Ggu/9+Saf/17+//9O7u/91/R//acDD/2nAw/9hwOP/CYy6vpUwmj9GKav/TckX/0GY0/9Fn
NP/puaL/7su7/96PZv/rwq3/9vLy//Xw8P/ei1z/2nU7/9p1O//PbTX/v2AtYKRMJSC0Yj7/3ZNy/9BlNP/WeU3//v39//z7+//7+Pj/+fb2//j19f/z4tv/1m83/9dwOP/Vbzf/v2Au77xeLBAAAAAApEslgMd9
XP/bjGn/0Gg4/9mCWv/wzr///fz8//z6+v/uy7r/2oVZ/9RrNv/UbDn/wmEv/7hbK1AAAAAAAAAAAAAAAACjSyWfw3dV/96Xd//UeE7/0Gg4/9BmNP/RZjT/0Wk4/9JuQP/QbUP/vV4x/7RZKmAAAAAAAAAAAAAA
AAAAAAAAAAAAAKNLJXCtWDLvxntZ/86DYv/XjGv/1Ihl/8h1T/+9ZTz/slcr37FWKVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApEwlEKVMJmCmTiaPqE8mv6lQJ7+rUSeArFIoUAAAAAAAAAAAAAAAAAAA
AAAAAAAA4A+sQcADrEGAAaxBgAGsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgAGsQcADrEHgB6xB8B+sQQ==
"@
#endregion ******** $HelpIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($HelpIcon)))

#region ******** $GenerateIcon ********
$GenerateIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFtUTys4My+BNTEujTUxLo01Mi6NNTIujTYyL401MS6MGhgWbQUFBSQFBQQBAAAAAAAA
AAAAAAAAAAAAAIB2bxKgmpbzy8vL/8/Pz//W1tb/3d3d/+Tk5P/q6ur/7Ozs/6aioP5zcG7OCgkJTgcGBgUAAAAAAAAAAAAAAACCeHExv728/8zMzP/RwLD/voxZ/72LWP/CubD/9vb2//b29v+dm5n/3Nzc/5iW
lOcPDg1eBwcGBQAAAAAAAAAAkndfMcGXb/+djoD/x5xw/8VmAP/FZgD/sZN3/+nSvP+5mHj/lZOR//T09P/b29v/mJaU6AsKCVAGBQUBAAAAAMV2KYrIbAr/xm4S/8p8K//grnj/4bF9/8Z1If/IbQ7/yG0N/6B9
XP/U0dD/8vLy/9bW1v93dHLSBwYGJgAAAADKcRb+15dP/9GGM//RhjT/26Fe/9uhXv/PgSv/1I5B/9aTSf++cST/19bV/97c2v/b2dj/yMXD/iEeHHidXCQS0YpD/t+tcv/gsHj/361z/9qgXP/aoFz/4LF6/+Cx
ev/fr3X/xIVH/8PAv//09PT/9vb2/+3t7f9DPzycy4A639iZUv/dqGr/2JxY/9msg//jzr3/4cq3/9emdv/an1v/3ahp/9eWTf+2gE3/6Ojo//Ly8v/p6en/Qz88nc6LTeHaoFz/3KZm/8abdf/19fX/8vLy/+7u
7v/r6ur/1KFy/9ymZv/cpWX/uIlb/9/f3//p6en/4eHh/0M/PJ3QlWPh26Jh/92naP+qjnn/7+/v//b29v/y8vL/7u7u/9Sogf/cpWX/3als/7uTb//Z2dn/4eHh/9ra2v9DPzycyIZO4eK1gv/juIX/2K5//6iR
gf/U09P/4+Hh/9SymP/Phjn/47mH/+Gyff+1hVr/1NTU/9vb2//U1NT/Qz88nLRqOE7Un2r+58OY/+W+jv/hs3z/zJRc/8qKTP/Ujj//2p9c/+bBlP/IlGT/x7Om/93d3f/X19f/0dHR/0M/O5wAAAAAz5hm/u3S
sf/u07P/5r+R/9+rbv/an1v/3qlt/+3Ssv/rzKf/voxh/9DQ0P/j4+P/3Nzc/9XV1f9CPjucAAAAAMGHY8Xz4c3/7te9/+/Xvf/37N//9urc/+vQsv/x3cX/8dzE/8iiiv/r6+v/6enp/+Pj4//Z2dn/Qz88kQAA
AAClaEgSsH5a58yqlf/Oo4X/+/fx//ju4/+uhm//y6SK/8SYe//k4uH/5OPi/9/e3f/Y19b/r6un+2liXEAAAAAAAAAAAIpqWROKeG5EnW9TedSpitvQoX7beFNBa4R0akWKenBFjYR8RY2FfkWMhHxFiH94RYZ+
dyQAAAAAwAesQYADrEGAAaxBgACsQYAArEGAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgACsQYAArEGAAKxBwAGsQQ==
"@
#endregion ******** $GenerateIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($GenerateIcon)))

#region ******** $ControlIcon ********
$ControlIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAISAkByAfIycgHyI6IB8iOyAfIjsgHyI7IB8iOyAfIjsgHyI7IB8iOyAfIjsgHyI6IB8jJyIh
JQcAAAAAJSQnBzEwM3JgX2Dfenp68oqJivOhoaHzhISE84aFhfOEhITzhIOC86Cfn/OOjo7zkZGR84iIiN08Oz5sKSgrBzAvMjZzcnL3fn5+/3V1df+ioqL/rKys/1RUVP8yMzL/Kysr/1JSUv+xsbH/nZ2d/3Z2
dv9/f3//nJub8TEwMy9QT1Bwk5OT/6Wlpf/LzMz/xcXF/3Jycv8zMzP/MDAw/zAwMP82Njb/fX19/8bGxv/IyMj/pKSk/5iXl/9JSEphZWNkdcHBwP/Ly8v/l5eX/2pqav9GRkX/RERE/0VFRf9FRUX/Q0ND/z8/
P/9ra2v/np6e/9HR0f+ysrL/RkVHZW9tbnRmZmX/YGBg/0JCQv89PT3/TE1M/1paWv9iYmL/ampq/1paWv9JSUn/PDw8/0FCQv9iYmL/Y2Nj/0VERmVzcXF0bW1s/2trav8+Pj7/PT09/2FhYf9ycnL/X19f/2dn
Zv9ycXH/aGho/1dXVv9XV1f/ZGRj/15eXf9GRUdldXJydHBvb/+FhYX/SkpK/zg4OP9vb2//i4uL/4qKiv+Kiov/i4uL/1BQUP86Ojr/UFBQ/4iIiP9ubW3/SklKZXVzcnRYWFf/Z2dn/4WFhf+Li4v/ampq/3Fx
cf+ZmZn/pqan/29vb/9ERET/Pz8//4qKi/9sbGz/VFRT/09OT2Z1c3J0bm1t/42Njf+np6f/h4eH/1tbWv9fX1//XV1d/3x8fP+FhYX/WVlZ/4yMjP+oqKj/fHx8/3Bvb/9UU1RmdHJydIKBgf96enr/tLW1/76/
vv+urq3/e3t7/2hnaP9eXl7/u7y7/66urv+/v7//qKmo/319ff+Eg4P/WlhaZnJwcHSTk5L/kJCQ/4+QkP+/v7//tra2/9nZ2f/r6+v/6enp/9LS0f+1tbX/vLy8/4+Pj/+QkJD/lpWV/11bXGZtbGx0o6Oj/6mp
qv+qqqr/qqqq/7i4uf+pqan/zc3N/8rKyv+kpKT/ubm5/6mpqf+qqqr/qqqq/6Kiov9XVVZldXR0aK6urv/AwMH/wMDB/8DAwf/AwMD/wMDA/8DAwf/AwMD/wMDA/8DAwP/AwMD/wMDB/8DAwf+lpKT/VFNUVYWE
hByioqLxv7+//83Ozv/Ozs7/zc7O/83Nzv/Nzc3/zc3N/83Nzv/Nzc7/zc3N/83Nzf+9vb3/hIOD52BfYRAAAAAAnp2dOZ+enbudm5vWt7az0sG/vM/Dwb7PxcK+z8XCv8/Dwb7PwL68z7CurNOPjo3Yg4KBtXh3
eC4AAAAAgAGsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgAGsQQ==
"@
#endregion ******** $ControlIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($ControlIcon)))

#region ******** $DialogIcon ********
$DialogIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAeVkAJHxdBaKvnGTRtKJuqZyEQGmXfzk7lXwzV5d+NlqSeC4/k3kwCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmoI9gezo2//8+/n/7urc//39+//+/v3/8e7i/8/E
o/erl12hnIVCHQAAAAAAAAAAAAAAAAAAAAAAAAAAlHszG7elctn6+PP/8O3g/+nk1P/m4M7/49zJ/+DZw//f2ML//Pv5/8q9lu2agj43AAAAAAAAAAAAAAAAAAAAAKiTV7vw7OL/8O3j/97Xu//J2vP/ZaLq/+3p
3v/k4M//08ms//Dt4//w7eP/uKd24pV8NAgAAAAAAAAAAIpuIB/JvZn/4t3L/+Ldy//Uy6n/5+z2/3+m4f/q6N3/5ODP/8/Fpv/i3cv/4t3L/9zVvv+SeS9PAAAAAAAAAACJbR80yL2a/9XOtf/VzrX/yb+X//P1
+P+EsOn/ibPk/+Tgz//MwqH/1c61/9XOtf/VzbT/kXgsYwAAAAAAAAAAiW0fCqqZYfLIv5//yL+f/7+zhv/g5/T/Q4fi/12g6P/WzrH/v7KF/8i/n//Iv5//uat+/o91Ki0AAAAAAAAAAAAAAACOdChxt6p9/7+0
jv+4qnn/8/X5/2ek6v+Qtd//x7ua/7mrfv+/tI7/vbCI/5J5MKEAAAAAAAAAAAAAAAAAAAAAAAAAAI1zJ3apl1/4u66C/7+yhf++sYP/vK+A/7epev+/s43/sKBu/pB3LZqNcycGAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAim8iIJB2LIKch0bEoIxO5aGMT+ifikrNk3szkYxyJjIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA//+sQf//rEH//6xBgB+sQeAHrEHAA6xBwAGsQYABrEGAAaxBgAGsQcADrEHgA6xB8A+sQf//rEH//6xB//+sQQ==
"@
#endregion ******** $DialogIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($DialogIcon)))

#region ******** $SourceIcon ********
$SourceIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFtUTys4My+BNTEujTUxLo01Mi6NNTIujTYyL401MS6MGhgWbQUFBSQFBQQBAAAAAAAA
AAAAAAAAAAAAAIB2bxKgmpbzy8vL/8/Pz//W1tb/3d3d/+Tk5P/q6ur/7Ozs/6aioP5zcG7OCgkJTgcGBgUAAAAAAAAAAAAAAACCeXExv728/8zMzP/S0tL/29vb/+Xl5f/v7+//9vb2//b29v+dm5n/3Nzc/5iW
lOcPDg1eBwcGBQAAAAAAAAAAhn12McHAv//MzMz/0tLS/9vb2//l5eX/7+/v//b29v/19fX/pKKg//T09P/b29v/mJaU6AsKCVAGBQUBAAAAAIN5dzHEwsH/sa+6/8fHx//a2tr/5OTk/+3t7f/19fX/6ezp/8zN
y//d29n/8vLy/9bW1v93dHLSBwYGJgAAAABQQolGXVC+/0I20P9US6r/pKOv/93d3f/n5+f/qsCs/2yldP9vr4n/jqST/8vJx//b2dj/yMXD/iEeHHguHa2BMyTI+Tou1P9iWd//RDra/zImrf9eYYv/ToFT/1Sd
ZP97xJf/keDC/2nEl/9Pilv/w8rE/+3t7f9DPzycMiC/3zssyf9rYt3/jIXo/2df3v8uIqr/JDB1/x5pJ/9SoXD/lNa4/6Pcxv9dv5T/LI1H/5+zof/p6en/Qz88nUAxyN93bdz/nJbn/6Cb6/+LhOX/QTKm/2xJ
Wf9Wcz//i8an/7Tj0f+64NL/fc2q/zOYU/+asJz/4eHh/0M/PJ1aTtLfbmXd/1NK3v9ANtv/gFiQ/7drLf/Vkkj/1JVS/6eKU/9yvZ3/asyu/2nAm/9Bn1z/la2X/9ra2v9DPzycQDLPpmdd2/90a9//jFhy/75i
B//OgCn/3KVo/+Gxe//NgzL/sFsQ/2Sfdv9dm23/S5BV/7fGuf/U1NT/Qz88nAAAAABgVbphmZLg/7+LdP/BbSD/16Ny/+fGpP/pzrT/zY1T/7tjFv+RrY7/lrqa/9Xa1v/X19f/0dHR/0M/O5wAAAAAhXuGMebk
5v/ElIL/2aBr/+S+mP/v17v/7NO4/9uoef/DbiH/vMK2/+np6f/j4+P/3Nzc/9XV1f9CPjucAAAAAIuBejHo5uX/4rWM/9OMQv/Xl0//2p9c/9mbVv/WlU7/zHoq/9fSz//u7u7/6enp/+Pj4//Z2dn/Qz88kQAA
AACKgXkNrqij5+zh2P/crX//4rF9/+e/lf/mvpL/26Rr/9/Cp//o5+b/5OPi/9/e3f/Y19b/r6un+2liXEAAAAAAAAAAAI+FfxOOhHxElINzRb+RZ1LoupDC3ad1gqKFa0WQg3hFj4d/RY2FfkWMhHxFiH94RYZ+
dyQAAAAAwAesQYADrEGAAaxBgACsQYAArEGAAKxBAACsQQAArEEAAKxBAACsQQAArEGAAKxBgACsQYAArEGAAKxBwAGsQQ==
"@
#endregion ******** $SourceIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($SourceIcon)))

#region ******** $EventIcon ********
$EventIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYODg5TLzAxjzc4OZoeHiBsAAAAHwAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABpPUVSznqWo/7W8wf+7wMb/rrO4/3J0eNwNDQ5DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABUVlisyc7V/8PKz/+5wcb/uMDF/8LK
z//HztT/f4KF5wUEBCcAAAAAAAAAAQAAABAAAAAXAAAAGAAAAAwRERFJs7i8/szT2P/Dys//xsvR/8HHzv+Gio//cXV4/8fN0/9FR0mQAAAABRgYGZQ3ODrTOTo61Tw9PdE4OjzJYGRl49Pb4P/J0tf/y9TZ/73E
yf9xc3b/VVdZ/6itsf/T2d7/iIyPyAAAAA9OT1Dhoqep/6Clp/+doaT/naGl/6Knq//R2+D/zdXc/9Tc4/+mrLD/h4uP/8rS1v/M09j/0trf/5qen8sAAAAKeX5/1PL4+f/m8fX/4u7x/8XM0f+Fioz/yM/W/9Ta
4v/b4ej/oKWq/6assf/X4Of/ytPZ/97o7f9sbnGgAAAAAGdrbsXw/P//5O/2/+34//+4wMX/P0BA/56ipf/g5+7/2N3l/6Wprf+6v8X/193k/93k7P/K0NT8HyAgOQAAAABSVFav5fD3/9rk7P/a5ez/3ejv/7e/
xP+Qlpn/tbq8/+Hn7f/R1tz/09fe/9zh5//Eys76Oz0+cwAAAAAAAAAAP0FDk9nk6f/T3uP/2OTq/6Srr/9KS0z/T1FS/0NERP90dXb/w8nN/8jP0/++xMj/c3Z43gAAAAwAAAAAAAAAADM1NnfL1Nr/0Nrf/9ji
6P9dX2H/NTU1/7fAxf9iZWb/MTEx/7W+wv/N193/0tzi/3N5e88AAAAFAAAAAAAAAAAiIyRdvcTF/9LZ2//X4OL/lJmY/z09Of90d3b/RkdD/21vbf/P19n/zNPV/8/W2P9pa2zEAAAAAAAAAAAAAAAADg4PRpKW
qP+wtsz/p67F/6mwyv+Chpz/V1ls/2Zrgv+hqL//q7HH/6uvxP+utcv/RkdPtgAAAAAAAAAAAAAAAAYGBjhJTor+a3K6/5KWxf+Slsf/lZrP/5ug0P+boND/iY3G/5GVxf9fZbD/XGOy/xkbLo0AAAAAAAAAAAAA
AAABAQArRkt+/3F3uv+2uNr/srTX/6ms1P+TmMr/ycvk/5qey/+6vd3/fIG9/1hepv8WFyWDAAAAAAAAAAAAAAAAAAAAEiUnPKU3Oli8NzpVujQ2U7k3OlS4LTBOuDU4Urg3OFO4NTdTtjs9VrYtLkq8DAwSUQAA
AAAAAAAA/wOsQf4BrEH+AKxBgACsQQAArEEAAKxBAACsQYAArEGAAaxBgAGsQYABrEGAA6xBgAOsQYADrEGAA6xBgAOsQQ==
"@
#endregion ******** $EventIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($EventIcon)))

#region ******** $ExtractIcon ********
$ExtractIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFtUTys4My+BNTEujTUxLo01Mi6NNTIujTYyL401MS6MGhgWbQUFBSQFBQQBAAAAAAAA
AAAAAAAAAAAAAIB2bxKgmpbzy8vL/8/Pz//W1tb/3d3d/+Tk5P/q6ur/7Ozs/6aioP5zcG7OCgkJTgcGBgUAAAAAAAAAAAAAAACCeXExrKuq/319ff+1tbX/hoaG/8bGxv+Tk5P/2NjY/42Njf+LiYf/3Nzc/5iW
lOcPDg1eBwcGBQAAAAAAAAAAhn12MX59e/+srKz/W1tb/76+vv9hYWH/0tLS/6ampv+ampr/pKKg//T09P/b29v/mJaU6AsKCVAGBQUBAAAAAId+dzGko6H/eHh4/6ampv+AgID/tra2/4uLi//Q0ND/j4+P/+rq
6f/e3Nr/8vLy/9bW1v93dHLSBwYGJgAAAACJf3kxu7m4/4ODg/+8vLz/kpKS/9DQ0P+Xl5f/29vb/6enp//o6Oj/oqKh/83Kyf+PjYv/tbKv/iEeHHgAAAAAioF6McnHxv+CgoL/kpKS/7a2tv+lpaX/kZGR/7Gx
sf/MzMz/cHBw/8vLy/91dXX/xMTE/5OTk/9DPzycAAAAAIyDfDHLysn/hISE/8HBwf+FhYX/vb29/3p6ev/IyMj/hoaG/6SkpP+JiYn/pqam/4eHh/+urq7/Qz88nQAAAACNhH0x29rZ/8HBwf/j4+P/vLy8/+Hh
4f/AwMD/5+fn/8DAwP/k5OT/ubm5/9fX1/+4uLj/z8/P/0M/PJ0AAAAAjoV+MeHf3v+NjY3/7+/v/4uLi/+0tLT/rKys/319ff+oqKj/oKCg/4GBgf/c3Nz/f39//9PT0/9DPzycAAAAAI6FfzHZ2Nf/jY2N/+3t
7f+Kior/urq6/6Wlpf+Ghob/oKCg/6Ojo/95eXn/2tra/3Nzc//U1NT/Qz88nAAAAACPhX8x4+Lh/9vb2//29vb/1dXV//Pz8//Ly8v/8vLy/8PDw//i4uL/wcHB/9jY2P+4uLj/0NDQ/0M/O5wAAAAAj4Z/MbKw
r/+UlJT/ycnJ/3R0dP/AwMD/kpKS/7q6uv9xcXH/19fX/2xsbP+6urr/goKC/5aWlv9CPjucAAAAAIuBejGXlZT/ysrK/8XFxf+bm5v/tbW1/8zMzP+vr6//lpaW//Ly8v+SkpL/wMDA/7CwsP+Li4v/Qz88kQAA
AACJf3gNpJ2Y56empf/k4+L/uLe2/+zs6/+mpaX/4eDg/62srP/h4N//pKSj/97d3P+VlJP/pqKf+2hhXEAAAAAAAAAAAIyDfBOOhX5Ek4qDRZOLhEWSioNFkoqDRZKJgkWQiIFFj4d/RY2FfkWMg3xFiH94RYV8
diQAAAAAwAesQYADrEGAAaxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBwAGsQQ==
"@
#endregion ******** $ExtractIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($ExtractIcon)))

#region ******** $ImageIcon ********
$ImageIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAAAACgAAABEAAAAYAAAAGgAAABoAAAAaAAAAGgAAABoAAAAaAAAAGgAAABoAAAAYAAAAEgAA
AAwAAAAAAAAABAAAAA4AAABKAAAAVAAAAFgAAABYAAAAWAAAAFgAAABYAAAAWAAAAFgAAABYAAAAVAAAAE4AAAASAAAAAAAAAAbxqWT/8atn//Gsaf/yrmz/8q5s//Kubf/yrm3/8q5t//KubP/xrGn/8atn//Gp
ZP8AAABUAAAAGAAAAAAAAAAH8ahh/+zs7P/u7u7/7u7u/+7u7v/u7u7/7u7u/+7u7v/u7u7/7u7u/+zs7P/xqGH/AAAAWAAAABoAAAAAAAAAB/CmXv/t7e3/tOf0/4jj+v+I4/r/iOP6/4jj+v+I4/r/pub3/+3t
7f/t7e3/8KZe/wAAAFgAAAAaAAAAAAAAAAfwo1n/6+vr/+fs7f+F4/r/ZuD//2bg//9m4P//ZuD//8Po8v/s7Oz/6+vr//CjWf8AAABYAAAAGgAAAAAAAAAH8KFU/+vr6//s7Oz/5+zt/4Xj+v9m4P//ZuD//4Dc
5P/x4sD/7Ozs/+rq6v/woVT/AAAAWAAAABoAAAAAAAAAB/ChVP/r6+v/7Ozs/+3t7f/q4sT/idjP/2bg///Py3T//sM5//Diwv/q6ur/8KFU/wAAAFgAAAAaAAAAAAAAAAfwo1n/7u7u/+/v7//w8PD/+dN5//jE
P/+w0Z3//8M3///DN//40nn/7Ozs//CjWf8AAABYAAAAGgAAAAAAAAAH8Kdg//Dw8P/w8PD/8fHx//nTev//wzf//8M3///DN///wzf/+dJ5/+3t7f/wp2D/AAAAWAAAABoAAAAAAAAAB/CnYP/w8PD/ZGT//2Rk
//9kZP//ZGT////DN///wzf//sM5//LkxP/t7e3/8Kdg/wAAAFcAAAAZAAAAAAAAAAfwq2j/8fHx/2Rk//9kZP//ZGT//2Rk///603r/+tN6//Pkwv/w8PD/8PDw//CraP8AAABRAAAAEwAAAAAAAAAH8bFy//Pz
8/9kZP//ZGT//2Rk//9kZP//9PT0//T09P/ysXP/8rFz//Gxcv/xsXL/AAAAFgAAAAwAAAAAAAAABvK3ff/29vb/ZGT//2Rk//9kZP//ZGT///b29v/29vb/87d+//fgzv/yt33/AAAAFgAAAAwAAAAFAAAAAAAA
AAT0vYn/+fn5//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//S+if/0von/AAAAFgAAAAwAAAAEAAAAAQAAAAAAAAAD9cWW//XFlv/1xZb/9cWW//XFlv/1xZb/9cWW//XFlv/1xZb/AAAAEwAAAAwAAAAFAAAAAQAA
AAAAAAAAAAGsQQABrEEAAaxBAAGsQQABrEEAAaxBAAGsQQABrEEAAaxBAAGsQQABrEEAAaxBAAGsQQABrEEAAaxBAAOsQQ==
"@
#endregion ******** $ImageIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($ImageIcon)))

#region ******** $DataIcon ********
$DataIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlYhxGJuNdW+ll3+qsKKM0LqtmubHvq7ty8W85r+8uNK+vLnJw8TE75yamDSenp9poqKkCQAA
AAAAAAAAkYJnPJeGaPWikXL/rp2C/7usk//Ju6b/2c/A/9DNyv/Cw8P/0tLR/+jp6f+5trH89PT0/5ydnlAAAAAAAAAAAJB/X2+Yhmb/opFy/6+eg//DtaD/z8S0/8PBv//T0c7/19jY/+Li4v/m5+f/6erq/9XV
1fG0tbaKqKiqrgAAAACZiWtvt6uW/8a9rv/MxLj/x76w/720p/+4trH/y8vM/+fo6P/V1NH/vru0/9XU1P/c3d3/1dXW/Kmqq5eMjY8E0cq/cJuQff+JfGX/iXxl/4l8Zf+dlYn/sKym/9/g4P/f397/iX1o/4l8
Zf+NhHL/0tLT/8PExPOvsLGfm5ydRbuyoxa3rp7Sjn9k/6GRdv+4qJD/t7Go/8LBwP/d3d7/29vb/9rVzv+3rqD/wLqx8dTU1f/DxMT7s7S12p6eoF6Ug2RLmIZm/aKRcv+unYL/u6yT/8a4pP/Hwrv/6+zs/+Lj
4//T0tH/19PO/9jX1P/X19f/vb2+9KqrrFycnZ4BkX9fb5iGZv+omHz/xbml/9TKu//UzcL/0tLS/9HPzf/q6ur/4+Tk/9/g4P/Y2dn/ycrK87a3uMS2t7jTmJmbA6eZgG/Duqr/wLiq/7Kolv+vpJH/r6SR/6ie
jf+1r6X/8vLy/7+9uv/b29z/v726/7y9vf2pqqs0nJ2fFgAAAADW0clhm5F//31wWP+FeF//koVt/52Qef+mmob/sauf/7+9uf+clYj/zMzN/5OKe/+4uLe+paanJgAAAAAAAAAArqOOCK+jjdCfj3L/rp2C/7us
k//Ju6b/2tDB/+zn4P/7+vj/7ern/9fSy//TzMDavrapDgAAAAAAAAAAAAAAAJF/XmeYhmb/opFy/66dgv+7rJP/ybum/9rQwf/s5+D/+/r4//Tx7f/o4dn/1su7/8a4o3cAAAAAAAAAAAAAAACUgmNvnY1u/8O4
pP/a0sX/5+HZ/+3o4f/t6eL/7Ofg/+3o4f/t6OH/7ejh/9jOvv/IuqV/AAAAAAAAAAAAAAAAvbOgcObg1//n4dj/7+vl//Ty7v/y7ur/6uTc/+Hazv/Yzr7/z8Kv/8m6pv/WzL3/3NPHfwAAAAAAAAAAAAAAANnV
zj7Uz8b12NHI/+/r5v/59/X/9PLu/+vm3//i29D/2c+//87Cr/+/sp7/x7+x+NnUzEoAAAAAAAAAAAAAAAAAAAAAycS8GNDLxG/JxLyrzcjB0M3JwebNyMDtyMO55sjCuNLEvrSuy8a+dMS+tB0AAAAAAAAAAAAA
AAAAAAAAgAOsQQADrEEAAaxBAACsQQAArEEAAKxBAACsQQAArEEAAaxBAAOsQQAHrEEAB6xBAAesQQAHrEEAB6xBgA+sQQ==
"@
#endregion ******** $DataIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($DataIcon)))

#region ******** $LibraryIcon ********
$LibraryIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFh0AAJkfAk3doYuoWyBCotbdwAEAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAWHUACmd8D1qPlF7nvbjD/6Wesv+ioSr/k5kgxVt4ABgAAAAAAAAAAAAAAAAAAAAAAAAAAF15ABFjfQhBe4w2nZuhe/G6stP/tK/j/6qxrf+RmWP/sqQr/9HFTf+koirkaH4GNwAA
AAAAAAAAAAAAAAAAAABpfRNFkpZu4rexx/+yssb/j5p2/4uMIP+skTv/uqiN/6hjTf/Bm0v/zcFK/720PvtzhgtuAAAAAAAAAAAAAAAAAAAAAJqag5Gnpn//qJhK/7qNRP/RqKv/0dbr/7vM1/+yfF7/0aeU/72O
Uf/RxVD/tZ9r/3t+OJ9deQAJAAAAAG92EEqmnFjrya+R/866wP/E3u//u9Tg/7qvnv+wlH7/vYpu/+PHrP/Rnn3/voZI/7aOmf/Hqs3/e4oOfgAAAACeWUE/rJCH4cTN2v++ysX/uJ95/6Z0WP+acW//upiU/29n
lv+LcoL/5LOG/+nIqf+7e1//tYJ0/4qbH5AAAAAAAAAAAKigjZi2moT/oXlk/5ZxeP+vlqT/4sa8/+7HpP9nfKT/EHvY/25XlP/VnHP/8dKw/9Gedf+dbTOrjFomFIFNVkGQb3jpr5Wf/8Gxv//wzrP/7cSg/6ya
oP9tfq//OGu7/yxs0v8pevr/WmOZ/8SSdP/tx6D/wXxW/atWP2FhS4QQqomQovLXr//tv5j/moiW/0d3vf89h+P/T6f6/0yb9v81c9j/NGTU/zJ0xf9AZ6z/oXVr/9iZZ/+2aEVol212AqWHhpF1irP/P3vI/zOR
8P9Tq///WKv6/06i1v9xr7D/d7y2/zqM1/83bsP/OXjH/zZpuv98ZXzpg0tXQR0llhIlQamMa63r/2K1+v9kvPX/YavL/3y2nf+x06T/3O3I/97uzf+HwrD/PJPT/zl3z/85c8L/Mm/D/ydEqYEAAAAAAAAAADE2
mi9Ibb+yW6G2/qnbmv/k8s3/3OvR/9Pmyf/W6M7/4e3N/7TYtP9lsb3/QYfV/zpywf8uR6WMAAAAAAAAAAAAAAAAAAAAACgznTFFc7TNjMiw/9bsyP/j79v/2ezK/7/itv+o2LL/dbms/0yN0vMtRaecKCyVJwAA
AAAAAAAAAAAAAAAAAAAAAAAAJCWUBi9LqYd9tLb+u+PB/3u3u/9OhrniN1ywoS08pVQnKpQUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMj2jS0ZgsZcqN6E7JCeUBwAAAAAAAAAAAAAAAAAA
AAAAAAAA+D+sQeAfrEEAD6xBAAesQYABrEEAAaxBAAGsQYAArEEAAKxBAACsQQAArEEAAKxBwACsQfAArEH4A6xB/h+sQQ==
"@
#endregion ******** $LibraryIcon ********
#$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String($LibraryIcon)))

#endregion ================ MyFCG Custom Code ================

#region >>>>>>>>>>>>>>>> Generate Script Code - MyFCG Custom Code <<<<<<<<<<<<<<<<

#region function Get-MyFormControls
function Get-MyFormControls
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Get-MyFormControls
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
  )
  Write-Verbose -Message "Enter Function Get-MyFormControls"
  
  $Assembly = [System.Reflection.Assembly]::GetAssembly("System.Windows.Forms.Form")
  $ExportedTypes = $Assembly.ExportedTypes | Where-Object -FilterScript { $PSitem.IsPublic -and $PSItem.IsClass -and (-not $PSItem.IsAbstract) -and ($PSItem.FullName -like "System.Windows.Forms*") } | Sort-Object -Property FullName
  ForEach ($ExportedType in $ExportedTypes)
  {
    if ((($ExportedType.GetInterface("IComponent")).IsPublic) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
    {
      $ExportedType
    }
    elseif ((($ExportedType.GetInterface("ISerializable")).IsPublic) -and (-not $ExportedType.FullName.EndsWith("EventHandler", [System.StringComparison]::CurrentCultureIgnoreCase)) -and (@($ExportedType.GetConstructors(("Instance", "Public"))).Count) -and (@($ExportedType.GetConstructors(("Instance", "Public")) | Where-Object -FilterScript { @($PSItem.GetParameters()).Count -eq 0 }).Count -eq 1))
    {
      $ExportedType
    }
  }
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Get-MyFormControls"
}
#endregion function Get-MyFormControls

#region function Get-MyFormControlEvents
function Get-MyFormControlEvents 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Get-MyFormControlEvents
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Object]$Control
  )
  Write-Verbose -Message "Enter Function Get-MyFormControlEvents"
  
  $Control.GetEvents() | Sort-Object -Property Name -Unique
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Get-MyFormControlEvents"
}
#endregion function Get-MyFormControlEvents

#region function Get-MyFormControlConstructors
function Get-MyFormControlConstructors 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Get-MyFormControlConstructors
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Object]$Control
  )
  Write-Verbose -Message "Enter Function Get-MyFormControlConstructors"
  
  $Control.GetConstructors(("Instance", "Public")) | Sort-Object -Property Name
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Get-MyFormControlConstructors"
}
#endregion function Get-MyFormControlConstructors

#region function Get-MyFormControlProperties
function Get-MyFormControlProperties 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Get-MyFormControlProperties
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Object]$Control
  )
  Write-Verbose -Message "Enter Function Get-MyFormControlProperties"
  
  $Control.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.CanWrite } | Sort-Object -Property Name -Unique
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Get-MyFormControlProperties"
}
#endregion function Get-MyFormControlProperties

#region function Get-MyFormControlItems
function Get-MyFormControlItems 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Get-MyFormControlItems
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [Object]$Control
  )
  Write-Verbose -Message "Enter Function Get-MyFormControlItems"
  
  $Control.GetProperties(("Instance", "Public")) | Where-Object -FilterScript { $PSItem.Name -notin @("Controls", "DataBindings") -and -not $PSItem.CanWrite -and $PSItem.PropertyType.GetInterface("ICollection").IsPublic } | Sort-Object -Property Name -Unique
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Get-MyFormControlItems"
}
#endregion function Get-MyFormControlItems


#region function Convert-MyImageToBase64
function Convert-MyImageToBase64()
{
  <#
    .SYNOPSIS
      Converts and image to base64 Text
    .DESCRIPTION
      Converts and image to base64 Text
    .PARAMETER Path
    .PARAMETER Name
    .EXAMPLE
      Convert-MyImageToBase64 -Path <String> -Name <String>
    .NOTES
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "File")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "Icon")]
    [System.Drawing.Icon]$Icon,
    [parameter(Mandatory = $True, ParameterSetName = "File")]
    [String]$Path,
    [parameter(Mandatory = $True)]
    [String]$Name,
    [int]$LineSize = 160
  )
  Write-Verbose -Message "Enter Function Convert-MyImageToBase64"
  
  $Code = New-Object -TypeName System.Text.StringBuilder
  
  $ImageName = $Name.Replace(".", "").Replace("-", "").Replace(" ", "")
  [Void]$Code.AppendLine("#region ******** `$$ImageName ********")
  [Void]$Code.AppendLine("`$$ImageName = @`"")
  $MemoryStream = New-Object -TypeName System.IO.MemoryStream
  if ($PSCmdlet.ParameterSetName -eq "File")
  {
    if ([System.IO.Path]::GetExtension($path) -eq ".ico")
    {
      $Image = New-Object -TypeName System.Drawing.Icon($Path)
      $Image.Save($MemoryStream)
    }
    else
    {
      $Image = [System.Drawing.Image]::FromFile($Path)
      $Image.Save($MemoryStream, [guid]::Parse("{b96b3cae-0728-11d3-9d7b-0000f81ef32e}"))
    }
  }
  else
  {
    $Image = $Icon
    $Image.Save($MemoryStream)
  }
  ForEach ($Line in @([System.Convert]::ToBase64String($MemoryStream.ToArray()) -split "(?<=\G.{$LineSize})(?=.)"))
  {
    [Void]$Code.AppendLine($Line)
  }
  $MemoryStream.Close()
  [Void]$Code.AppendLine("`"@")
  [Void]$Code.AppendLine("#endregion ******** `$$ImageName ********")
  if (([System.IO.Path]::GetExtension($path) -eq ".ico") -or ($PSCmdlet.ParameterSetName -eq "Icon"))
  {
    [Void]$Code.AppendLine("#`$Form.Icon = New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$$ImageName))))))")
  }
  else
  {
    [Void]$Code.AppendLine("#`$PictureBox.Image = New-Object -TypeName System.Drawing.Image((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$$ImageName))))))")
  }
  $Code.ToString()
  
  $Image = $Null
  $MemoryStream = $Null
  $Code = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Convert-MyImageToBase64"
}
#endregion function Convert-MyImageToBase64

#region function Encode-MyDataFile
function Encode-MyDataFile
{
  <#
    .SYNOPSIS
      Encode String Data
    .DESCRIPTION
      Encode String Data
    .PARAMETER Text
      Text to Encode
    .EXAMPLE
      Encode-MyDataFile -Value "String"
    .NOTES
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True, HelpMessage = "Enter Path")]
    [String]$Path,
    [parameter(Mandatory = $True, HelpMessage = "Enter Name")]
    [String]$Name,
    [int]$LineSize = 160
  )
  Write-Verbose -Message "Enter Function Encode-MyDataFile"
  
  $EncodeName = $Name.Replace(".", "").Replace("-", "").Replace(" ", "")
  $MemoryStream = New-Object -TypeName System.IO.MemoryStream
  $StreamWriter = New-Object -TypeName System.IO.StreamWriter($MemoryStream, [System.Text.Encoding]::UTF8)
  $StreamWriter.Write(([Char[]][System.IO.File]::ReadAllBytes($Path)))
  $StreamWriter.Close()
  $Code = New-Object -TypeName System.Text.StringBuilder
  
  [Void]$Code.AppendLine("#region `$$EncodeName Encodeed Data")
  [Void]$Code.AppendLine("`$$EncodeName = @`"")
  ForEach ($Line in @([System.Convert]::ToBase64String($MemoryStream.ToArray()) -split "(?<=\G.{$LineSize})(?=.)"))
  {
    [Void]$Code.AppendLine($Line)
  }
  $MemoryStream.Close()
  [Void]$Code.AppendLine("`"@")
  [Void]$Code.AppendLine("#endregion `$$EncodeName Encodeed Data")
  [Void]$Code.AppendLine("#`$DecodedData = DeEncode-MyData -Data `$$EncodeName -AsString")
  [Void]$Code.AppendLine("#[System.IO.File]::WriteAllText(`$FilePath, `$DecodedData)")
  [Void]$Code.AppendLine("#`$DecodedData = DeEncode-MyData -Data `$$EncodeName")
  [Void]$Code.AppendLine("#[System.IO.File]::WriteAllBytes(`$FilePath, `$DecodedData)")
  $Code.ToString()
  
  $EncodeName = $Null
  $MemoryStream = $Null
  $StreamWriter = $Null
  $Code = $Null
  $Line = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Encode-MyDataFile"
}
#endregion function Encode-MyDataFile


#region function Build-MyScriptHeader
function Build-MyScriptHeader 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptHeader -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptHeader"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#requires -version 3.0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("<#")
  [Void]$StringBuilder.AppendLine("  .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("  .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("  .PARAMETER <Parameter-Name>")
  [Void]$StringBuilder.AppendLine("  .EXAMPLE")
  [Void]$StringBuilder.AppendLine("  .NOTES")
  [Void]$StringBuilder.AppendLine("    My Script $($MyScriptName) Version 1.0 by $([System.Environment]::UserName) on $(([DateTime]::Now).ToString("MM/dd/yyyy"))")
  [Void]$StringBuilder.AppendLine("    Created with `"$($MyFCGConfig.ScriptName)`" Version $($MyFCGConfig.ScriptVersion)")
  [Void]$StringBuilder.AppendLine("#>")
  [Void]$StringBuilder.AppendLine("#[CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("#param (")
  [Void]$StringBuilder.AppendLine("#)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$ErrorActionPreference = `"Stop`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Comment Out `$VerbosePreference Line for Production Deployment")
  [Void]$StringBuilder.AppendLine("`$VerbosePreference = `"Continue`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Comment Out `$DebugPreference Line for Production Deployment")
  [Void]$StringBuilder.AppendLine("`$DebugPreference = `"Continue`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Clear Previous Error Messages")
  [Void]$StringBuilder.AppendLine("`$Error.Clear()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("[Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Windows.Forms`")")
  [Void]$StringBuilder.AppendLine("[Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Drawing`")")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("[System.Windows.Forms.Application]::EnableVisualStyles()")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptHeader"
}
#endregion function Build-MyScriptHeader

#region function Build-MyScriptConfig
function Build-MyScriptConfig 
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptConfig -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptConfig"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> $($MyScriptName) Configuration <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config = [Ordered]@{}")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default Form Run Mode")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Production = `$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.ScriptName = `"My Script - $($MyScriptName)`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.ScriptVersion = `"0.0.0.0`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.ScriptAuthor = `"$([System.Environment]::UserName)`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Script Runtime Values")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Is64Bit = ([IntPtr]::Size -eq 8)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default Form Settings")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FormSpacer = 4")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FormMinWidth = 60")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FormMinHeight = 35")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default Font")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FontFamily = `"Verdana`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FontSize = 10")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.FontTitle = 1.5")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default Form Color Mode")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.DarkMode = ((Get-ItemProperty -Path `"Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize`" -ErrorAction `"SilentlyContinue`").AppsUseLightTheme -eq `"0`")")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Form Auto Exit")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.AutoExitMax = 60")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.AutoExitTic = 60000")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Administrative Rights")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.IsLocalAdmin = ((New-Object -TypeName Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.IsPowerUser = ((New-Object -TypeName Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::PowerUser))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Network / Internet")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.IsConnected = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]`"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}`"))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default Script Credentials")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Domain = `"Domain`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.UserID = `"UserID`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Password = `"P@ssw0rd`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default SMTP Configuration")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.SMTPServer = `"smtp.mydomain.local`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.SMTPPort = 25")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Default SCCM Configuration")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.SCCMServer = `"MySCCM.MyDomain.Local`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.SCCMSite = `"XYZ`"")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.SCCMNamespace = `"Root\CCM\Site_XYZ`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Current DateTime Offset")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.DateTimeOffset = [System.DateTimeOffset]::Now")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Colors = @{}")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font = @{}")
  [Void]$StringBuilder.AppendLine("#endregion ================ $($MyScriptName) Configuration  ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptConfig"
}
#endregion function Build-MyScriptConfig

#region function Build-MyScriptColors
function Build-MyScriptColors ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptColors -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptColors"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Set $($MyScriptName) Default Colors <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# [System.Drawing.Color]::LightCoral")
  [Void]$StringBuilder.AppendLine("# [System.Drawing.Color]::DodgerBlue")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region Custom Colors")
  [Void]$StringBuilder.AppendLine("if (`$$($MyScriptName)Config.DarkMode)")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Back`", ([System.Drawing.Color]::FromArgb(16, 16, 16)))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Fore`", ([System.Drawing.Color]::DodgerBlue))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"LabelFore`", ([System.Drawing.Color]::DodgerBlue))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ErrorFore`", ([System.Drawing.Color]::Red))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleBack`", ([System.Drawing.Color]::DarkGray))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleFore`", ([System.Drawing.Color]::Black))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"GroupFore`", ([System.Drawing.Color]::DodgerBlue))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextBack`", ([System.Drawing.Color]::Gainsboro))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextFore`", ([System.Drawing.Color]::Black))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonBack`", ([System.Drawing.Color]::DarkGray))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonFore`", ([System.Drawing.Color]::Black))")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("else")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Back`", ([System.Drawing.Color]::White))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Fore`", ([System.Drawing.Color]::Navy))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"LabelFore`", ([System.Drawing.Color]::Navy))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ErrorFore`", ([System.Drawing.Color]::Red))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleBack`", ([System.Drawing.Color]::LightBlue))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleFore`", ([System.Drawing.Color]::Navy))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"GroupFore`", ([System.Drawing.Color]::Navy))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextBack`", ([System.Drawing.Color]::White))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextFore`", ([System.Drawing.Color]::Black))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonBack`", ([System.Drawing.Color]::Gainsboro))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonFore`", ([System.Drawing.Color]::Navy))")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion Custom Colors")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region Default Colors")
  [Void]$StringBuilder.AppendLine("<#")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Back`", ([System.Drawing.Color]::Control))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"Fore`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"LabelFore`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ErrorFore`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleBack`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TitleFore`", ([System.Drawing.Color]::Control))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"GroupFore`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextBack`", ([System.Drawing.Color]::Window))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"TextFore`", ([System.Drawing.Color]::WindowText))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonBack`", ([System.Drawing.Color]::Control))")
  [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.Colors.Add(`"ButtonFore`", ([System.Drawing.Color]::ControlText))")
  [Void]$StringBuilder.AppendLine("#>")
  [Void]$StringBuilder.AppendLine("#endregion Default Colors")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ================ Set $($MyScriptName) Default Colors ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptColors"
}
#endregion function Build-MyScriptColors

#region function Build-MyScriptFonts
function Build-MyScriptFonts ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptFonts -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptFonts"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Set $($MyScriptName) Default Font Data <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$TempBoldFont = New-Object -TypeName System.Drawing.Font(`$$($MyScriptName)Config.FontFamily, `$$($MyScriptName)Config.FontSize, [System.Drawing.FontStyle]::Bold)")
  [Void]$StringBuilder.AppendLine("`$TempGraphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)")
  [Void]$StringBuilder.AppendLine("`$TempMeasureString = `$TempGraphics.MeasureString(`"X`", `$TempBoldFont)")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Regular`", (New-Object -TypeName System.Drawing.Font(`$$($MyScriptName)Config.FontFamily, `$$($MyScriptName)Config.FontSize, [System.Drawing.FontStyle]::Regular)))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Bold`", (`$TempBoldFont))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Title`", (New-Object -TypeName System.Drawing.Font(`$$($MyScriptName)Config.FontFamily, (`$$($MyScriptName)Config.FontSize * `$$($MyScriptName)Config.FontTitle), [System.Drawing.FontStyle]::Bold)))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Ratio`", (`$TempGraphics.DpiX / 96))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Width`", ([Math]::Floor(`$TempMeasureString.Width)))")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Config.Font.Add(`"Height`", ([Math]::Ceiling(`$TempMeasureString.Height)))")
  [Void]$StringBuilder.AppendLine("`$TempBoldFont = `$Null")
  [Void]$StringBuilder.AppendLine("`$TempMeasureString = `$Null")
  [Void]$StringBuilder.AppendLine("`$TempGraphics.Dispose()")
  [Void]$StringBuilder.AppendLine("`$TempGraphics = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ================ Set $($MyScriptName) Default Font Data ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptFonts"
}
#endregion function Build-MyScriptFonts

#region function Build-MyScriptWindowsAPIs
function Build-MyScriptWindowsAPIs ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptWindowsAPIs -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptWindowsAPIs"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Windows APIs <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  
  #region ******** Win API - [Console.Window] ********
  [Void]$StringBuilder.AppendLine("#region ******** [Console.Window] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#[Void][Console.Window]::Hide()")
  [Void]$StringBuilder.AppendLine("#[Void][Console.Window]::Show()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace Console")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public class Window")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"Kernel32.dll`")]")
  [Void]$StringBuilder.AppendLine("    private static extern IntPtr GetConsoleWindow();")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"user32.dll`")]")
  [Void]$StringBuilder.AppendLine("    private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static bool Hide()")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return ShowWindowAsync(GetConsoleWindow(), 0);")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static bool Show()")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return ShowWindowAsync(GetConsoleWindow(), 5);")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("#endregion ******** [Console.Window] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region ******** [ControlBox.Menu] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# [ControlBox.Menu]::DisableFormClose(`$Form.Handle)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace ControlBox")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public class Menu")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    const int MF_BYPOSITION = 0x400;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"User32.dll`")]")
  [Void]$StringBuilder.AppendLine("    private static extern int RemoveMenu(IntPtr hMenu, int nPosition, int wFlags);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"User32.dll`")]")
  [Void]$StringBuilder.AppendLine("    private static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"User32.dll`")]")
  [Void]$StringBuilder.AppendLine("    private static extern int GetMenuItemCount(IntPtr hWnd);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static void DisableFormClose(IntPtr hWnd)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      IntPtr hMenu = GetSystemMenu(hWnd, false);")
  [Void]$StringBuilder.AppendLine("      int menuItemCount = GetMenuItemCount(hMenu);")
  [Void]$StringBuilder.AppendLine("      RemoveMenu(hMenu, menuItemCount - 1, MF_BYPOSITION);")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("#endregion ******** [ControlBox.Menu] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region ******** [User.Desktop] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# [User.Desktop]::Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace User")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public class Desktop")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"user32.dll`", SetLastError = true)]")
  [Void]$StringBuilder.AppendLine("    private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);")
  [Void]$StringBuilder.AppendLine("    private const int WM_SETTINGCHANGE = 0x1a;")
  [Void]$StringBuilder.AppendLine("    private const int SMTO_ABORTIFHUNG = 0x0002;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.Runtime.InteropServices.DllImport(`"Shell32.dll`")] ")
  [Void]$StringBuilder.AppendLine("    private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);")
  [Void]$StringBuilder.AppendLine("    public static void Refresh()")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);")
  [Void]$StringBuilder.AppendLine("      SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);    ")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("#endregion ******** [User.Desktop] ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Win API - [Console.Window] ********
  
  #region ******** Win API - [Extract.MyIcon] ********
  [Void]$StringBuilder.AppendLine("#region ******** [Extract.MyIcon] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#`$TempCount = [Extract.MyIcon]::IconCount(`"C:\Windows\System32\shell32.dll`")")
  [Void]$StringBuilder.AppendLine("#`$TempIcon = [Extract.MyIcon]::IconReturn(`"C:\Windows\System32\shell32.dll`", 1, `$False)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Drawing;")
  [Void]$StringBuilder.AppendLine("using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace Extract")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public class MyIcon")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"user32.dll`", SetLastError = true)]")
  [Void]$StringBuilder.AppendLine("    [return: MarshalAs(UnmanagedType.Bool)]")
  [Void]$StringBuilder.AppendLine("    private static extern bool DestroyIcon(IntPtr hIcon);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"shell32.dll`", CharSet = CharSet.Auto)]")
  [Void]$StringBuilder.AppendLine("    private static extern uint ExtractIconEx(string szFileName, int nIconIndex, IntPtr[] phiconLarge, IntPtr[] phiconSmall, uint nIcons);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static int IconCount(string FileName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      try")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };")
  [Void]$StringBuilder.AppendLine("        IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };")
  [Void]$StringBuilder.AppendLine("        return (int)ExtractIconEx(FileName, -1, LIcons, SIcons, 1);")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      catch")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      return 0;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static Icon IconReturn(string FileName, int IconNum, bool GetLarge)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };")
  [Void]$StringBuilder.AppendLine("      IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };")
  [Void]$StringBuilder.AppendLine("      Icon RetData = null;")
  [Void]$StringBuilder.AppendLine("      try")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        int IconCount = (int)ExtractIconEx(FileName, IconNum, LIcons, SIcons, 1);")
  [Void]$StringBuilder.AppendLine("        if (GetLarge)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (IconCount > 0 && LIcons[0] != IntPtr.Zero)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            RetData = (Icon)Icon.FromHandle(LIcons[0]).Clone();")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (IconCount > 0 && SIcons[0] != IntPtr.Zero)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            RetData = (Icon)Icon.FromHandle(SIcons[0]).Clone();")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      catch")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      finally")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        foreach (IntPtr ptr in LIcons)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (ptr != IntPtr.Zero)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            DestroyIcon(ptr);")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        foreach (IntPtr ptr in SIcons)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (ptr != IntPtr.Zero)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            DestroyIcon(ptr);")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      return RetData;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static Icon IconReturn(string FileName, int IconNum)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return IconReturn(FileName, IconNum, false);")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -ReferencedAssemblies System.Drawing -Debug:`$False")
  [Void]$StringBuilder.AppendLine("#endregion ******** [Extract.MyIcon] ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Win API - v ********
  
  #region ******** Win API - [Login.Sessions] ********
  [Void]$StringBuilder.AppendLine("#region ******** [Login.Sessions] ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#`$Sessions = [Login.Sessions]::EnumSessions()")
  [Void]$StringBuilder.AppendLine("#`$Sessions = [Login.Sessions]::EnumSessions(`"ComputerName`")")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("namespace Login")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  using System;")
  [Void]$StringBuilder.AppendLine("  using System.Collections.Generic;")
  [Void]$StringBuilder.AppendLine("  using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public class Sessions")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    public enum WTS_CONNECTSTATE_CLASS")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      WTSActive,")
  [Void]$StringBuilder.AppendLine("      WTSConnected,")
  [Void]$StringBuilder.AppendLine("      WTSConnectQuery,")
  [Void]$StringBuilder.AppendLine("      WTSShadow,")
  [Void]$StringBuilder.AppendLine("      WTSDisconnected,")
  [Void]$StringBuilder.AppendLine("      WTSIdle,")
  [Void]$StringBuilder.AppendLine("      WTSListen,")
  [Void]$StringBuilder.AppendLine("      WTSReset,")
  [Void]$StringBuilder.AppendLine("      WTSDown,")
  [Void]$StringBuilder.AppendLine("      WTSInit")
  [Void]$StringBuilder.AppendLine("    } ")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [StructLayout(LayoutKind.Sequential)]")
  [Void]$StringBuilder.AppendLine("    public struct WTS_SESSION_INFO")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      public Int32 SessionID;")
  [Void]$StringBuilder.AppendLine("      [MarshalAs(UnmanagedType.LPStr)]")
  [Void]$StringBuilder.AppendLine("      public String SessionName;")
  [Void]$StringBuilder.AppendLine("      public WTS_CONNECTSTATE_CLASS State;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"wtsapi32.dll`", SetLastError=true)]")
  [Void]$StringBuilder.AppendLine("    static extern IntPtr WTSOpenServer(string pServerName);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"wtsapi32.dll`")]")
  [Void]$StringBuilder.AppendLine("    static extern void WTSCloseServer(IntPtr hServer);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"wtsapi32.dll`", SetLastError=true)]")
  [Void]$StringBuilder.AppendLine("    static extern int WTSEnumerateSessions(System.IntPtr hServer, int Reserved, int Version, ref System.IntPtr ppSessionInfo, ref int pCount);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"wtsapi32.dll`")]")
  [Void]$StringBuilder.AppendLine("    static extern void WTSFreeMemory(IntPtr pMemory);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static List<WTS_SESSION_INFO> EnumSessions (bool All = false)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return EnumSessions(System.Environment.MachineName, All);")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public static List<WTS_SESSION_INFO> EnumSessions (string ComputerName, bool All = false)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Int32 Count = 0;")
  [Void]$StringBuilder.AppendLine("      IntPtr Computer = IntPtr.Zero;")
  [Void]$StringBuilder.AppendLine("      IntPtr SessionInfo = IntPtr.Zero;")
  [Void]$StringBuilder.AppendLine("      Int32 DataSize = Marshal.SizeOf(typeof(WTS_SESSION_INFO));")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      List<WTS_SESSION_INFO> SessionList = new List<WTS_SESSION_INFO>();")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      try")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Computer = WTSOpenServer(ComputerName);")
  [Void]$StringBuilder.AppendLine("        if (Computer !=IntPtr.Zero)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          Int64 RetValue = WTSEnumerateSessions(Computer, 0, 1, ref SessionInfo, ref Count);")
  [Void]$StringBuilder.AppendLine("          if (RetValue != 0)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            Int64 Start = (Int64)SessionInfo;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("            for (Int32 Index = 0; Index < Count; Index++)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              WTS_SESSION_INFO SessionData = (WTS_SESSION_INFO)Marshal.PtrToStructure((System.IntPtr)(Start + (DataSize * Index)), typeof(WTS_SESSION_INFO));")
  [Void]$StringBuilder.AppendLine("              if ((SessionData.State == WTS_CONNECTSTATE_CLASS.WTSActive) | All)")
  [Void]$StringBuilder.AppendLine("              {")
  [Void]$StringBuilder.AppendLine("                SessionList.Add(SessionData);")
  [Void]$StringBuilder.AppendLine("              }")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("          WTSFreeMemory(SessionInfo);")
  [Void]$StringBuilder.AppendLine("          WTSCloseServer(Computer);")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      catch")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      return SessionList;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("#endregion ******** [Login.Sessions] ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Win API - [Login.Sessions] ********
  
  #region ******** Win API - [Impersonate.User] ********
  [Void]$StringBuilder.AppendLine("#region ******** [Impersonate.User] ********")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Runtime.InteropServices;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace Impersonate")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public enum LogonType")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_INTERACTIVE = 2,")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_NETWORK = 3,")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_BATCH = 4,")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_SERVICE = 5,")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_UNLOCK = 7,")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_NETWORK_CLEARTEXT = 8, // Win2K or higher")
  [Void]$StringBuilder.AppendLine("    LOGON32_LOGON_NEW_CREDENTIALS = 9 // Win2K or higher")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public enum LogonProvider")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    LOGON32_PROVIDER_DEFAULT = 0,")
  [Void]$StringBuilder.AppendLine("    LOGON32_PROVIDER_WINNT35 = 1,")
  [Void]$StringBuilder.AppendLine("    LOGON32_PROVIDER_WINNT40 = 2,")
  [Void]$StringBuilder.AppendLine("    LOGON32_PROVIDER_WINNT50 = 3")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public class User")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [DllImport(`"advapi32.dll`", SetLastError = true, CharSet = CharSet.Unicode)]")
  [Void]$StringBuilder.AppendLine("    public static extern bool LogonUser(String lpszUsername, String lpszDomain, String lpszPassword, int dwLogonType, int dwLogonProvider, out IntPtr Token);")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("	   [DllImport(`"kernel32.dll`", SetLastError = true)]")
  [Void]$StringBuilder.AppendLine("	   public static extern bool CloseHandle(IntPtr hHandle);")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region Impersonate Example")
  [Void]$StringBuilder.AppendLine("#")
  [Void]$StringBuilder.AppendLine("#`$UserToken = [IntPtr]::Zero")
  [Void]$StringBuilder.AppendLine("#if ([Impersonate.User]::LogonUser(`$UserID, `$Domain, `$Password, 2, 0, [Ref]`$UserToken))")
  [Void]$StringBuilder.AppendLine("#{")
  [Void]$StringBuilder.AppendLine("#  Try")
  [Void]$StringBuilder.AppendLine("#  {")
  [Void]$StringBuilder.AppendLine("#    `$Impersonate = [System.Security.Principal.WindowsIdentity]::Impersonate(`$UserToken)")
  [Void]$StringBuilder.AppendLine("#    #region ******** Put Work Here ********")
  [Void]$StringBuilder.AppendLine("#    #endregion ******** Put Work Here ********")
  [Void]$StringBuilder.AppendLine("#  }")
  [Void]$StringBuilder.AppendLine("#  Catch")
  [Void]$StringBuilder.AppendLine("#  {")
  [Void]$StringBuilder.AppendLine("#  }")
  [Void]$StringBuilder.AppendLine("#  if (-not [String]::IsNullOrEmpty(`$Impersonate))")
  [Void]$StringBuilder.AppendLine("#  {")
  [Void]$StringBuilder.AppendLine("#    `$Impersonate.Undo()")
  [Void]$StringBuilder.AppendLine("#    `$Impersonate = `$Null")
  [Void]$StringBuilder.AppendLine("#  }")
  [Void]$StringBuilder.AppendLine("#  if (-not [String]::IsNullOrEmpty(`$Identity))")
  [Void]$StringBuilder.AppendLine("#  {")
  [Void]$StringBuilder.AppendLine("#    `$Identity.Dispose()")
  [Void]$StringBuilder.AppendLine("#    `$Identity = `$Null")
  [Void]$StringBuilder.AppendLine("#  }")
  [Void]$StringBuilder.AppendLine("#  [Void]([Impersonate.User]::CloseHandle(`$UserToken))")
  [Void]$StringBuilder.AppendLine("#  `$UserToken = `$Null")
  [Void]$StringBuilder.AppendLine("#}")
  [Void]$StringBuilder.AppendLine("#")
  [Void]$StringBuilder.AppendLine("#endregion Impersonate Example")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ******** [Impersonate.User] ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Win API - [Impersonate.User] ********
  
  [Void]$StringBuilder.AppendLine("#endregion ================ Windows APIs ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptWindowsAPIs"
}
#endregion function Build-MyScriptWindowsAPIs

#region function Build-MyScriptFunctions
function Build-MyScriptFunctions ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptFunctions -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptFunctions"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> My Custom Functions <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  
  #region function New-MyListItem
  [Void]$StringBuilder.AppendLine("#region function New-MyListItem")
  [Void]$StringBuilder.AppendLine("function New-MyListItem()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ListItem for a ComboBox or ListBox Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ListItem for a ComboBox or ListBox Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Value")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-MyListItem -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Control,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Value,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MyListItem`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$Control.Items.Add(([PSCustomObject]@{`"Text`" = `$Text; `"Value`" = `$Value; `"Tag`" = `$Tag}))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Control.Items.Add(([PSCustomObject]@{`"Text`" = `$Text; `"Value`" = `$Value; `"Tag`" = `$Tag}))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MyListItem`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MyListItem")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MyListItem
  
  #region function ConvertTo-MyIconImage
  [Void]$StringBuilder.AppendLine("#region function ConvertTo-MyIconImage")
  [Void]$StringBuilder.AppendLine("function ConvertTo-MyIconImage()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Convert Base 64 Encoded Imagesback to Icon / Image")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Convert Base 64 Encoded Imagesback to Icon / Image")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EncodedImage")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Image")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = ConvertTo-MyIconImage -EncodedImage `$EncodedImage")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = ConvertTo-MyIconImage -EncodedImage `$EncodedImage -Image")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$EncodedImage,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Image")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function ConvertTo-MyIconImage`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Image.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Image]::FromStream((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$EncodedImage)))))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$EncodedImage)))))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function ConvertTo-MyIconImage`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function ConvertTo-MyIconImage")
  [Void]$StringBuilder.AppendLine("")
  #endregion function ConvertTo-MyIconImage
  
  #region function New-TreeNode
  [Void]$StringBuilder.AppendLine("#region function New-TreeNode")
  [Void]$StringBuilder.AppendLine("function New-TreeNode()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New TreeNode to a TreeView Node")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New TreeNode to a TreeView Node")
  [Void]$StringBuilder.AppendLine("    .PARAMETER TreeNode")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SelectedImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER AtTop")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Checked")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Expand")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      New-TreeNode -TreeNode `$TreeNode -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Index`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$TreeNode,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.TextBack,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.TextFore,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Index`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$ImageIndex = -1,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Index`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$SelectedImageIndex = -1,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Key`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ImageKey,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Key`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$SelectedImageKey,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [switch]`$AtTop,")
  [Void]$StringBuilder.AppendLine("    [switch]`$Checked,")
  [Void]$StringBuilder.AppendLine("    [switch]`$Expand,")
  [Void]$StringBuilder.AppendLine("    [switch]`$AddChild,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-TreeNode`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempTreeNode = [System.Windows.Forms.TreeNode]")
  [Void]$StringBuilder.AppendLine("  if (`$AddChild.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode(`$Text, (New-Object -TypeName System.Windows.Forms.TreeNode(`"*`")))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode(`$Text)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$AtTop.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$TreeNode.Nodes.Insert(0, `$TempTreeNode)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$TreeNode.Nodes.Add(`$TempTreeNode)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempTreeNode.Checked = `$Checked.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$TempTreeNode.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempTreeNode.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.NodeFont = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Index`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempTreeNode.ImageIndex = `$ImageIndex")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"SelectedImageIndex`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempTreeNode.SelectedImageIndex = `$SelectedImageIndex")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempTreeNode.SelectedImageIndex = `$ImageIndex")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"Key`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempTreeNode.ImageKey = `$ImageKey")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"SelectedImageKey`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempTreeNode.SelectedImageKey = `$SelectedImageKey")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempTreeNode.SelectedImageKey = `$ImageKey")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempTreeNode = [System.Windows.Forms.TreeNode]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Expand.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode.Expand()")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTreeNode")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempTreeNode = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-TreeNode`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-TreeNode")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-TreeNode
  
  #region function New-MenuItem
  [Void]$StringBuilder.AppendLine("#region function New-MenuItem")
  [Void]$StringBuilder.AppendLine("function New-MenuItem()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuItem for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuItem for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Icon")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageKey")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DisplayStyle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Alignment")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Check")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ClickOnCheck")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ShortcutKeys")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-MenuItem -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Menu,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Icon`")]")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Icon]`$Icon,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ImageIndex`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$ImageIndex,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ImageKey`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ImageKey,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ToolStripItemDisplayStyle]`$DisplayStyle = `"Text`",")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.ContentAlignment]`$Alignment = `"MiddleCenter`",")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Disable,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Check,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$ClickOnCheck,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.Keys]`$ShortcutKeys = `"None`",")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.Back,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.Fore,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MenuItem`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem = New-Object -TypeName System.Windows.Forms.ToolStripMenuItem(`$Text)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Menu.GetType().Name -eq `"ToolStripMenuItem`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.DropDownItems.Add(`$TempMenuItem)")
  [Void]$StringBuilder.AppendLine("    if (`$Menu.DropDown.Items.Count -eq 1)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$Menu.DropDown.BackColor = `$Menu.BackColor")
  [Void]$StringBuilder.AppendLine("      `$Menu.DropDown.ForeColor = `$Menu.ForeColor")
  [Void]$StringBuilder.AppendLine("      `$Menu.DropDown.ImageList = `$Menu.Owner.ImageList")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.Items.Add(`$TempMenuItem)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.ShortcutKeys = `$ShortcutKeys")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.TextAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.Checked = `$Check.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.CheckOnClick = `$ClickOnCheck.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.DisplayStyle = `$DisplayStyle")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem.Enabled = (-not `$Disable.IsPresent)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.Font = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSCmdlet.ParameterSetName -eq `"Default`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"Icon`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuItem.Image = `$Icon")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"ImageIndex`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuItem.ImageIndex = `$ImageIndex")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"ImageKey`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuItem.ImageKey = `$ImageKey")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.ImageAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuItem")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuItem = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MenuItem`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MenuItem")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MenuItem
  
  #region function New-MenuButton
  [Void]$StringBuilder.AppendLine("#region function New-MenuButton")
  [Void]$StringBuilder.AppendLine("function New-MenuButton()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuButton for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuButton for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Icon")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageKey")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DisplayStyle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Alignment")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Check")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ClickOnCheck")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ShortcutKeys")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewButton = New-MenuButton -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Menu,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Icon`")]")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Icon]`$Icon,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ImageIndex`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$ImageIndex,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ImageKey`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ImageKey,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ToolStripButtonDisplayStyle]`$DisplayStyle = `"Text`",")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.ContentAlignment]`$Alignment = `"MiddleCenter`",")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Disable,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Check,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$ClickOnCheck,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.Keys]`$ShortcutKeys = `"None`",")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.Back,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.Fore,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MenuButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempMenuButton = [System.Windows.Forms.ToolStripButton]")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton = New-Object -TypeName System.Windows.Forms.ToolStripButton(`$Text)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [Void]`$Menu.Buttons.Add(`$TempMenuButton)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.ShortcutKeys = `$ShortcutKeys")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.TextAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.Checked = `$Check.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.CheckOnClick = `$ClickOnCheck.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.DisplayStyle = `$DisplayStyle")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton.Enabled = (-not `$Disable.IsPresent)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.Font = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSCmdlet.ParameterSetName -eq `"Default`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"Icon`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuButton.Image = `$Icon")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"ImageIndex`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuButton.ImageIndex = `$ImageIndex")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"ImageKey`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempMenuButton.ImageKey = `$ImageKey")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.ImageAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempMenuButton = [System.Windows.Forms.ToolStripButton]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuButton")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuButton = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MenuButton`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MenuButton")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MenuButton
  
  #region function New-MenuLabel
  [Void]$StringBuilder.AppendLine("#region function New-MenuLabel")
  [Void]$StringBuilder.AppendLine("function New-MenuLabel()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Icon")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DisplayStyle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Alignment")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-MenuLabel -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Menu,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Icon]`$Icon,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ToolStripItemDisplayStyle]`$DisplayStyle = `"Text`",")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.ContentAlignment]`$Alignment = `"MiddleCenter`",")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Disable,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.Back,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.Fore,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MenuLabel`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempMenuLabel = [System.Windows.Forms.ToolStripLabel]")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel = New-Object -TypeName System.Windows.Forms.ToolStripLabel(`$Text)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Menu.GetType().Name -eq `"ToolStripMenuItem`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.DropDownItems.Add(`$TempMenuLabel)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.Items.Add(`$TempMenuLabel)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel.TextAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel.DisplayStyle = `$DisplayStyle")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel.Enabled = (-not `$Disable.IsPresent)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.Font = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Icon`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.Image = `$Icon")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.ImageAlign = `$Alignment")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempMenuLabel = [System.Windows.Forms.ToolStripLabel]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempMenuLabel")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempMenuLabel = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MenuLabel`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MenuLabel")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MenuLabel
  
  #region function New-MenuSeparator
  [Void]$StringBuilder.AppendLine("#region function New-MenuSeparator")
  [Void]$StringBuilder.AppendLine("function New-MenuSeparator()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Menu")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      New-MenuSeparator -Menu `$Menu")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Menu,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.Back,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MenuSeparator`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempSeparator = [System.Windows.Forms.ToolStripSeparator]")
  [Void]$StringBuilder.AppendLine("  `$TempSeparator = New-Object -TypeName System.Windows.Forms.ToolStripSeparator")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Menu.GetType().Name -eq `"ToolStripMenuItem`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.DropDownItems.Add(`$TempSeparator)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Menu.Items.Add(`$TempSeparator)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempSeparator.Name = `"TempSeparator`"")
  [Void]$StringBuilder.AppendLine("  `$TempSeparator.Text = `"TempSeparator`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempSeparator.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempSeparator.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempSeparator = [System.Windows.Forms.ToolStripSeparator]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempSeparator = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MenuSeparator`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MenuSeparator")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MenuSeparator
  
  #region function New-ListViewItem
  [Void]$StringBuilder.AppendLine("#region function New-ListViewItem")
  [Void]$StringBuilder.AppendLine("function New-ListViewItem()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New ListViewItem to a ListView Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New ListViewItem to a ListView Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ListView")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SubItems")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IndentCount")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Imagekey")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Group")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Checked")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-ListViewItem -ListView `$listView -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ListView]`$ListView,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.TextBack,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.TextFore,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String[]]`$SubItems,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Index`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Key`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$IndentCount = 0,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Index`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$ImageIndex = -1,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Key`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ImageKey,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ListViewGroup]`$Group,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Checked,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-ListViewItem`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempListViewItem = [System.Windows.Forms.ListViewItem]")
  [Void]$StringBuilder.AppendLine("  if (`$PSCmdlet.ParameterSetName -eq `"Default`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem(`$Text, `$Group)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -eq `"Index`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem(`$Text, `$ImageIndex, `$Group)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem(`$Text, `$ImageKey, `$Group)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.IndentCount = `$IndentCount")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempListViewItem.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempListViewItem.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("  `$TempListViewItem.Checked = `$Checked.IsPresent")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.Font = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"SubItems`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem.SubItems.AddRange(`$SubItems)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempListViewItem = [System.Windows.Forms.ListViewItem]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [Void]`$ListView.Items.Add(`$TempListViewItem)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewItem")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempListViewItem = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-ListViewItem`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-ListViewItem")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-ListViewItem
  
  #region function New-ColumnHeader
  [Void]$StringBuilder.AppendLine("#region function New-ColumnHeader")
  [Void]$StringBuilder.AppendLine("function New-ColumnHeader()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ColumnHeader for a ListView Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ColumnHeader for a ListView Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ListView")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-ColumnHeader -Text `"Text`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ListView]`$ListView,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = -2,")
  [Void]$StringBuilder.AppendLine("    [switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-ColumnHeader`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempColumnHeader = [System.Windows.Forms.ColumnHeader]")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader = New-Object -TypeName System.Windows.Forms.ColumnHeader")
  [Void]$StringBuilder.AppendLine("  [Void]`$ListView.Columns.Add(`$TempColumnHeader)")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader.Text = `$Text")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader.Width = `$Width")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempColumnHeader = [System.Windows.Forms.ColumnHeader]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempColumnHeader")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempColumnHeader = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-ColumnHeader`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-ColumnHeader")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-ColumnHeader
  
  #region function New-ListViewGroup
  [Void]$StringBuilder.AppendLine("#region function New-ListViewGroup")
  [Void]$StringBuilder.AppendLine("function New-ListViewGroup()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ListViewGroup to a ListView Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and Adds a New ListViewGroup to a ListView Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Header")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Alignment")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$NewItem = New-ListViewGroup -Header `"Header`" -Tag `"Tag`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ListView]`$ListView,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Header,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.HorizontalAlignment]`$Alignment = `"Left`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-ListViewGroup`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempListViewGroup = [System.Windows.Forms.ListViewGroup]")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup = New-Object -TypeName System.Windows.Forms.ListViewGroup")
  [Void]$StringBuilder.AppendLine("  [Void]`$ListView.Groups.Add(`$TempListViewGroup)")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup.Header = `$Header")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup.Name = `$Header")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup.HeaderAlignment = `$Alignment")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempListViewGroup = [System.Windows.Forms.ListViewGroup]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempListViewGroup")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempListViewGroup = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-ListViewGroup`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-ListViewGroup")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-ListViewGroup
  
  #region function New-TabPage
  [Void]$StringBuilder.AppendLine("#region function New-TabPage")
  [Void]$StringBuilder.AppendLine("function New-TabPage()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New TabPage to a TabControl Node")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Makes and adds a New TabPage to a TabControl Node")
  [Void]$StringBuilder.AppendLine("    .PARAMETER TabControl")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BackColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ForeColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Font")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Text")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Tag")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ImageIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ToolTip")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Disabled")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$TabPage = New-TabPage -TabControl  -Text `"Text`" -Tag `"Tag`" -PassThru")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param(")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.TabControl]`$TabControl,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$BackColor = `$$($MyScriptName)Config.Colors.Back,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Color]`$ForeColor = `$$($MyScriptName)Config.Colors.Fore,")
  [Void]$StringBuilder.AppendLine("    [System.Drawing.Font]`$Font = `$$($MyScriptName)Config.Font.Regular,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Text,")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [Object]`$Tag,")
  [Void]$StringBuilder.AppendLine("    [Int]`$ImageIndex = -1,")
  [Void]$StringBuilder.AppendLine("    [String]`$ToolTip,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Disabled,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-TabPage`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$TempTabPage = [System.Windows.Forms.TabPage]")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage = New-Object -TypeName System.Windows.Forms.TabPage(`$Text)")
  [Void]$StringBuilder.AppendLine("  `$TabControl.Controls.Add(`$TempTabPage)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PSBoundParameters.ContainsKey(`"Name`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage.Name = `$Name")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage.Name = `$Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage.Tag = `$Tag")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage.ToolTipText = `$ToolTip")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage.Enabled = (-not `$Disabled.IsPresent)")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage.ImageIndex = `$ImageIndex")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"BackColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage.BackColor = `$BackColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"ForeColor`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage.ForeColor = `$ForeColor")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Font`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage.Font = `$Font")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion `$TempTabPage = [System.Windows.Forms.TabPage]")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  If (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempTabPage")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempTabPage = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-TabPage`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-TabPage")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-TabPage
  
  #region function Set-MyClipboard
  [Void]$StringBuilder.AppendLine("#region function Set-MyClipboard")
  [Void]$StringBuilder.AppendLine("function Set-MyClipboard()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Copies Object Data to the ClipBoard")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Copies Object Data to the ClipBoard")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MyData")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Title")
  [Void]$StringBuilder.AppendLine("    .PARAMETER TitleColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Columns")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ColumnColor")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RowEven")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RowOdd")
  [Void]$StringBuilder.AppendLine("    .PARAMETER OfficeFix")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyClipBoard -MyData `$MyData -Title `"This is My Title`"")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyData | Set-MyClipBoard -Title `"This is My Title`"")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyClipBoard -MyData `$MyData -Title `"This is My Title`" -Property `"Property1`", `"Property2`", `"Property3`"")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyClipBoard -MyData `$MyData -Title `"This is My Title`" -Columns ([Ordered@{`"Property1`" = `"Left`"; `"Property2`" = `"Right`"; `"Property3`" = `"Center`"})")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$MyData,")
  [Void]$StringBuilder.AppendLine("    [String]`$Title,")
  [Void]$StringBuilder.AppendLine("    [String]`$TitleColor = `"DodgerBlue`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Columns`")]")
  [Void]$StringBuilder.AppendLine("    [System.Collections.Specialized.OrderedDictionary]`$Columns,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Names`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$Property,")
  [Void]$StringBuilder.AppendLine("    [String]`$ColumnColor = `"SkyBlue`",")
  [Void]$StringBuilder.AppendLine("    [String]`$RowEven = `"White`",")
  [Void]$StringBuilder.AppendLine("    [String]`$RowOdd = `"Gainsboro`",")
  [Void]$StringBuilder.AppendLine("    [Switch]`$OfficeFix,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Set-MyClipboard Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$HTMLStringBuilder = New-Object -TypeName System.Text.StringBuilder")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Append(`"Version:1.0``r``nStartHTML:000START``r``nEndHTML:00000END``r``nStartFragment:00FSTART``r``nEndFragment:0000FEND``r``n`")")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Replace(`"000START`", (`"{0:X8}`" -f `$HTMLStringBuilder.Length))")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Append(`"<html><head><style>``r``nth { text-align: center; color: black; font: bold; background:`$ColumnColor; }``r``ntd:nth-child(1) { text-align:right; }``r``ntable, th, td { border: 1px solid black; border-collapse: collapse; }``r``ntr:nth-child(odd) {background: `$RowEven;}``r``ntr:nth-child(`$RowOdd) {background: gainsboro;}``r``n</style><title>`$Title</title></head><body><!--StartFragment-->`")")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Replace(`"00FSTART`", (`"{0:X8}`" -f `$HTMLStringBuilder.Length))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$ObjectList = New-Object -TypeName System.Collections.ArrayList")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$GetColumns = `$True")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Set-MyClipboard Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Set-MyClipboard Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$GetColumns)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$Cols = [Ordered]@{ }")
  [Void]$StringBuilder.AppendLine("      Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `"Columns`"")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$Cols = `$Columns")
  [Void]$StringBuilder.AppendLine("          Break")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        `"Names`"")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$Property | ForEach-Object -Process { `$Cols.Add(`$PSItem, `"Left`") }")
  [Void]$StringBuilder.AppendLine("          Break")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        Default")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$MyData[0].PSObject.Properties | Where-Object -FilterScript { `$PSItem.MemberType -match `"Property|NoteProperty`" } | ForEach-Object -Process { `$Cols.Add(`$PSItem.Name, `"Left`") }")
  [Void]$StringBuilder.AppendLine("          Break")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$ColNames = @(`$Cols.Keys)")
  [Void]$StringBuilder.AppendLine("      `$GetColumns = `$False")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$ObjectList.AddRange(@(`$MyData | Select-Object -Property `$ColNames))")
  [Void]$StringBuilder.AppendLine("    ")
  [Void]$StringBuilder.AppendLine("    if (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$MyData")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Set-MyClipboard Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Set-MyClipboard End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$OfficeFix.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"Title`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$HTMLStringBuilder.Append(`"<table><tr><th style='background:`$TitleColor;' colspan='`$(`$Cols.Keys.Count)'>&nbsp;`$(`$Title)&nbsp;</th></tr>`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$HTMLStringBuilder.Append(`"<table>`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      [Void]`$HTMLStringBuilder.Append((`"<tr style='background:`$ColumnColor;'><th>&nbsp;`" + (`$Cols.Keys -join `"&nbsp;</th><th>&nbsp;`") + `"&nbsp;</th></tr>`"))")
  [Void]$StringBuilder.AppendLine("      `$Row = -1")
  [Void]$StringBuilder.AppendLine("      `$RowColor = @(`$RowEven, `$RowOdd)")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Item in `$ObjectList)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$HTMLStringBuilder.Append(`"<tr style='background: `$(`$RowColor[(`$Row = (`$Row + 1) % 2)])'>`")")
  [Void]$StringBuilder.AppendLine("        ForEach (`$Key in `$Cols.Keys)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          [Void]`$HTMLStringBuilder.Append(`"<td style='text-align:`$(`$Cols[`$Key])'>&nbsp;`$(`$Item.`$Key)&nbsp;</td>`")")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        [Void]`$HTMLStringBuilder.Append(`"</tr>`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      [Void]`$HTMLStringBuilder.Append(`"</table><br><br>`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$HTMLStringBuilder.Append((`$ObjectList | ConvertTo-Html -Property `$ColNames -Fragment | Out-String))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Replace(`"0000FEND`", (`"{0:X8}`" -f `$HTMLStringBuilder.Length))")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Append(`"<!--EndFragment--></body></html>`")")
  [Void]$StringBuilder.AppendLine("    [Void]`$HTMLStringBuilder.Replace(`"00000END`", (`"{0:X8}`" -f `$HTMLStringBuilder.Length))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.Clipboard]::Clear()")
  [Void]$StringBuilder.AppendLine("    `$DataObject = New-Object -TypeName System.Windows.Forms.DataObject")
  [Void]$StringBuilder.AppendLine("    `$DataObject.SetData(`"Text`", (`$ObjectList | Select-Object -Property `$ColNames | ConvertTo-Csv -NoTypeInformation | Out-String))")
  [Void]$StringBuilder.AppendLine("    `$DataObject.SetData(`"HTML Format`", `$HTMLStringBuilder.ToString())")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.Clipboard]::SetDataObject(`$DataObject)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$ObjectList = `$Null")
  [Void]$StringBuilder.AppendLine("    `$HTMLStringBuilder = `$Null")
  [Void]$StringBuilder.AppendLine("    `$DataObject = `$Null")
  [Void]$StringBuilder.AppendLine("    `$Cols = `$Null")
  [Void]$StringBuilder.AppendLine("    `$ColNames = `$Null")
  [Void]$StringBuilder.AppendLine("    `$Row = `$Null")
  [Void]$StringBuilder.AppendLine("    `$RowColor = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Set-MyClipboard End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Set-MyClipboard")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Set-MyClipboard
  
  #region function Send-MyEMail
  [Void]$StringBuilder.AppendLine("#region function Send-MyEMail")
  [Void]$StringBuilder.AppendLine("function Send-MyEMail()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Sends an E-mail")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Sends an E-mail")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SMTPServer")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SMTPPort")
  [Void]$StringBuilder.AppendLine("    .PARAMETER To")
  [Void]$StringBuilder.AppendLine("    .PARAMETER From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Subject")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Body")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MsgFile")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IsHTML")
  [Void]$StringBuilder.AppendLine("    .PARAMETER CC")
  [Void]$StringBuilder.AppendLine("    .PARAMETER BCC")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Attachments")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Priority")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$SMTPServer = `$$($MyScriptName)Config.SMTPServer,")
  [Void]$StringBuilder.AppendLine("    [Int]`$SMTPPort = `$$($MyScriptName)Config.SMTPPort,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ValueFromPipelineByPropertyName = `$True, HelpMessage = `"Enter To`")]")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.MailAddress[]]`$To,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, HelpMessage = `"Enter From`")]")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.MailAddress]`$From,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, HelpMessage = `"Enter Subject`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Subject,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, HelpMessage = `"Enter Message Text`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Body,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$IsHTML,")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.MailAddress[]]`$CC,")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.MailAddress[]]`$BCC,")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.Attachment[]]`$Attachment,")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"Low`", `"Normal`", `"High`")]")
  [Void]$StringBuilder.AppendLine("    [System.Net.Mail.MailPriority]`$Priority = `"Normal`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin ")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Send-MyEMail Begin`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$MyMessage = New-Object -TypeName System.Net.Mail.MailMessage")
  [Void]$StringBuilder.AppendLine("    `$MyMessage.From = `$From")
  [Void]$StringBuilder.AppendLine("    `$MyMessage.Subject = `$Subject")
  [Void]$StringBuilder.AppendLine("    `$MyMessage.IsBodyHtml = `$IsHTML")
  [Void]$StringBuilder.AppendLine("    `$MyMessage.Priority = `$Priority")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"CC`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      foreach (`$SendCC in `$CC) ")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MyMessage.CC.Add(`$SendCC)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"BCC`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      foreach (`$SendBCC in `$BCC) ")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MyMessage.BCC.Add(`$SendBCC)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if ([System.IO.File]::Exists(`$Body)) ")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$MyMessage.Body = `$([System.IO.File]::ReadAllText(`$Body))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$MyMessage.Body = `$Body")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Attachment`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      foreach (`$AttachedFile in `$Attachment) ")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MyMessage.Attachments.Add(`$AttachedFile)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Send-MyEMail Begin`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process ")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Send-MyEMail Process`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$MyMessage.To.Clear()")
  [Void]$StringBuilder.AppendLine("    foreach (`$SendTo in `$To) ")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$MyMessage.To.Add(`$SendTo)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$SMTPClient = New-Object -TypeName System.Net.Mail.SmtpClient(`$SMTPServer, `$SMTPPort)")
  [Void]$StringBuilder.AppendLine("    `$SMTPClient.Send(`$MyMessage)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Send-MyEMail Process`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End ")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Send-MyEMail End`"")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Send-MyEMail End`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Send-MyEMail")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Send-MyEMail
  
  #region function Get-MyADForest
  [Void]$StringBuilder.AppendLine("#region function Get-MyADForest")
  [Void]$StringBuilder.AppendLine("function Get-MyADForest ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Get Active Directory Forest")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Get Active Directory Forest")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Current")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyADForest = Get-MyADForest -Current")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyADForest = Get-MyADForest -Name `"String`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Current`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Name`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Current`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Current")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Get-MyADForest`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Name`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContextType = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Forest")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContext = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext(`$DirectoryContextType, `$Name)")
  [Void]$StringBuilder.AppendLine("      [System.DirectoryServices.ActiveDirectory.Forest]::GetForest(`$DirectoryContext)")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContext = `$Null")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContextType = `$Null")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"Current`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Get-MyADForest`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Get-MyADForest")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Get-MyADForest
  
  #region function Get-MyADDomain
  [Void]$StringBuilder.AppendLine("#region function Get-MyADDomain")
  [Void]$StringBuilder.AppendLine("function Get-MyADDomain ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Get Active Directory Domain")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Get Active Directory Domain")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Computer")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Current")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyADForest = Get-MyADDomain -Current")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyADForest = Get-MyADDomain -Computer")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyADForest = Get-MyADDomain -Name `"String`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Current`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Name`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Computer`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Computer,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Current`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Current")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Get-MyADDomain`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Name`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContextType = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContext = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext(`$DirectoryContextType, `$Name)")
  [Void]$StringBuilder.AppendLine("      [System.DirectoryServices.ActiveDirectory.Domian]::GetDomain(`$DirectoryContext)")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContext = `$Null")
  [Void]$StringBuilder.AppendLine("      `$DirectoryContextType = `$Null")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"Computer`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()")
  [Void]$StringBuilder.AppendLine("      break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"Current`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Get-MyADDomain`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Get-MyADDomain")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Get-MyADDomain
  
  #region function Get-MyADObject
  [Void]$StringBuilder.AppendLine("#region function Get-MyADObject")
  [Void]$StringBuilder.AppendLine("function Get-MyADObject()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Searches AD and returns an AD SearchResultCollection ")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Searches AD and returns an AD SearchResultCollection ")
  [Void]$StringBuilder.AppendLine("    .PARAMETER LDAPFilter")
  [Void]$StringBuilder.AppendLine("      AD Search LDAP Filter")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PageSize")
  [Void]$StringBuilder.AppendLine("      Search Page Size")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SizeLimit")
  [Void]$StringBuilder.AppendLine("      Search Search Size")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SearchRoot")
  [Void]$StringBuilder.AppendLine("      Starting Search OU")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ServerName")
  [Void]$StringBuilder.AppendLine("      Name of DC or Domain to query")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SearchScope")
  [Void]$StringBuilder.AppendLine("      Search Scope")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sort")
  [Void]$StringBuilder.AppendLine("      Sort Direction")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SortProperty")
  [Void]$StringBuilder.AppendLine("      Property to Sort By")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PropertiesToLoad")
  [Void]$StringBuilder.AppendLine("      Properties to Load")
  [Void]$StringBuilder.AppendLine("    .PARAMETER UserName")
  [Void]$StringBuilder.AppendLine("      User Name to use when searching active directory")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Password")
  [Void]$StringBuilder.AppendLine("      Password to use when searching active directory")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Get-MyADObject [<String>]")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Get-MyADObject -filter [<String>]")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$LDAPFilter = `"(objectClass=*)`",")
  [Void]$StringBuilder.AppendLine("    [Long]`$PageSize = 1000,")
  [Void]$StringBuilder.AppendLine("    [Long]`$SizeLimit = 1000,")
  [Void]$StringBuilder.AppendLine("    [String]`$SearchRoot = `"LDAP://`$(`$([ADSI]'').distinguishedName)`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ServerName,")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"Base`", `"OneLevel`", `"Subtree`")]")
  [Void]$StringBuilder.AppendLine("    [System.DirectoryServices.SearchScope]`$SearchScope = `"SubTree`",")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"Ascending`", `"Descending`")]")
  [Void]$StringBuilder.AppendLine("    [System.DirectoryServices.SortDirection]`$Sort = `"Ascending`",")
  [Void]$StringBuilder.AppendLine("    [String]`$SortProperty,")
  [Void]$StringBuilder.AppendLine("    [String[]]`$PropertiesToLoad,")
  [Void]$StringBuilder.AppendLine("    [String]`$UserName,")
  [Void]$StringBuilder.AppendLine("    [String]`$Password")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Get-MyADObject`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$MySearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher(`$LDAPFilter, `$PropertiesToLoad, `$SearchScope)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$MySearcher.PageSize = `$PageSize")
  [Void]$StringBuilder.AppendLine("  `$MySearcher.SizeLimit = `$SizeLimit")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempSearchRoot = `$SearchRoot.ToUpper()")
  [Void]$StringBuilder.AppendLine("  Switch -regex (`$TempSearchRoot)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"(?:LDAP|GC)://*`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"ServerName`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MySearchRoot = `$TempSearchRoot -replace `"(?<LG>(?:LDAP|GC)://)(?:[\w\d\.-]+/)?(?<DN>.+)`", `"```${LG}`$ServerName/```${DN}`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MySearchRoot = `$TempSearchRoot")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    Default")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"ServerName`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MySearchRoot = `"LDAP://`$ServerName/`$TempSearchRoot`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$MySearchRoot = `"LDAP://`$TempSearchRoot`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"UserName`") -and `$PSBoundParameters.ContainsKey(`"Password`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$MySearcher.SearchRoot = New-Object -TypeName System.DirectoryServices.DirectoryEntry(`$MySearchRoot, `$UserName, `$Password)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$MySearcher.SearchRoot = New-Object -TypeName System.DirectoryServices.DirectoryEntry(`$MySearchRoot)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"SortProperty`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$MySearcher.Sort.PropertyName = `$SortProperty")
  [Void]$StringBuilder.AppendLine("    `$MySearcher.Sort.Direction = `$Sort")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$MySearcher.FindAll()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$MySearcher.Dispose()")
  [Void]$StringBuilder.AppendLine("  `$MySearcher = `$Null")
  [Void]$StringBuilder.AppendLine("  `$MySearchRoot = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempSearchRoot = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Get-MyADObject`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion  function Get-MyADObject")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Get-MyADObject
  
  #region function Translate-DomainName
  [Void]$StringBuilder.AppendLine("#region function Translate-DomainName")
  [Void]$StringBuilder.AppendLine("function Translate-DomainName()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("    .PARAMETER List")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Filter")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_1779 = 1")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_CANONICAL = 2")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_NT4 = 3")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_DISPLAY = 4")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_DOMAIN_SIMPLE = 5")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_ENTERPRISE_SIMPLE = 6")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_GUID = 7")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_UNKNOWN = 8")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_USER_PRINCIPAL_NAME = 9")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_CANONICAL_EX = 10")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_SERVICE_PRINCIPAL_NAME = 11")
  [Void]$StringBuilder.AppendLine("      ADS_NAME_TYPE_SID_OR_SID_HISTORY_NAME = 12")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"ByDN`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ByDN`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$DN,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"ByFQDN`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$FQDN")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Translate-DomainName`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$NameTranslate = New-Object -ComObject `"NameTranslate`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.Void]([System.__ComObject].InvokeMember(`"Init`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, (3, `$Null)))")
  [Void]$StringBuilder.AppendLine("  Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"ByDN`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.Void]([System.__ComObject].InvokeMember(`"Set`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, (1, `$DN)))")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"ByFQDN`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.Void]([System.__ComObject].InvokeMember(`"Set`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, (2, `"`$FQDN/`")))")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [PSCustomObject][Ordered]@{")
  [Void]$StringBuilder.AppendLine("    `"DN`" = ([System.__ComObject].InvokeMember(`"Get`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, 1));")
  [Void]$StringBuilder.AppendLine("    `"FQDN`" = ([System.__ComObject].InvokeMember(`"Get`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, 2)).Trim('/');")
  [Void]$StringBuilder.AppendLine("    `"NetBIOS`" = ([System.__ComObject].InvokeMember(`"Get`", [System.Reflection.BindingFlags]::InvokeMethod, `$Null, `$NameTranslate, 3)).Trim('\')")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$NameTranslate = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Translate-DomainName`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Translate-DomainName")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Translate-DomainName
  
  #region function Validate-MyADAccount
  [Void]$StringBuilder.AppendLine("#region function Validate-MyADAccount")
  [Void]$StringBuilder.AppendLine("function Validate-MyADAccount()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Validates AD Credentials")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Validates AD Credentials")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Domain")
  [Void]$StringBuilder.AppendLine("    .PARAMETER UserName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Password")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Validate-MyADAccount -Domain <String> -UserName <String> -Password <String>")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Validate-MyADAccount -UserName <String> -Password <String>")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Validate-MyADAccount -Password <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$Domain = [System.Environment]::UserDomainName,")
  [Void]$StringBuilder.AppendLine("    [String]`$UserName = [System.Environment]::UserName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Password")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Validate-MyADAccount`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`"System.DirectoryServices.AccountManagement.ContextType`")).Type))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [void][System.Reflection.Assembly]::LoadWithPartialName(`"System.DirectoryServices.AccountManagement`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, `$Domain).ValidateCredentials(`$UserName, `$Password)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Validate-MyADAccount`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Validate-MyADAccount")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Validate-MyADAccount
  
  #region function Open-MySQLConnection
  [Void]$StringBuilder.AppendLine("#region function Open-MySQLConnection")
  [Void]$StringBuilder.AppendLine("function Open-MySQLConnection()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Opens Connection to SQL Server Database")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Opens Connection to SQL Server Database")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ConnectionString")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Open-MySQLConnection -ConnectionString <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$ConnectionString")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Open-MySQLConnection`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`"System.Data.SqlClient.SqlConnection`")).Type))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Data`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection(`$ConnectionString)")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection.Open()")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Open-MySQLConnection`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Open-MySQLConnection")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Open-MySQLConnection
  
  #region function Invoke-MySQLCommand
  [Void]$StringBuilder.AppendLine("#region function Invoke-MySQLCommand")
  [Void]$StringBuilder.AppendLine("function Invoke-MySQLCommand ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Invokes SQL Command or Stored Procedure")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Invokes SQL Command or Stored Procedure")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SQLConnection")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Command")
  [Void]$StringBuilder.AppendLine("    .PARAMETER StoredProcedure")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SPValues")
  [Void]$StringBuilder.AppendLine("    .PARAMETER AsDataTable")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Open-MySQLConnection -ConnectionString <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Data.SqlClient.SqlConnection]`$SQLConnection,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Command,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$StoredProcedure,")
  [Void]$StringBuilder.AppendLine("    [HashTable]`$SPValues,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$AsDataTable")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Invoke-MySQLCommand`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$SQLComand = New-Object -TypeName System.Data.SqlClient.SqlCommand(`$Command, `$SQLConnection)")
  [Void]$StringBuilder.AppendLine("  if (`$StoredProcedure.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$SQLComand.CommandType = [System.Data.CommandType]::StoredProcedure")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"SPValues`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      foreach (`$SPValue in `$SPValues.Keys)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$SQLComand.Parameters.Add(`$SPValue, `$SPValues[`$SPValue])")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$SQLComand.CommandType = [System.Data.CommandType]::Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$AsDataTable.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$SQLDataAdapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter(`$SQLComand)")
  [Void]$StringBuilder.AppendLine("    `$SQLDataSet = New-Object -TypeName System.Data.DataSet")
  [Void]$StringBuilder.AppendLine("    [Void]`$SQLDataAdapter.Fill(`$SQLDataSet)")
  [Void]$StringBuilder.AppendLine("    `$SQLDataSet.Tables[0]")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    (`$TempDBReader = `$SQLComand.ExecuteReader())")
  [Void]$StringBuilder.AppendLine("    `$TempDBReader.Close()")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Invoke-MySQLCommand`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Invoke-MySQLCommand")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Invoke-MySQLCommand
  
  #region function Open-MyOracleConnection
  [Void]$StringBuilder.AppendLine("#region function Open-MyOracleConnection")
  [Void]$StringBuilder.AppendLine("function Open-MyOracleConnection()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Opens Connection to Oracle Server Database")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Opens Connection to Oracle Server Database")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ConnectionString")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Open-MyOracleConnection -ConnectionString <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$ConnectionString")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Open-MyOracleConnection`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`"System.Data.OracleClient.OracleConnection`")).Type))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Data`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection = New-Object -TypeName System.Data.OracleClient.OracleConnection(`$ConnectionString)")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection.Open()")
  [Void]$StringBuilder.AppendLine("  `$TempDBConnection")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Open-MyOracleConnection`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Open-MyOracleConnection")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Open-MyOracleConnection
  
  #region function Invoke-MyOracleCommand
  [Void]$StringBuilder.AppendLine("#region function Invoke-MyOracleCommand")
  [Void]$StringBuilder.AppendLine("function Invoke-MyOracleCommand ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Invokes Oracle Command or Stored Procedure")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Invokes Oracle Command or Stored Procedure")
  [Void]$StringBuilder.AppendLine("    .PARAMETER OracleConnection")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Command")
  [Void]$StringBuilder.AppendLine("    .PARAMETER StoredProcedure")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SPValues")
  [Void]$StringBuilder.AppendLine("    .PARAMETER AsDataTable")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Open-MyOracleConnection -ConnectionString <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Data.OracleClient.OracleConnection]`$OracleConnection,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Command,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$StoredProcedure,")
  [Void]$StringBuilder.AppendLine("    [HashTable]`$SPValues,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$AsDataTable")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Invoke-MyOracleCommand`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$OracleComand = New-Object -TypeName System.Data.OracleClient.OracleCommand(`$Command, `$OracleConnection)")
  [Void]$StringBuilder.AppendLine("  if (`$StoredProcedure.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OracleComand.CommandType = [System.Data.CommandType]::StoredProcedure")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"SPValues`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      foreach (`$SPValue in `$SPValues.Keys)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$OracleComand.Parameters.Add(`$SPValue, `$SPValues[`$SPValue])")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OracleComand.CommandType = [System.Data.CommandType]::Text")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (`$AsDataTable.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OracleDataAdapter = New-Object -TypeName System.Data.OracleClient.OracleDataAdapter(`$OracleComand)")
  [Void]$StringBuilder.AppendLine("    `$OracleDataSet = New-Object -TypeName System.Data.DataSet")
  [Void]$StringBuilder.AppendLine("    [Void]`$OracleDataAdapter.Fill(`$OracleDataSet)")
  [Void]$StringBuilder.AppendLine("    `$OracleDataSet.Tables[0]")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    (`$TempDBReader = `$OracleComand.ExecuteReader())")
  [Void]$StringBuilder.AppendLine("    `$TempDBReader.Close()")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Invoke-MyOracleCommand`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Invoke-MyOracleCommand")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Invoke-MyOracleCommand
  
  #region function New-MyComObject
  [Void]$StringBuilder.AppendLine("#region function New-MyComObject")
  [Void]$StringBuilder.AppendLine("function New-MyComObject()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates Local and Remote COMObjects")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Creates Local and Remote COMObjects")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComObject")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      New-MyComObject -ComObject <String>")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      New-MyComObject -ComputerName <String> -ComObject <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$COMObject")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function New-MyComObject`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [Activator]::CreateInstance([Type]::GetTypeFromProgID(`$COMObject, `$ComputerName))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function New-MyComObject`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function New-MyComObject")
  [Void]$StringBuilder.AppendLine("")
  #endregion function New-MyComObject
    
  #region function Encode-MyData
  [Void]$StringBuilder.AppendLine("#region function Encode-MyData")
  [Void]$StringBuilder.AppendLine("function Encode-MyData()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Encode Base64 String Data")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Encode Base64 String Data")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Data")
  [Void]$StringBuilder.AppendLine("      Data to Compress")
  [Void]$StringBuilder.AppendLine("    .PARAMETER LineLength")
  [Void]$StringBuilder.AppendLine("      Max Line Length")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Encode-MyData -Data `"String`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Data,")
  [Void]$StringBuilder.AppendLine("    [Int]`$LineLength = 160")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Encode-MyData`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream = New-Object -TypeName System.IO.MemoryStream")
  [Void]$StringBuilder.AppendLine("  `$StreamWriter = New-Object -TypeName System.IO.StreamWriter(`$MemoryStream, [System.Text.Encoding]::UTF8)")
  [Void]$StringBuilder.AppendLine("  `$StreamWriter.Write(`$Data)")
  [Void]$StringBuilder.AppendLine("  `$StreamWriter.Close()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$Code = New-Object -TypeName System.Text.StringBuilder")
  [Void]$StringBuilder.AppendLine("  ForEach (`$Line in @([System.Convert]::ToBase64String(`$MemoryStream.ToArray()) -split `"(?<=\G.{`$LineLength})(?=.)`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$Code.AppendLine(`$Line)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$Code.ToString()")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream.Close()")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream = `$Null")
  [Void]$StringBuilder.AppendLine("  `$StreamWriter = `$Null")
  [Void]$StringBuilder.AppendLine("  `$Code = `$Null")
  [Void]$StringBuilder.AppendLine("  `$Line = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Encode-MyData`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Encode-MyData")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Encode-MyData
  
  #region function Decode-MyData
  [Void]$StringBuilder.AppendLine("#region function Decode-MyData")
  [Void]$StringBuilder.AppendLine("function Decode-MyData()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Decode Base64 String Data")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Decode Base64 String Data")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Data")
  [Void]$StringBuilder.AppendLine("      Data to Decompress")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Decode-MyData -Data `"String`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Data,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$AsString")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Decode-MyData`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$CompressedData = [System.Convert]::FromBase64String(`$Data)")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream = New-Object -TypeName System.IO.MemoryStream")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream.Write(`$CompressedData, 0, `$CompressedData.Length)")
  [Void]$StringBuilder.AppendLine("  [Void]`$MemoryStream.Seek(0, 0)")
  [Void]$StringBuilder.AppendLine("  `$StreamReader = New-Object -TypeName System.IO.StreamReader(`$MemoryStream, [System.Text.Encoding]::UTF8)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$AsString.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$StreamReader.ReadToEnd()")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$ArrayList = New-Object -TypeName System.Collections.ArrayList")
  [Void]$StringBuilder.AppendLine("    `$Buffer = New-Object -TypeName Char[] -ArgumentList 4096")
  [Void]$StringBuilder.AppendLine("    While (`$StreamReader.EndOfStream -eq `$False)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$Bytes = `$StreamReader.Read(`$Buffer, 0, 4096)")
  [Void]$StringBuilder.AppendLine("      if (`$Bytes)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$ArrayList.AddRange(`$Buffer[0 .. (`$Bytes - 1)])")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$ArrayList")
  [Void]$StringBuilder.AppendLine("    `$ArrayList.Clear()")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$StreamReader.Close()")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream.Close()")
  [Void]$StringBuilder.AppendLine("  `$MemoryStream = `$Null")
  [Void]$StringBuilder.AppendLine("  `$StreamReader = `$Null")
  [Void]$StringBuilder.AppendLine("  `$CompressedData = `$Null")
  [Void]$StringBuilder.AppendLine("  `$ArrayList = `$Null")
  [Void]$StringBuilder.AppendLine("  `$Buffer = `$Null")
  [Void]$StringBuilder.AppendLine("  `$Bytes = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Decode-MyData`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Decode-MyData")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Decode-MyData
  
  #region function Encrypt-MyTextString
  [Void]$StringBuilder.AppendLine("#region function Encrypt-MyTextString")
  [Void]$StringBuilder.AppendLine("function Encrypt-MyTextString()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Encrypts a Password for use in a Script")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Encrypts a Password for use in a Script")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Password")
  [Void]$StringBuilder.AppendLine("      Password to be Encrypted")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ProtectionScope")
  [Void]$StringBuilder.AppendLine("      Who can Decrypt")
  [Void]$StringBuilder.AppendLine("        Currentuser = Specific User")
  [Void]$StringBuilder.AppendLine("        LocalMachine = Any User")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EncryptKey")
  [Void]$StringBuilder.AppendLine("      Option Extra Encryption Security")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Encrypt-MyTextString -Password `"Password`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Password,")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"LocalMachine`", `"CurrentUser`")]")
  [Void]$StringBuilder.AppendLine("    [System.Security.Cryptography.DataProtectionScope]`$ProtectionScope = `"CurrentUser`",")
  [Void]$StringBuilder.AppendLine("    [String]`$EncryptKey = `$Null")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Encrypt-MyTextString`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`"System.Security.Cryptography.ProtectedData`")).Type))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Security`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"EncryptKey`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OptionalEntropy = [System.Text.Encoding]::ASCII.GetBytes(`$EncryptKey)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OptionalEntropy = `$Null")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempData = [System.Text.Encoding]::ASCII.GetBytes(`$Password)")
  [Void]$StringBuilder.AppendLine("  `$EncryptedData = [System.Security.Cryptography.ProtectedData]::Protect(`$TempData, `$OptionalEntropy, `$ProtectionScope)")
  [Void]$StringBuilder.AppendLine("  [System.Convert]::ToBase64String(`$EncryptedData)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Encrypt-MyTextString`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Encrypt-MyTextString")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Encrypt-MyTextString
  
  #region function Decrypt-MyTextString
  [Void]$StringBuilder.AppendLine("#region function Decrypt-MyTextString")
  [Void]$StringBuilder.AppendLine("function Decrypt-MyTextString()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Decrypts a Password for use in a Script")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Decrypts a Password for use in a Script")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Password")
  [Void]$StringBuilder.AppendLine("      Password to be Decrypted")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ProtectionScope")
  [Void]$StringBuilder.AppendLine("      Who can Decrypt")
  [Void]$StringBuilder.AppendLine("        Currentuser = = Specific User")
  [Void]$StringBuilder.AppendLine("        LocalMachine = = Any User")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DecryptKey")
  [Void]$StringBuilder.AppendLine("      Option Extra Encryption Security")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Encrypt-MyTextString -Password `"Password`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Password,")
  [Void]$StringBuilder.AppendLine("    [System.Security.Cryptography.DataProtectionScope]`$ProtectionScope = `"CurrentUser`",")
  [Void]$StringBuilder.AppendLine("    [String]`$DecryptKey = `$Null")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Decrypt-MyTextString`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`"System.Security.Cryptography.ProtectedData`")).Type))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void][System.Reflection.Assembly]::LoadWithPartialName(`"System.Security`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"DecryptKey`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OptionalEntropy = [System.Text.Encoding]::ASCII.GetBytes(`$DecryptKey)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$OptionalEntropy = `$Null")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$EncryptedData = [System.Convert]::FromBase64String(`$Password)")
  [Void]$StringBuilder.AppendLine("  `$DecryptedData = [System.Security.Cryptography.ProtectedData]::Unprotect(`$EncryptedData, `$OptionalEntropy, `$ProtectionScope)")
  [Void]$StringBuilder.AppendLine("  [System.Text.Encoding]::ASCII.GetString(`$DecryptedData)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Decrypt-MyTextString`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Decrypt-MyTextString")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Decrypt-MyTextString
  
  #region function Decode-MySecureString
  [Void]$StringBuilder.AppendLine("#region function Decode-MySecureString")
  [Void]$StringBuilder.AppendLine("function Decode-MySecureString ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Decodes a SecureString")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Decodes a SecureString")
  [Void]$StringBuilder.AppendLine("    .PARAMETER SecureString")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Decode-MySecureString -SecureString [<String>]")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Security.SecureString]`$SecureString")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Get-EnvironmentVariable`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(`$SecureString))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Get-EnvironmentVariable`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Decode-MySecureString")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Decode-MySecureString
  
  #region function Send-MyTextMessage
  [Void]$StringBuilder.AppendLine("#region function Send-MyTextMessage")
  [Void]$StringBuilder.AppendLine("function Send-MyTextMessage ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Send Text Message to Remote or Local Computer or IP Address")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Send Text Message to Remote or Local Computer or IP Address")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IPAddress")
  [Void]$StringBuilder.AppendLine("      255.255.255.255 = Broadcast")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Message")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Port")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Send-MyTextMessage -Mesage [<String>]")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"IPAddress`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"ComputerName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"IPAddress`")]")
  [Void]$StringBuilder.AppendLine("    [System.Net.IPAddress]`$IPAddress = `"127.0.0.1`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Message = `"This is My Message`",")
  [Void]$StringBuilder.AppendLine("    [int]`$Port = 2500")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter function Send-MyTextMessage`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSCmdlet.ParameterSetName -eq `"IPAddress`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$RemoteClient = New-Object -TypeName System.Net.IPEndPoint(`$IPAddress, `$Port)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$RemoteClient = New-Object -TypeName System.Net.IPEndPoint((([System.Net.Dns]::GetHostByName(`$ComputerName)).AddressList[0]), `$Port)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  `$MessageBytes = [Text.Encoding]::ASCII.GetBytes(`"`$(`$Message)`")")
  [Void]$StringBuilder.AppendLine("  `$UDPClient = New-Object -TypeName System.Net.Sockets.UdpClient")
  [Void]$StringBuilder.AppendLine("  `$UDPClient.Send(`$MessageBytes, `$MessageBytes.Length, `$RemoteClient)")
  [Void]$StringBuilder.AppendLine("  `$UDPClient.Close()")
  [Void]$StringBuilder.AppendLine("  `$UDPClient.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit function Send-MyTextMessage`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Send-MyTextMessage")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Send-MyTextMessage
  
  #region function Listen-MyTextMessage
  [Void]$StringBuilder.AppendLine("#region function Listen-MyTextMessage")
  [Void]$StringBuilder.AppendLine("function Listen-MyTextMessage ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Listen for Text Message from Remote or Local Computer")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Listen for Text Message from Remote or Local Computer")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IPAddress")
  [Void]$StringBuilder.AppendLine("      0.0.0.0 = Any")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Port")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Listen-MyTextMessage")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"IPAddress`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"ComputerName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"IPAddress`")]")
  [Void]$StringBuilder.AppendLine("    [System.Net.IPAddress]`$IPAddress = `"127.0.0.1`",")
  [Void]$StringBuilder.AppendLine("    [int]`$Port = 2500")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter function Listen-MyTextMessage`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSCmdlet.ParameterSetName -eq `"IPAddress`")")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$RemoteClient = New-Object -TypeName System.Net.IPEndPoint(`$IPAddress, `$Port)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$RemoteClient = New-Object -TypeName System.Net.IPEndPoint((([System.Net.Dns]::GetHostByName(`$ComputerName)).AddressList[0]), `$Port)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  `$UDPClient = New-Object -TypeName System.Net.Sockets.UdpClient(`$Port)")
  [Void]$StringBuilder.AppendLine("  Do")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempRemoteClient = `$RemoteClient")
  [Void]$StringBuilder.AppendLine("    `$Message = `$UDPClient.Receive([ref]`$TempRemoteClient)")
  [Void]$StringBuilder.AppendLine("    `$DecodedMessage = [Text.Encoding]::ASCII.GetString(`$Message)")
  [Void]$StringBuilder.AppendLine("    Write-Host -Object  `"Message From: `$(`$TempRemoteClient.Address) - `$(`$DecodedMessage)`"")
  [Void]$StringBuilder.AppendLine("  } While (`$True -and (`$DecodedMessage -ne `"Exit`"))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit function Listen-MyTextMessage`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Listen-MyTextMessage")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Listen-MyTextMessage
  
  #region function Test-MyWorkstation
  [Void]$StringBuilder.AppendLine("#region function Test-MyWorkstation")
  [Void]$StringBuilder.AppendLine("function Test-MyWorkstation()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Verify Remote Workstation is the Correct One")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Verify Remote Workstation is the Correct One")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("      Name of the Computer to Verify")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Credential")
  [Void]$StringBuilder.AppendLine("      Credentials to use when connecting to the Remote Computer")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Wait")
  [Void]$StringBuilder.AppendLine("      How Long to Wait for Job to be Completed")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Serial")
  [Void]$StringBuilder.AppendLine("      Return Serial Number")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Mobile")
  [Void]$StringBuilder.AppendLine("      Check if System is Desktop / Laptop")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Test-MyWorkstation -ComputerName `"MyWorkstation`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ValueFromPipeline = `$True, ValueFromPipelineByPropertyName = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [PSCredential]`$Credential,")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(30, 300)]")
  [Void]$StringBuilder.AppendLine("    [Int]`$Wait = 120,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Serial,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Mobile")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Test-MyWorkstation - Begin`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Default Common Get-WmiObject Options")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Credential`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$Params = @{")
  [Void]$StringBuilder.AppendLine("        `"ComputerName`" = `$Null;")
  [Void]$StringBuilder.AppendLine("        `"Credential`" = `$Credential")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$Params = @{")
  [Void]$StringBuilder.AppendLine("        `"ComputerName`" = `$Null")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Test-MyWorkstation - Begin`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Test-MyWorkstation - Process`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Computer in `$ComputerName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Used to Calculate Verify Time")
  [Void]$StringBuilder.AppendLine("      `$StartTime = [DateTime]::Now")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Default Custom Object for the Verify Function to Return, Since it will always return a value I create the Object with the default error / failure values and update the poperties as needed")
  [Void]$StringBuilder.AppendLine("      #region >>>>>>>>>>>>>>>> Custom Return Object `$VerifyObject <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("      `$VerifyObject = [PSCustomObject]@{")
  [Void]$StringBuilder.AppendLine("        `"ComputerName`" = `$Computer.ToUpper();")
  [Void]$StringBuilder.AppendLine("        `"FQDN`" = `$Computer.ToUpper();")
  [Void]$StringBuilder.AppendLine("        `"Found`" = `$False;")
  [Void]$StringBuilder.AppendLine("        `"UserName`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Domain`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"DomainMember`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"ProductType`" = 0;")
  [Void]$StringBuilder.AppendLine("        `"Manufacturer`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Model`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"IsMobile`" = `$False;")
  [Void]$StringBuilder.AppendLine("        `"SerialNumber`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Memory`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"OperatingSystem`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"BuildNumber`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Version`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"ServicePack`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Architecture`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Is64Bit`" = `$False;")
  [Void]$StringBuilder.AppendLine("        `"LocalDateTime`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"InstallDate`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"LastBootUpTime`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"IPAddress`" = `"`";")
  [Void]$StringBuilder.AppendLine("        `"Status`" = `"Off-Line`";")
  [Void]$StringBuilder.AppendLine("        `"Time`" = [TimeSpan]::Zero")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      #endregion")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      if (`$Computer -match `"^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])`$`")")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Try")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not")
  [Void]$StringBuilder.AppendLine("          `$IPAddresses = @([System.Net.Dns]::GetHostAddresses(`$Computer) | Where-Object -FilterScript { `$_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)")
  [Void]$StringBuilder.AppendLine("          ForEach (`$IPAddress in `$IPAddresses)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            # I think this is Faster than using Test-Connection")
  [Void]$StringBuilder.AppendLine("            if (((New-Object -TypeName System.Net.NetworkInformation.Ping).Send(`$IPAddress)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              `$Params.ComputerName = `$IPAddress")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("              # Start Setting Return Values as they are Found")
  [Void]$StringBuilder.AppendLine("              `$VerifyObject.Status = `"On-Line`"")
  [Void]$StringBuilder.AppendLine("              `$VerifyObject.IPAddress = `$IPAddress")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("              # Start Primary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("              [Void](`$MyJob = Get-WmiObject -AsJob @Params -Class Win32_ComputerSystem)")
  [Void]$StringBuilder.AppendLine("              # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("              [Void](Wait-Job -Job `$MyJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("              # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("              if (`$MyJob.State -eq `"Completed`" -and `$MyJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("              {")
  [Void]$StringBuilder.AppendLine("                # Get Job Data")
  [Void]$StringBuilder.AppendLine("                `$MyCompData = Get-Job -ID `$MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                # Set Found Properties")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.ComputerName = `"`$(`$MyCompData.Name)`"")
  [Void]$StringBuilder.AppendLine("                if (`$MyCompData.PartOfDomain)")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.FQDN = `"`$(`$MyCompData.Name)``.`$(`$MyCompData.Domain)`"")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("                else")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.FQDN = `"`$(`$MyCompData.Name)`"")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.UserName = `"`$(`$MyCompData.UserName)`"")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Domain = `"`$(`$MyCompData.Domain)`"")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.DomainMember = `$MyCompData.PartOfDomain")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Manufacturer = `"`$(`$MyCompData.Manufacturer)`"")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Model = `"`$(`$MyCompData.Model)`"")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Memory = `"`$(`$MyCompData.TotalPhysicalMemory)`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                # Verify Remote Computer is the Connect Computer, No need to get any more information")
  [Void]$StringBuilder.AppendLine("                if (`$MyCompData.Name -eq @(`$Computer.Split(`".`", [System.StringSplitOptions]::RemoveEmptyEntries))[0])")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  # Found Corrct Workstation")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Found = `$True")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                  [Void](`$MyJob = Get-WmiObject -AsJob @Params -Class Win32_OperatingSystem)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                  [Void](Wait-Job -Job `$MyJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                  if (`$MyJob.State -eq `"Completed`" -and `$MyJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    # Get Job Data")
  [Void]$StringBuilder.AppendLine("                    `$MyOSData = Get-Job -ID `$MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Set Found Properties")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.ProductType = `$MyOSData.ProductType")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.OperatingSystem = `"`$(`$MyOSData.Caption)`"")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.ServicePack = `"`$(`$MyOSData.CSDVersion)`"")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.BuildNumber = `"`$(`$MyOSData.BuildNumber)`"")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Version = `"`$(`$MyOSData.Version)`"")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Architecture = `$(if ([String]::IsNullOrEmpty(`$MyOSData.OSArchitecture)) { `"32-bit`" } else { `"`$(`$MyOSData.OSArchitecture)`" })")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Is64Bit = (`$VerifyObject.Architecture -eq `"64-bit`")")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.LocalDateTime = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.LocalDateTime)")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.InstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.InstallDate)")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.LastBootUpTime = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.LastBootUpTime)")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                  else")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Status = `"Verify Operating System Error`"")
  [Void]$StringBuilder.AppendLine("                    [Void](Remove-Job -Job `$MyJob -Force)")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Optional SerialNumber Job")
  [Void]$StringBuilder.AppendLine("                  if (`$Serial.IsPresent)")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                    [Void](`$MyBIOSJob = Get-WmiObject -AsJob @Params -Class Win32_Bios)")
  [Void]$StringBuilder.AppendLine("                    # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                    [Void](Wait-Job -Job `$MyBIOSJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                    if (`$MyBIOSJob.State -eq `"Completed`" -and `$MyBIOSJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      # Get Job Data")
  [Void]$StringBuilder.AppendLine("                      `$MyBIOSData = Get-Job -ID `$MyBIOSJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                      # Set Found Property")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.SerialNumber = `"`$(`$MyBIOSData.SerialNumber)`"")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                    else")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Status = `"Verify SerialNumber Error`"")
  [Void]$StringBuilder.AppendLine("                      [Void](Remove-Job -Job `$MyBIOSJob -Force)")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Optional Mobile / ChassisType Job")
  [Void]$StringBuilder.AppendLine("                  if (`$Mobile.IsPresent)")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                    [Void](`$MyChassisJob = Get-WmiObject -AsJob @Params -Class Win32_SystemEnclosure)")
  [Void]$StringBuilder.AppendLine("                    # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                    [Void](Wait-Job -Job `$MyChassisJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                    if (`$MyChassisJob.State -eq `"Completed`" -and `$MyChassisJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      # Get Job Data")
  [Void]$StringBuilder.AppendLine("                      `$MyChassisData = Get-Job -ID `$MyChassisJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                      # Set Found Property")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.IsMobile = `$(@(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) -contains ((`$MyChassisData.ChassisTypes)[0]))")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                    else")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Status = `"Verify is Mobile Error`"")
  [Void]$StringBuilder.AppendLine("                      [Void](Remove-Job -Job `$MyChassisJob -Force)")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("                else")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Status = `"Wrong Workstation Name`"")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("              }")
  [Void]$StringBuilder.AppendLine("              else")
  [Void]$StringBuilder.AppendLine("              {")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Status = `"Verify Workstation Error`"")
  [Void]$StringBuilder.AppendLine("                [Void](Remove-Job -Job `$MyJob -Force)")
  [Void]$StringBuilder.AppendLine("              }")
  [Void]$StringBuilder.AppendLine("              # Beak out of Loop, Verify was a Success no need to try other IP Address if any")
  [Void]$StringBuilder.AppendLine("              Break")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        Catch")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          # Workstation Not in DNS")
  [Void]$StringBuilder.AppendLine("          `$VerifyObject.Status = `"Workstation Not in DNS`"")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$VerifyObject.Status = `"Invalid Computer Name`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Calculate Verify Time")
  [Void]$StringBuilder.AppendLine("      `$VerifyObject.Time = ([DateTime]::Now - `$StartTime)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Return Custom Object with Collected Verify Information")
  [Void]$StringBuilder.AppendLine("      Write-Output -InputObject `$VerifyObject")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$VerifyObject = `$Null")
  [Void]$StringBuilder.AppendLine("      `$Params = `$Null")
  [Void]$StringBuilder.AppendLine("      `$MyJob = `$Null")
  [Void]$StringBuilder.AppendLine("      `$MyCompData = `$Null")
  [Void]$StringBuilder.AppendLine("      `$MyOSData = `$Null")
  [Void]$StringBuilder.AppendLine("      `$MyBIOSData = `$Null")
  [Void]$StringBuilder.AppendLine("      `$MyChassisData = `$Null")
  [Void]$StringBuilder.AppendLine("      `$StartTime = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("      [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Test-MyWorkstation - Process`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Test-MyWorkstation - End`"")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Test-MyWorkstation - End`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Test-MyWorkstation")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Test-MyWorkstation
  
  #region function Write-MyLogFile
  [Void]$StringBuilder.AppendLine("#region function Write-MyLogFile")
  [Void]$StringBuilder.AppendLine("function Write-MyLogFile()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("    .PARAMETER LogPath")
  [Void]$StringBuilder.AppendLine("    .PARAMETER LogFolder")
  [Void]$StringBuilder.AppendLine("    .PARAMETER LogName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Severity")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Message")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Context")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Thread")
  [Void]$StringBuilder.AppendLine("    .PARAMETER StackInfo")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MaxSize")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Write-MyLogFile -LogFolder `"MyLogFolder`" -Message `"This is My Info Log File Message`"")
  [Void]$StringBuilder.AppendLine("      Write-MyLogFile -LogFolder `"MyLogFolder`" -Severity `"Info`" -Message `"This is My Info Log File Message`"")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Write-MyLogFile -LogFolder `"MyLogFolder`" -Severity `"Warning`" -Message `"This is My Warning Log File Message`"")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Write-MyLogFile -LogFolder `"MyLogFolder`" -Severity `"Error`" -Message `"This is My Error Log File Message`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"LogFolder`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$LogFolder = [System.IO.Path]::GetFileNameWithoutExtension(`$MyInvocation.ScriptName),")
  [Void]$StringBuilder.AppendLine("    [String]`$LogName = `"`$([System.IO.Path]::GetFileNameWithoutExtension(`$MyInvocation.ScriptName)).log`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"SystemLog`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$SystemLog,")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"Info`", `"Warning`", `"Error`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Severity = `"Info`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Message,")
  [Void]$StringBuilder.AppendLine("    [String]`$Context = `"`",")
  [Void]$StringBuilder.AppendLine("    [Int]`$Thread = `$PID,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$StackInfo,")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(0, 16777216)]")
  [Void]$StringBuilder.AppendLine("    [Int]`$MaxSize = 5242880")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Write-MyLogFile`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"LogFolder`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$LogPath = `$LogFolder")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `"SystemLog`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$LogPath = `"`$(`$ENV:SystemRoot)\Logs\`$LogFolder`"")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    Default")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$LogPath = `"`$PSScriptRoot\Logs`"")
  [Void]$StringBuilder.AppendLine("      Break")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  if (-not [System.IO.Directory]::Exists(`$LogPath))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void][System.IO.Directory]::CreateDirectory(`$LogPath)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  `$TempFile = `"`$LogPath\`$LogName`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Switch (`$Severity)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Info`" { `$TempSeverity = 1; Break }")
  [Void]$StringBuilder.AppendLine("    `"Warning`" { `$TempSeverity = 2; Break }")
  [Void]$StringBuilder.AppendLine("    `"Error`" { `$TempSeverity = 3; Break }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempDate = [DateTime]::Now")
  [Void]$StringBuilder.AppendLine("  `$TempSource = [System.IO.Path]::GetFileName(`$MyInvocation.ScriptName)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$StackInfo.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempStack = @(Get-PSCallStack)")
  [Void]$StringBuilder.AppendLine("    `$TempCommand = `$TempCommand = [System.IO.Path]::GetFileNameWithoutExtension(`$TempStack[1].Command)")
  [Void]$StringBuilder.AppendLine("    `$TempSource = `"Line: `$(`$TempStack[1].ScriptLineNumber) - Scope: `$(`$TempStack.Count - 3)`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempCommand = [System.IO.Path]::GetFileNameWithoutExtension(`$TempSource)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([System.IO.File]::Exists(`$TempFile) -and `$MaxSize -gt 0)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (([System.IO.FileInfo]`$TempFile).Length -gt `$MaxSize)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempBackup = [System.IO.Path]::ChangeExtension(`$TempFile, `"lo_`")")
  [Void]$StringBuilder.AppendLine("      if ([System.IO.File]::Exists(`$TempBackup))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Remove-Item -Force -Path `$TempBackup")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Rename-Item -Force -Path `$TempFile -NewName ([System.IO.Path]::GetFileName(`$TempBackup))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Add-Content -Path `$TempFile -Value (`"<![LOG[{0}]LOG]!><time=```"{1}```" date=```"{2}```" component=```"{3}```" context=```"{4}```" type=```"{5}```" thread=```"{6}```" file=```"{7}```">`" -f `$Message, `$(`$TempDate.ToString(`"HH:mm:ss.fff+000`")), `$(`$TempDate.ToString(`"MM-dd-yyyy`")), `$TempCommand, `$Context, `$TempSeverity, `$Thread, `$TempSource)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempFile = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempBackup = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempSeverity = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempDate = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempSource = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempCommand = `$Null")
  [Void]$StringBuilder.AppendLine("  `$TempStack = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Write-MyLogFile`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Write-MyLogFile")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Write-MyLogFile
  
  #region function Set-MyISScriptData
  [Void]$StringBuilder.AppendLine("#region function Set-MyISScriptData")
  [Void]$StringBuilder.AppendLine("function Set-MyISScriptData()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Writes Script Data to the Registry")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Writes Script Data to the Registry")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Script")
  [Void]$StringBuilder.AppendLine("     Name of the Regsitry Key to write the values under. Defaults to the name of the script.")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("     Name of the Value to write")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Value")
  [Void]$StringBuilder.AppendLine("      The Data to write")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MultiValue")
  [Void]$StringBuilder.AppendLine("      Write Multiple values to the Registry")
  [Void]$StringBuilder.AppendLine("    .PARAMETER User")
  [Void]$StringBuilder.AppendLine("      Write to the HKCU Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Computer")
  [Void]$StringBuilder.AppendLine("      Write to the HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Bitness")
  [Void]$StringBuilder.AppendLine("      Specify 32/64 bit HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyISScriptData -Name `"Name`" -Value `"Value`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write REG_SZ value to the HKCU Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyISScriptData -Name `"Name`" -Value @(`"This`", `"That`") -User -Script `"ScriptName`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write REG_MULTI_SZ value to the HKCU Registry Hive under the Specified Script Name registry key")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Single element arrays will be written as REG_SZ. To ensure they are written as REG_MULTI_SZ")
  [Void]$StringBuilder.AppendLine("      Use @() or (,) when specifing the Value paramter value")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyISScriptData -Name `"Name`" -Value (,8) -Bitness `"64`" -Computer")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write REG_MULTI_SZ value to the 64 bit HKLM Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Number arrays are written to the registry as strings.")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyISScriptData -Name `"Name`" -Value 0 -Computer")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write REG_DWORD value to the HKLM Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-MyISScriptData -MultiValue @{`"Name`" = `"MyName`"; `"Number`" = 4; `"Array`" = @(`"First`", 2, `"3rd`", 4)} -Computer -Bitness `"32`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write multiple values to the 32 bit HKLM Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$Script = [System.IO.Path]::GetFileNameWithoutExtension(`$MyInvocation.ScriptName),")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Name,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [Object]`$Value,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"UserMulti`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"CompMulti`")]")
  [Void]$StringBuilder.AppendLine("    [HashTable]`$MultiValue,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"UserMulti`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$User,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"CompMulti`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Computer,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"CompMulti`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"32`", `"64`", `"All`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Bitness = `"All`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Set-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Get Default Registry Paths")
  [Void]$StringBuilder.AppendLine("  `$RegPaths = New-Object -TypeName System.Collections.ArrayList")
  [Void]$StringBuilder.AppendLine("  if (`$Computer.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$Bitness -match `"All|32`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$RegPaths.Add(`"Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if (`$Bitness -match `"All|64`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$RegPaths.Add(`"Registry::HKEY_LOCAL_MACHINE\Software`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$RegPaths.Add(`"Registry::HKEY_CURRENT_USER\Software`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Create the Registry Keys if Needed.")
  [Void]$StringBuilder.AppendLine("  ForEach (`$RegPath in `$RegPaths)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if ([String]::IsNullOrEmpty((Get-Item -Path `"`$RegPath\MyISScriptData`" -ErrorAction `"SilentlyContinue`")))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Try")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void](New-Item -Path `$RegPath -Name `"MyISScriptData`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Catch")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Throw `"Error Creating Registry Key : MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if ([String]::IsNullOrEmpty((Get-Item -Path `"`$RegPath\MyISScriptData\`$Script`" -ErrorAction `"SilentlyContinue`")))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Try")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void](New-Item -Path `"`$RegPath\MyISScriptData`" -Name `$Script)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Catch")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Throw `"Error Creating Registry Key : `$Script`"")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Write the values to the registry.")
  [Void]$StringBuilder.AppendLine("  Switch -regex (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Multi`"")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Key in `$MultiValue.Keys)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        if (`$MultiValue[`$Key] -is [Array])")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$Data = [String[]]`$MultiValue[`$Key]")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$Data = `$MultiValue[`$Key]")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        ForEach (`$RegPath in `$RegPaths)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          [Void](Set-ItemProperty -Path `"`$RegPath\MyISScriptData\`$Script`" -Name `$Key -Value `$Data)")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    Default")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$Value -is [Array])")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$Data = [String[]]`$Value")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$Data = `$Value")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      ForEach (`$RegPath in `$RegPaths)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void](Set-ItemProperty -Path `"`$RegPath\MyISScriptData\`$Script`" -Name `$Name -Value `$Data)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Set-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Set-MyISScriptData")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Set-MyISScriptData
  
  #region function Get-MyISScriptData
  [Void]$StringBuilder.AppendLine("#region function Get-MyISScriptData")
  [Void]$StringBuilder.AppendLine("function Get-MyISScriptData()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Reads Script Data from the Registry")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Reads Script Data from the Registry")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Script")
  [Void]$StringBuilder.AppendLine("     Name of the Regsitry Key to read the values from. Defaults to the name of the script.")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("     Name of the Value to read")
  [Void]$StringBuilder.AppendLine("    .PARAMETER User")
  [Void]$StringBuilder.AppendLine("      Read from the HKCU Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Computer")
  [Void]$StringBuilder.AppendLine("      Read from the HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Bitness")
  [Void]$StringBuilder.AppendLine("      Specify 32/64 bit HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$RegValues = Get-MyISScriptData -Name `"Name`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Read the value from the HKCU Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$RegValues = Get-MyISScriptData -Name `"Name`" -User -Script `"ScriptName`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Read the value from the HKCU Registry Hive under the Specified Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$RegValues = Get-MyISScriptData -Name `"Name`" -Computer")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Read the value from the 64 bit HKLM Registry Hive under the Default Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$RegValues = Get-MyISScriptData -Name `"Name`" -Bitness `"32`" -Script `"ScriptName`" -Computer")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Read the value from the 32 bit HKLM Registry Hive under the Specified Script Name registry key")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$Script = [System.IO.Path]::GetFileNameWithoutExtension(`$MyInvocation.ScriptName),")
  [Void]$StringBuilder.AppendLine("    [String[]]`$Name = `"*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$User,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Computer,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"32`", `"64`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Bitness = `"64`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Get-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Get Default Registry Path")
  [Void]$StringBuilder.AppendLine("  if (`$Computer.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$Bitness -eq `"64`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$RegPath = `"Registry::HKEY_LOCAL_MACHINE\Software`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$RegPath = `"Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$RegPath = `"Registry::HKEY_CURRENT_USER\Software`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Get the values from the registry.")
  [Void]$StringBuilder.AppendLine("  Get-ItemProperty -Path `"`$RegPath\MyISScriptData\`$Script`" -ErrorAction `"SilentlyContinue`" | Select-Object -Property `$Name")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Get-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion ")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Get-MyISScriptData
  
  #region function Remove-MyISScriptData
  [Void]$StringBuilder.AppendLine("#region function Remove-MyISScriptData")
  [Void]$StringBuilder.AppendLine("function Remove-MyISScriptData()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Removes Script Data from the Registry")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Removes Script Data from the Registry")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Script")
  [Void]$StringBuilder.AppendLine("     Name of the Regsitry Key to remove. Defaults to the name of the script.")
  [Void]$StringBuilder.AppendLine("    .PARAMETER User")
  [Void]$StringBuilder.AppendLine("      Remove from the HKCU Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Computer")
  [Void]$StringBuilder.AppendLine("      Remove from the HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Bitness")
  [Void]$StringBuilder.AppendLine("      Specify 32/64 bit HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyISScriptData")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Removes the default script registry key from the HKCU Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyISScriptData -User -Script `"ScriptName`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Removes the Specified Script Name registry key from the HKCU Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyISScriptData -Computer")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Removes the default script registry key from the 32/64 bit HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyISScriptData -Computer -Script `"ScriptName`" -Bitness `"32`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Removes the Specified Script Name registry key from the 32 bit HKLM Registry Hive")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$Script = [System.IO.Path]::GetFileNameWithoutExtension(`$MyInvocation.ScriptName),")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"User`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$User,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Computer,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Comp`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"32`", `"64`", `"All`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Bitness = `"All`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Remove-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Get Default Registry Paths")
  [Void]$StringBuilder.AppendLine("  `$RegPaths = New-Object -TypeName System.Collections.ArrayList")
  [Void]$StringBuilder.AppendLine("  if (`$Computer.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$Bitness -match `"All|32`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$RegPaths.Add(`"Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if (`$Bitness -match `"All|64`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$RegPaths.Add(`"Registry::HKEY_LOCAL_MACHINE\Software`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void]`$RegPaths.Add(`"Registry::HKEY_CURRENT_USER\Software`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Remove the values from the registry.")
  [Void]$StringBuilder.AppendLine("  ForEach (`$RegPath in `$RegPaths)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    [Void](Remove-Item -Path `"`$RegPath\MyISScriptData\`$Script`")")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Remove-MyISScriptData`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Remove-MyISScriptData")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Remove-MyISScriptData
  
  #region function Get-EnvironmentVariable
  [Void]$StringBuilder.AppendLine("#region function Get-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("function Get-EnvironmentVariable()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Variable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER UserName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Credential")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Get-EnvironmentVariable -Variable <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ValueFromPipeline = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [String]`$Variable = `"%`",")
  [Void]$StringBuilder.AppendLine("    [String]`$UserName = `"<SYSTEM>`",")
  [Void]$StringBuilder.AppendLine("    [PSCredential]`$Credential = [PSCredential]::Empty")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Query = `"Select * from Win32_Environment Where Name like '`$Variable' and UserName = '`$UserName'`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$SessionParams = @{")
  [Void]$StringBuilder.AppendLine("      `"ComputerName`" = `"`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Credential`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$SessionParms.Add(`"Credential`", `$Credential)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Computer in `$ComputerName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$SessionParams.ComputerName = `$Computer")
  [Void]$StringBuilder.AppendLine("      Get-CimInstance -CimSession (New-CimSession @SessionParams) -Query `$Query")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Get-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Get-EnvironmentVariable
  
  #region function Set-EnvironmentVariable
  [Void]$StringBuilder.AppendLine("#region function Set-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("function Set-EnvironmentVariable()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Variable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER UserName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Credential")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Set-EnvironmentVariable -Variable <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ValueFromPipeline = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Variable,")
  [Void]$StringBuilder.AppendLine("    [String]`$Value,")
  [Void]$StringBuilder.AppendLine("    [String]`$UserName = `"<SYSTEM>`",")
  [Void]$StringBuilder.AppendLine("    [PSCredential]`$Credential = [PSCredential]::Empty")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Set-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Query = `"Select * from Win32_Environment Where Name = '`$Variable' and UserName = '`$UserName'`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$SessionParams = @{")
  [Void]$StringBuilder.AppendLine("      `"ComputerName`" = `"`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Credential`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$SessionParms.Add(`"Credential`", `$Credential)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Set-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Set-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Computer in `$ComputerName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$SessionParams.ComputerName = `$Computer")
  [Void]$StringBuilder.AppendLine("      `$CimSession = New-CimSession @SessionParams")
  [Void]$StringBuilder.AppendLine("      if ([String]::IsNullOrEmpty((`$Instance = Get-CimInstance -CimSession `$CimSession -Query `$Query)))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        New-CimInstance -CimSession `$CimSession -ClassName Win32_Environment -Property @{ `"Name`" = `$Variable; `"VariableValue`" = `$Value; `"UserName`" = `$UserName }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Set-CimInstance -InputObject `$Instance -Property @{ `"Name`" = `$Variable; `"VariableValue`" = `$Value } -PassThru")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$CimSession.Close()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Set-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Set-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Set-EnvironmentVariable
  
  #region function Remove-EnvironmentVariable
  [Void]$StringBuilder.AppendLine("#region function Remove-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("function Remove-EnvironmentVariable()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Creates an Environment Variable on the Local or Remote Workstation")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Variable")
  [Void]$StringBuilder.AppendLine("    .PARAMETER UserName")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Credential")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-EnvironmentVariable -Variable <String>")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ValueFromPipeline = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$Variable,")
  [Void]$StringBuilder.AppendLine("    [String]`$UserName = `"<SYSTEM>`",")
  [Void]$StringBuilder.AppendLine("    [PSCredential]`$Credential = [PSCredential]::Empty")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Remove-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Query = `"Select * from Win32_Environment Where Name = '`$Variable' and UserName = '`$UserName'`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$SessionParams = @{")
  [Void]$StringBuilder.AppendLine("      `"ComputerName`" = `"`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Credential`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$SessionParms.Add(`"Credential`", `$Credential)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Remove-EnvironmentVariable Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Remove-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Computer in `$ComputerName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$SessionParams.ComputerName = `$Computer")
  [Void]$StringBuilder.AppendLine("      `$CimSession = New-CimSession @SessionParams")
  [Void]$StringBuilder.AppendLine("      if (-not [String]::IsNullOrEmpty((`$Instance = Get-CimInstance -CimSession `$CimSession -Query `$Query)))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Remove-CimInstance -InputObject `$Instance")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$CimSession.Close()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Remove-EnvironmentVariable Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Remove-EnvironmentVariable")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Remove-EnvironmentVariable
  
  #region function Test-MyClassLoaded
  [Void]$StringBuilder.AppendLine("#region function Test-MyClassLoaded")
  [Void]$StringBuilder.AppendLine("function Test-MyClassLoaded()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Test if Custom Class is Loaded")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Test if Custom Class is Loaded")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("      Name of Custom Class")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$IsLoaded = Test-MyClassLoaded -Name `"CustomClass`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$Name")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Test-MyClassLoaded`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  (-not [String]::IsNullOrEmpty((New-Object -TypeName Management.Automation.PSTypeName(`$Name)).Type))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Test-MyClassLoaded`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Test-MyClassLoaded")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Test-MyClassLoaded
  
  #region function Scale-MyForm
  [Void]$StringBuilder.AppendLine("#region function Scale-MyForm")
  [Void]$StringBuilder.AppendLine("function Scale-MyForm()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Scale Form")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Scale Form")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Scale")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Scale-MyForm -Control `$Control -`$Scale")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [Object]`$Control = `$$($MyScriptName)Form,")
  [Void]$StringBuilder.AppendLine("    [Single]`$Scale = 1")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Scale-MyForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$Control -is [System.Windows.Forms.Form])")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$Control.Scale(`$Scale)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$Control.Font = New-Object -TypeName System.Drawing.Font(`$Control.Font.FontFamily, (`$Control.Font.Size * `$Scale), `$Control.Font.Style)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ([String]::IsNullOrEmpty(`$Control.PSObject.Properties.Match(`"Items`")))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$Control.Controls.Count)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      ForEach (`$ChildControl in `$Control.Controls)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Scale-MyForm -Control `$ChildControl -Scale `$Scale")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Item in `$Control.Items)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Scale-MyForm -Control `$Item -Scale `$Scale")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Scale-MyForm`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Scale-MyForm")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Scale-MyForm
  
  [Void]$StringBuilder.AppendLine("#endregion ================ My Custom Functions ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptFunctions"
}
#endregion function Build-MyScriptFunctions

#region function Build-MyScriptMultiThread
function Build-MyScriptMultiThread ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptMultiThread -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptMultiThread"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Multiple Thread Functions <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  
  #region ******** Custom Objects MyRSPool / MyRSJob  ********
  [Void]$StringBuilder.AppendLine("#region ******** Custom Objects MyRSPool / MyRSJob ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Collections.Generic;")
  [Void]$StringBuilder.AppendLine("using System.Management.Automation;")
  [Void]$StringBuilder.AppendLine("using System.Threading;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("public class MyRSJob")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  private System.String _Name;")
  [Void]$StringBuilder.AppendLine("  private System.String _PoolName;")
  [Void]$StringBuilder.AppendLine("  private System.Guid _PoolID;")
  [Void]$StringBuilder.AppendLine("  private System.Management.Automation.PowerShell _PowerShell;")
  [Void]$StringBuilder.AppendLine("  private System.IAsyncResult _PowerShellAsyncResult;")
  [Void]$StringBuilder.AppendLine("  private System.Object _InputObject = null;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public MyRSJob(System.String Name, System.Management.Automation.PowerShell PowerShell, System.IAsyncResult PowerShellAsyncResult, System.Object InputObject, System.String PoolName, System.Guid PoolID)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    _Name = Name;")
  [Void]$StringBuilder.AppendLine("    _PoolName = PoolName;")
  [Void]$StringBuilder.AppendLine("    _PoolID = PoolID;")
  [Void]$StringBuilder.AppendLine("    _PowerShell = PowerShell;")
  [Void]$StringBuilder.AppendLine("    _PowerShellAsyncResult = PowerShellAsyncResult;")
  [Void]$StringBuilder.AppendLine("    _InputObject = InputObject;")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.String Name")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _Name;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Guid InstanceID")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.InstanceId;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.String PoolName")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PoolName;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Guid PoolID")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PoolID;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PowerShell PowerShell")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSInvocationState State")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.InvocationStateInfo.State;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Exception Reason")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.InvocationStateInfo.Reason;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public bool HadErrors")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.HadErrors;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.String Command")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Commands.Commands[0].ToString();")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.Runspaces.RunspacePool RunspacePool")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.RunspacePool;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.IAsyncResult PowerShellAsyncResult")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShellAsyncResult;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public bool IsCompleted")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShellAsyncResult.IsCompleted;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Object InputObject")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _InputObject;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSDataCollection<System.Management.Automation.DebugRecord> Debug")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Streams.Debug;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSDataCollection<System.Management.Automation.ErrorRecord> Error")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Streams.Error;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSDataCollection<System.Management.Automation.ProgressRecord> Progress")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Streams.Progress;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSDataCollection<System.Management.Automation.VerboseRecord> Verbose")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Streams.Verbose;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.PSDataCollection<System.Management.Automation.WarningRecord> Warning")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _PowerShell.Streams.Warning;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("public class MyRSPool")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  private System.String _Name;  ")
  [Void]$StringBuilder.AppendLine("  private System.Management.Automation.Runspaces.RunspacePool _RunspacePool;")
  [Void]$StringBuilder.AppendLine("  public System.Collections.Generic.List<MyRSJob> Jobs = new System.Collections.Generic.List<MyRSJob>();")
  [Void]$StringBuilder.AppendLine("  private System.Collections.Hashtable _SyncedHash;")
  [Void]$StringBuilder.AppendLine("  private System.Threading.Mutex _Mutex;  ")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public MyRSPool(System.String Name, System.Management.Automation.Runspaces.RunspacePool RunspacePool, System.Collections.Hashtable SyncedHash) ")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    _Name = Name;")
  [Void]$StringBuilder.AppendLine("    _RunspacePool = RunspacePool;")
  [Void]$StringBuilder.AppendLine("    _SyncedHash = SyncedHash;")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public MyRSPool(System.String Name, System.Management.Automation.Runspaces.RunspacePool RunspacePool, System.Collections.Hashtable SyncedHash, System.String Mutex) ")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    _Name = Name;")
  [Void]$StringBuilder.AppendLine("    _RunspacePool = RunspacePool;")
  [Void]$StringBuilder.AppendLine("    _SyncedHash = SyncedHash;")
  [Void]$StringBuilder.AppendLine("    _Mutex = new System.Threading.Mutex(false, Mutex);")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Collections.Hashtable SyncedHash")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _SyncedHash;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Threading.Mutex Mutex")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _Mutex;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.String Name")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _Name;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Guid InstanceID")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _RunspacePool.InstanceId;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.Runspaces.RunspacePool RunspacePool")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _RunspacePool;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  public System.Management.Automation.Runspaces.RunspacePoolState State")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    get")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      return _RunspacePool.RunspacePoolStateInfo.State;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -Debug:`$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$Script:MyHiddenRSPool = New-Object -TypeName `"System.Collections.Generic.Dictionary[[String], [MyRSPool]]`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ******** Custom Objects MyRSPool / MyRSJob ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Custom Objects MyRSPool / MyRSJob  ********
  
  #region ******** function Start-MyRSPool ********
  [Void]$StringBuilder.AppendLine("#region function Start-MyRSPool")
  [Void]$StringBuilder.AppendLine("function Start-MyRSPool()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates or Updates a RunspacePool")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of RunspacePool")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Functions")
  [Void]$StringBuilder.AppendLine("      Functions to include in the initial Session State")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Variables")
  [Void]$StringBuilder.AppendLine("      Variables to include in the initial Session State")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Modules")
  [Void]$StringBuilder.AppendLine("      Modules to load in the initial Session State")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PSSnapins")
  [Void]$StringBuilder.AppendLine("      PSSnapins to load in the initial Session State")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Hashtable")
  [Void]$StringBuilder.AppendLine("      Synced Hasttable to pass values between threads")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Mutex")
  [Void]$StringBuilder.AppendLine("      Protects access to a shared resource")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MaxJobs")
  [Void]$StringBuilder.AppendLine("      Maximum Number of Jobs")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("      Return the New RSPool to the Pipeline")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Start-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Create the Default RunspacePool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSPool = Start-MyRSPool -PoolName `$PoolName -MaxJobs `$MaxJobs -PassThru")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Create a New RunspacePool and Return the RSPool to the Pipeline")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [Hashtable]`$Functions,")
  [Void]$StringBuilder.AppendLine("    [Hashtable]`$Variables,")
  [Void]$StringBuilder.AppendLine("    [String[]]`$Modules,")
  [Void]$StringBuilder.AppendLine("    [String[]]`$PSSnapins,")
  [Void]$StringBuilder.AppendLine("    [Hashtable]`$Hashtable = @{ `"Enabled`" = `$True },")
  [Void]$StringBuilder.AppendLine("    [String]`$Mutex,")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(1, 64)]")
  [Void]$StringBuilder.AppendLine("    [Int]`$MaxJobs = 8,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Start-MyRSPool`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # check if Runspace Pool already exists")
  [Void]$StringBuilder.AppendLine("  if (`$Script:MyHiddenRSPool.ContainsKey(`$PoolName))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    # Return Existing Runspace Pool")
  [Void]$StringBuilder.AppendLine("    [MyRSPool](`$Script:MyHiddenRSPool[`$PoolName])")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    # Create Default Session State")
  [Void]$StringBuilder.AppendLine("    `$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Import Modules")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Modules`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$InitialSessionState.ImportPSModule(`$Modules)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Import PSSnapins")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"PSSnapins`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$InitialSessionState.ImportPSSnapIn(`$PSSnapins, [Ref]`$Null)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Common Functions")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Functions`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Key in `$Functions.Keys)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$InitialSessionState.Commands.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList `$Key, `$Functions[`$Key]))")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Default Variables")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Variables`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Key in `$Variables.Keys)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$InitialSessionState.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList `$Key, `$Variables[`$Key], `"`$Key = `$(`$Variables[`$Key])`", ([System.Management.Automation.ScopedItemOptions]::AllScope)))")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Create and Open RunSpacePool")
  [Void]$StringBuilder.AppendLine("    `$SyncedHash = [Hashtable]::Synchronized(`$Hashtable)")
  [Void]$StringBuilder.AppendLine("    `$InitialSessionState.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList `"SyncedHash`", `$SyncedHash, `"SyncedHash = Synced Hashtable`", ([System.Management.Automation.ScopedItemOptions]::AllScope)))")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"Mutex`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$InitialSessionState.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList `"Mutex`", `$Mutex, `"Mutex = `$Mutex`", ([System.Management.Automation.ScopedItemOptions]::AllScope)))")
  [Void]$StringBuilder.AppendLine("      `$CreateRunspacePool = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, `$MaxJobs, `$InitialSessionState, `$Host)")
  [Void]$StringBuilder.AppendLine("      `$RSPool = New-Object -TypeName `"MyRSPool`" -ArgumentList `$PoolName, `$CreateRunspacePool, `$SyncedHash, `$Mutex")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$CreateRunspacePool = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, `$MaxJobs, `$InitialSessionState, `$Host)")
  [Void]$StringBuilder.AppendLine("      `$RSPool = New-Object -TypeName `"MyRSPool`" -ArgumentList `$PoolName, `$CreateRunspacePool, `$SyncedHash")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$RSPool.RunspacePool.ApartmentState = `"STA`"")
  [Void]$StringBuilder.AppendLine("    #`$RSPool.RunspacePool.ApartmentState = `"MTA`"")
  [Void]$StringBuilder.AppendLine("    `$RSPool.RunspacePool.CleanupInterval = [TimeSpan]::FromMinutes(2)")
  [Void]$StringBuilder.AppendLine("    `$RSPool.RunspacePool.Open()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Script:MyHiddenRSPool.Add(`$PoolName, `$RSPool)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$RSPool")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Start-MyRSPool`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Start-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Start-MyRSPool ********
  
  #region ******** function Get-MyRSPool ********
  [Void]$StringBuilder.AppendLine("#region function Get-MyRSPool")
  [Void]$StringBuilder.AppendLine("function Get-MyRSPool()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Get RunspacePools that match specified criteria")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Get RunspacePools that match specified criteria")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of RSPool to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      PoolID of Job to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to search for")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSPools = Get-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Get all RSPools")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSPools = Get-MyRSPool -PoolName `$PoolName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyRSPools = Get-MyRSPool -PoolID `$PoolID")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Get Specified RSPools")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"All`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"PoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"All`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"PoolID`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"BeforeOpen`", `"Opening`", `"Opened`", `"Closed`", `"Closing`", `"Broken`", `"Disconnecting`", `"Disconnected`", `"Connecting`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-MyRSPool Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Set Job State RegEx Pattern")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"State`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$StatePattern = `$State -join `"|`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$StatePattern = `".*`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-MyRSPool Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-MyRSPool Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"All`" {")
  [Void]$StringBuilder.AppendLine("        # Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        [MyRSPool[]](`$Script:MyHiddenRSPool.Values | Where-Object -FilterScript { `$PSItem.State -match `$StatePattern })")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolName`" {")
  [Void]$StringBuilder.AppendLine("        # Set Pool Name and Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$NamePattern = `$PoolName -join `"|`"")
  [Void]$StringBuilder.AppendLine("        [MyRSPool[]](`$Script:MyHiddenRSPool.Values | Where-Object -FilterScript { `$PSItem.State -match `$StatePattern -and `$PSItem.Name -match `$NamePattern})")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolID`" {")
  [Void]$StringBuilder.AppendLine("        # Set PoolID and Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$IDPattern = `$PoolID -join `"|`"")
  [Void]$StringBuilder.AppendLine("        [MyRSPool[]](`$Script:MyHiddenRSPool.Values | Where-Object -FilterScript { `$PSItem.State -match `$StatePattern -and `$PSItem.InstanceId -match `$IDPattern })")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-MyRSPool Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Get-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function v ********
  
  #region ******** function Close-MyRSPool ********
  [Void]$StringBuilder.AppendLine("#region function Close-MyRSPool")
  [Void]$StringBuilder.AppendLine("function Close-MyRSPool()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Close RunspacePool and Stop all Running Jobs")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Close RunspacePool and Stop all Running Jobs")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to clsoe")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of RSPool to close")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      PoolID of Job to close")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to close")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Close-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Close the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Close-MyRSPool -PoolName `$PoolName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Close-MyRSPool -PoolID `$PoolID")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Close Specified RSPools")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"All`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"RSPool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"PoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"All`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"PoolID`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"BeforeOpen`", `"Opening`", `"Opened`", `"Closed`", `"Closing`", `"Broken`", `"Disconnecting`", `"Disconnected`", `"Connecting`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Close-MyRSPool Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    If (`$PSCmdlet.ParameterSetName -eq `"RSPool`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempPools = `$RSPool")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempPools = [MyRSPool[]](Get-MyRSPool @PSBoundParameters)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Close RunspacePools, This will Stop all Running Jobs")
  [Void]$StringBuilder.AppendLine("    ForEach (`$TempPool in `$TempPools)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (-not [String]::IsNullOrEmpty(`$TempPool.Mutex))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempPool.Mutex.Close()")
  [Void]$StringBuilder.AppendLine("        `$TempPool.Mutex.Dispose()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$TempPool.RunspacePool.Close()")
  [Void]$StringBuilder.AppendLine("      `$TempPool.RunspacePool.Dispose()")
  [Void]$StringBuilder.AppendLine("      [Void]`$Script:MyHiddenRSPool.Remove(`$TempPool.Name)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Close-MyRSPool Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Close-MyRSPool End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Garbage Collect, Recover Resources")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Close-MyRSPool End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Close-MyRSPool")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function v ********
  
  #region ******** function Start-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Start-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Start-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Creates or Updates a RunspacePool")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to add new RunspacePool Jobs to")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of RunspacePool")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      ID of RunspacePool")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InputObject")
  [Void]$StringBuilder.AppendLine("      Object / Value to pass to the RunspacePool Job ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InputParam")
  [Void]$StringBuilder.AppendLine("      Paramter to pass the Object / Value as")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobName")
  [Void]$StringBuilder.AppendLine("      Name of RunspacePool Jobs")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ScriptBlock")
  [Void]$StringBuilder.AppendLine("      RunspacePool Job ScriptBock to Execute")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Parameters")
  [Void]$StringBuilder.AppendLine("      Common Paramaters to pass to the RunspacePool Job ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("      Return the New Jobs to the Pipeline")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Start-MyRSJob -ScriptBlock `$ScriptBlock -JobName `$JobName -InputObject `$InputObject")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Add new RSJobs to the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$InputObject | Start-MyRSJob -ScriptBlock `$ScriptBlock -RSPool `$RSPool -JobName `$JobName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$InputObject | Start-MyRSJob -ScriptBlock `$ScriptBlock -PoolName `$PoolName -JobName `$JobName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$InputObject | Start-MyRSJob -ScriptBlock `$ScriptBlock -PoolID `$PoolID -JobName `$JobName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Add new RSJobs to the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"RSPool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"PoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"PoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ValueFromPipeline = `$True)]")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$InputObject,")
  [Void]$StringBuilder.AppendLine("    [String]`$InputParam = `"InputObject`",")
  [Void]$StringBuilder.AppendLine("    [String]`$JobName = `"Job Name`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [ScriptBlock]`$ScriptBlock,")
  [Void]$StringBuilder.AppendLine("    [Hashtable]`$Parameters,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Start-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Switch (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"RSPool`" {")
  [Void]$StringBuilder.AppendLine("        # Set Pool")
  [Void]$StringBuilder.AppendLine("        `$TempPool = `$RSPool")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolName`" {")
  [Void]$StringBuilder.AppendLine("        # Set Pool Name and Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$TempPool = [MyRSPool](Start-MyRSPool -PoolName `$PoolName -PassThru)")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolID`" {")
  [Void]$StringBuilder.AppendLine("        # Set PoolID Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$TempPool = [MyRSPool](Get-MyRSPool -PoolID `$PoolID)")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # List for New Jobs")
  [Void]$StringBuilder.AppendLine("    `$NewJobs = New-Object -TypeName `"System.Collections.Generic.List[MyRSJob]`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Start-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Start-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"InputObject`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Object in `$InputObject)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        # Create New PowerShell Instance with ScriptBlock")
  [Void]$StringBuilder.AppendLine("        `$PowerShell = ([Management.Automation.PowerShell]::Create()).AddScript(`$ScriptBlock)")
  [Void]$StringBuilder.AppendLine("        # Set RunspacePool")
  [Void]$StringBuilder.AppendLine("        `$PowerShell.RunspacePool = `$TempPool.RunspacePool")
  [Void]$StringBuilder.AppendLine("        # Add Parameters")
  [Void]$StringBuilder.AppendLine("        [Void]`$PowerShell.AddParameter(`$InputParam, `$Object)")
  [Void]$StringBuilder.AppendLine("        if (`$PSBoundParameters.ContainsKey(`"Parameters`"))")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          [Void]`$PowerShell.AddParameters(`$Parameters)")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        # set Job Name")
  [Void]$StringBuilder.AppendLine("        if ((`$Object -is [String]) -or (`$Object -is [ValueType]))")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$TempJobName = `"`$JobName - `$(`$Object)`"")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$TempJobName = `$(`$Object.`$JobName)")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        [Void]`$NewJobs.Add((New-Object -TypeName `"MyRSjob`" -ArgumentList `$TempJobName, `$PowerShell, `$PowerShell.BeginInvoke(), `$Object, `$TempPool.Name, `$TempPool.InstanceID))")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Create New PowerShell Instance with ScriptBlock")
  [Void]$StringBuilder.AppendLine("      `$PowerShell = ([Management.Automation.PowerShell]::Create()).AddScript(`$ScriptBlock)")
  [Void]$StringBuilder.AppendLine("      # Set RunspacePool")
  [Void]$StringBuilder.AppendLine("      `$PowerShell.RunspacePool = `$TempPool.RunspacePool")
  [Void]$StringBuilder.AppendLine("      # Add Parameters")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"Parameters`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PowerShell.AddParameters(`$Parameters)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      [Void]`$NewJobs.Add((New-Object -TypeName `"MyRSjob`" -ArgumentList `$JobName, `$PowerShell, `$PowerShell.BeginInvoke(), `$Null, `$TempPool.Name, `$TempPool.InstanceID))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Start-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Start-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$NewJobs.Count)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempPool.Jobs.AddRange(`$NewJobs)")
  [Void]$StringBuilder.AppendLine("      # Return Jobs only if New RunspacePool")
  [Void]$StringBuilder.AppendLine("      if (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [MyRSJob[]](`$NewJobs)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$NewJobs.Clear()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Start-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Start-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Start-MyRSJob ********
  
  #region ******** function Get-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Get-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Get-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Get Jobs from RunspacePool that match specified criteria")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Get Jobs from RunspacePool that match specified criteria")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to search")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      ID of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobName")
  [Void]$StringBuilder.AppendLine("      Name of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobID")
  [Void]$StringBuilder.AppendLine("      ID of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to search for")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Get-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Get RSJobs from the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Get-MyRSJob -RSPool `$RSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Get-MyRSJob -PoolName `$PoolName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Get-MyRSJob -PoolID `$PoolID")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Get RSJobs from the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$JobName = `".*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$JobID,")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"NotStarted`", `"Running`", `"Stopping`", `"Stopped`", `"Completed`", `"Failed`", `"Disconnected`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Set Job State RegEx Pattern")
  [Void]$StringBuilder.AppendLine("    if (`$PSBoundParameters.ContainsKey(`"State`"))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$StatePattern = `$State -join `"|`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$StatePattern = `".*`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Switch -regex (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"Pool`$`" {")
  [Void]$StringBuilder.AppendLine("        # Set Pool")
  [Void]$StringBuilder.AppendLine("        `$TempPools = `$RSPool")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolName`$`" {")
  [Void]$StringBuilder.AppendLine("        # Set Pool Name and Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$TempPools = [MyRSPool[]](Get-MyRSPool -PoolName `$PoolName)")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"PoolID`$`" {")
  [Void]$StringBuilder.AppendLine("        # Set PoolID Return Matching Pools")
  [Void]$StringBuilder.AppendLine("        `$TempPools = [MyRSPool[]](Get-MyRSPool -PoolID `$PoolID)")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Get-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Switch -regex (`$PSCmdlet.ParameterSetName)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"^JobName`" {")
  [Void]$StringBuilder.AppendLine("        # Set Job Name RegEx Pattern and Return Matching Jobs")
  [Void]$StringBuilder.AppendLine("        `$NamePattern = `$JobName -join `"|`"")
  [Void]$StringBuilder.AppendLine("        [MyRSJob[]](`$TempPools | ForEach-Object -Process { `$PSItem.Jobs | Where-Object -FilterScript { `$PSItem.State -match `$StatePattern -and `$PSItem.Name -match `$NamePattern } })")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `"^JobID`" {")
  [Void]$StringBuilder.AppendLine("        # Set Job ID RegEx Pattern and Return Matching Jobs")
  [Void]$StringBuilder.AppendLine("        `$IDPattern = `$JobID -join `"|`"")
  [Void]$StringBuilder.AppendLine("        [MyRSJob[]](`$TempPools | ForEach-Object -Process { `$PSItem.Jobs | Where-Object -FilterScript { `$PSItem.State -match `$StatePattern -and `$PSItem.InstanceId -match `$IDPattern } })")
  [Void]$StringBuilder.AppendLine("        Break;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Get-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Get-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Get-MyRSJob ********
  
  #region ******** function Wait-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Wait-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Wait-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Wait for RSJob to Finish")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Wait for RSJob to Finish")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to search")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      ID of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobName")
  [Void]$StringBuilder.AppendLine("      Name of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobID")
  [Void]$StringBuilder.AppendLine("      ID of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ScriptBlock")
  [Void]$StringBuilder.AppendLine("      ScriptBlock to invoke while waiting")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      For windows Forms scripts add the DoEvents method in to the Wait ScritpBlock")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("      [System.Threading.Thread]::Sleep(250)")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Wait")
  [Void]$StringBuilder.AppendLine("      TimeSpace to wait")
  [Void]$StringBuilder.AppendLine("    .PARAMETER NoWait")
  [Void]$StringBuilder.AppendLine("      No Wait, Return when any Job states changes to Stopped, Completed, or Failed")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PassThru")
  [Void]$StringBuilder.AppendLine("      Return the New Jobs to the Pipeline")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Wait-MyRSJob -PassThru")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Wait for and Get RSJobs from the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Wait-MyRSJob -RSPool `$RSPool -PassThru")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Wait-MyRSJob -PoolName `$PoolName -PassThru")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyRSJobs = Wait-MyRSJob -PoolID `$PoolID -PassThru")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Wait for and Get RSJobs from the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$JobName = `".*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$JobID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"RSJob`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSJob[]]`$RSJob,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"NotStarted`", `"Running`", `"Stopping`", `"Stopped`", `"Completed`", `"Failed`", `"Disconnected`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State,")
  [Void]$StringBuilder.AppendLine("    [ScriptBlock]`$SciptBlock = { [System.Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 200 },")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(`"0:00:00`", `"8:00:00`")]")
  [Void]$StringBuilder.AppendLine("    [TimeSpan]`$Wait = `"0:05:00`",")
  [Void]$StringBuilder.AppendLine("    [Switch]`$NoWait,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$PassThru")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Wait-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Remove Invalid Get-MyRSJob Parameters")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -ne `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"PassThru`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"PassThru`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"Wait`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"Wait`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"NoWait`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"NoWait`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"ScriptBlock`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"ScriptBlock`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # List for Wait Jobs")
  [Void]$StringBuilder.AppendLine("    `$WaitJobs = New-Object -TypeName `"System.Collections.Generic.List[MyRSJob]`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Wait-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Wait-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Passed RSJobs to `$Jobs")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -eq `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$WaitJobs.AddRange([MyRSJob[]](`$RSJob))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$WaitJobs.AddRange([MyRSJob[]](Get-MyRSJob @PSBoundParameters))")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Wait-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Wait-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Wait for Jobs to be Finshed")
  [Void]$StringBuilder.AppendLine("    if (`$NoWait.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      While (@((`$WaitJobs | Where-Object -FilterScript { `$PSItem.State -notmatch `"Stopped|Completed|Failed`" })).Count -eq `$WaitJobs.Count)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$SciptBlock.Invoke()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Object[]]`$CheckJobs = `$WaitJobs.ToArray()")
  [Void]$StringBuilder.AppendLine("      `$Start = [DateTime]::Now")
  [Void]$StringBuilder.AppendLine("      While (@((`$CheckJobs = `$CheckJobs | Where-Object -FilterScript { `$PSItem.State -notmatch `"Stopped|Completed|Failed`" })).Count -and ((([DateTime]::Now - `$Start) -le `$Wait) -or (`$Wait.Ticks -eq 0)))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$SciptBlock.Invoke()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$PassThru.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Return Completed Jobs")
  [Void]$StringBuilder.AppendLine("      [MyRSJob[]](`$WaitJobs | Where-Object -FilterScript { `$PSItem.State -match `"Stopped|Completed|Failed`" })")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$WaitJobs.Clear()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Wait-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Wait-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Wait-MyRSJob ********
  
  #region ******** function Stop-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Stop-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Stop-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to search")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("      Name of Job to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InstanceId")
  [Void]$StringBuilder.AppendLine("      InstanceId of Job to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSJob")
  [Void]$StringBuilder.AppendLine("      RunspacePool Jobs to Process")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to search for")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Stop-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Stop all RSJobs in the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Stop-MyRSJob -RSPool `$RSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Stop-MyRSJob -PoolName `$PoolName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Stop-MyRSJob -PoolID `$PoolID")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Stop all RSJobs in the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$JobName = `".*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$JobID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"RSJob`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSJob[]]`$RSJob,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"NotStarted`", `"Running`", `"Stopping`", `"Stopped`", `"Completed`", `"Failed`", `"Disconnected`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Stop-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Passed RSJobs to `$Jobs")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -eq `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = `$RSJob")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = [MyRSJob[]](Get-MyRSJob @PSBoundParameters)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Stop all Jobs that have not Finished")
  [Void]$StringBuilder.AppendLine("    ForEach (`$TempJob in `$TempJobs)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$TempJob.State -notmatch `"Stopped|Completed|Failed`")")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempJob.PowerShell.Stop()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Stop-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Stop-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Garbage Collect, Recover Resources")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Stop-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Stop-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Stop-MyRSJob ********
  
  #region ******** function Receive-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Receive-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Receive-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Receive Output from Completed Jobs")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Receive Output from Completed Jobs")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to search")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolName")
  [Void]$StringBuilder.AppendLine("      Name of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER PoolID")
  [Void]$StringBuilder.AppendLine("      ID of Pool to Get Jobs From")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobName")
  [Void]$StringBuilder.AppendLine("      Name of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER JobID")
  [Void]$StringBuilder.AppendLine("      ID of Jobs to Get")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSJob")
  [Void]$StringBuilder.AppendLine("      Jobs to Process")
  [Void]$StringBuilder.AppendLine("    .PARAMETER AutoRemove")
  [Void]$StringBuilder.AppendLine("      Remove Jobs after Receiving Output")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyResults = Receive-MyRSJob -AutoRemove")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Receive Results from RSJobs in the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$MyResults = Receive-MyRSJob -RSPool `$RSPool -AutoRemove")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyResults = Receive-MyRSJob -PoolName `$PoolName -AutoRemove")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$MyResults = Receive-MyRSJob -PoolID `$PoolID -AutoRemove")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Receive Results from RSJobs in the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$JobName = `".*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$JobID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"RSJob`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSJob[]]`$RSJob,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$AutoRemove,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Force")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Receive-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Remove Invalid Get-MyRSJob Parameters")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -ne `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"AutoRemove`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"AutoRemove`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # List for Remove Jobs")
  [Void]$StringBuilder.AppendLine("    `$RemoveJobs = New-Object -TypeName `"System.Collections.Generic.List[MyRSJob]`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Receive-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Receive-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Passed RSJobs to `$Jobs")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -eq `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = `$RSJob")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void]`$PSBoundParameters.Add(`"State`", `"Completed`")")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = [MyRSJob[]](Get-MyRSJob @PSBoundParameters)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Receive all Complted Jobs, Remove Job if Required")
  [Void]$StringBuilder.AppendLine("    ForEach (`$TempJob in `$TempJobs)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$TempJob.IsCompleted)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        Try")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$TempJob.PowerShell.EndInvoke(`$TempJob.PowerShellAsyncResult)")
  [Void]$StringBuilder.AppendLine("          # Add Job to Remove List")
  [Void]$StringBuilder.AppendLine("          [Void]`$RemoveJobs.Add(`$TempJob)")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        Catch")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Receive-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Receive-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$AutoRemove.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Remove RSJobs")
  [Void]$StringBuilder.AppendLine("      foreach (`$RemoveJob in `$RemoveJobs)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$RemoveJob.PowerShell.Dispose()")
  [Void]$StringBuilder.AppendLine("        [Void]`$Script:MyHiddenRSPool[`$RemoveJob.PoolName].Jobs.Remove(`$RemoveJob)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$RemoveJobs.Clear()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Garbage Collect, Recover Resources")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Receive-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Receive-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Receive-MyRSJob ********
  
  #region ******** function Remove-MyRSJob ********
  [Void]$StringBuilder.AppendLine("#region function Remove-MyRSJob")
  [Void]$StringBuilder.AppendLine("function Remove-MyRSJob()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Function to do something specific")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSPool")
  [Void]$StringBuilder.AppendLine("      RunspacePool to search")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Name")
  [Void]$StringBuilder.AppendLine("      Name of Job to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InstanceId")
  [Void]$StringBuilder.AppendLine("      InstanceId of Job to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER RSJob")
  [Void]$StringBuilder.AppendLine("      RunspacePool Jobs to Process")
  [Void]$StringBuilder.AppendLine("    .PARAMETER State")
  [Void]$StringBuilder.AppendLine("      State of Jobs to search for")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Force")
  [Void]$StringBuilder.AppendLine("      Force the Job to stop")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Remove all RSJobs in the Default RSPool")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Remove-MyRSJob -RSPool `$RSPool")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Remove-MyRSJob -PoolName `$PoolName")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Remove-MyRSJob -PoolID `$PoolID")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Remove all RSJobs in the Specified RSPool")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017 at 06:53 AM")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019 at 06:53 AM")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSPool[]]`$RSPool,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [String]`$PoolName = `"MyDefaultRSPool`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid]`$PoolID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$JobName = `".*`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [Guid[]]`$JobID,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ValueFromPipeline = `$True, ParameterSetName = `"RSJob`")]")
  [Void]$StringBuilder.AppendLine("    [MyRSJob[]]`$RSJob,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobNamePoolID`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPool`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolName`")]")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"JobIDPoolID`")]")
  [Void]$StringBuilder.AppendLine("    [ValidateSet(`"NotStarted`", `"Running`", `"Stopping`", `"Stopped`", `"Completed`", `"Failed`", `"Disconnected`")]")
  [Void]$StringBuilder.AppendLine("    [String[]]`$State,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Force")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Begin")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Remove-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Remove Invalid Get-MyRSJob Parameters")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -ne `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"Force`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        [Void]`$PSBoundParameters.Remove(`"Force`")")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # List for Remove Jobs")
  [Void]$StringBuilder.AppendLine("    `$RemoveJobs = New-Object -TypeName `"System.Collections.Generic.List[MyRSJob]`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Remove-MyRSJob Begin Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Process")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Remove-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Add Passed RSJobs to `$Jobs")
  [Void]$StringBuilder.AppendLine("    if (`$PSCmdlet.ParameterSetName -eq `"RSJob`")")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = `$RSJob")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$TempJobs = [MyRSJob[]](Get-MyRSJob @PSBoundParameters)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Remove all Jobs, Stop all Running if Forced")
  [Void]$StringBuilder.AppendLine("    ForEach (`$TempJob in `$TempJobs)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (`$Force -and `$TempJob.State -notmatch `"Stopped|Completed|Failed`")")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempJob.PowerShell.Stop()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      if (`$TempJob.State -match `"Stopped|Completed|Failed`")")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        # Add Job to Remove List")
  [Void]$StringBuilder.AppendLine("        [Void]`$RemoveJobs.Add(`$TempJob)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Remove-MyRSJob Process Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  End")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Function Remove-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Remove RSJobs")
  [Void]$StringBuilder.AppendLine("    foreach (`$RemoveJob in `$RemoveJobs)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$RemoveJob.PowerShell.Dispose()")
  [Void]$StringBuilder.AppendLine("      [Void]`$Script:MyHiddenRSPool[`$RemoveJob.PoolName].Jobs.Remove(`$RemoveJob)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    `$RemoveJobs.Clear()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Garbage Collect, Recover Resources")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Function Remove-MyRSJob End Block`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Remove-MyRSJob")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** function Remove-MyRSJob ********
  
  #region ******** RSPools Sample Code ********
  [Void]$StringBuilder.AppendLine("#region ******** RSPools Sample Code ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region function Test-Function")
  [Void]$StringBuilder.AppendLine("Function Test-Function")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Test Function for RunspacePool ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Test Function for RunspacePool ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Value")
  [Void]$StringBuilder.AppendLine("      Value Command Line Parameter")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Test-Function -Value `"String`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, HelpMessage = `"Enter Value`", ParameterSetName = `"Default`")]")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$Value = `"Default Value`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Test-Function`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Start-Sleep -Milliseconds (1000 * 5)")
  [Void]$StringBuilder.AppendLine("  ForEach (`$Item in `$Value)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Return Value: ```$Item = `$Item`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Test-Function`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion  function Test-Function")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region Job `$ScriptBlock")
  [Void]$StringBuilder.AppendLine("`$ScriptBlock = {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Test RunspacePool ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Test RunspacePool ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InputObject")
  [Void]$StringBuilder.AppendLine("      InputObject passed to script")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Test-Script.ps1 -InputObject `$InputObject")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet on 10/15/2017")
  [Void]$StringBuilder.AppendLine("      Updated Script By Ken Sweet on 02/04/2019")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Thread Script Variables")
  [Void]$StringBuilder.AppendLine("        [String]`$Mutex - Exist only if -Mutex was specified on the Start-MyRSPool command line")
  [Void]$StringBuilder.AppendLine("        [HashTable]`$SyncedHash - Always Exists, Default values `$SyncedHash.Enabled = `$True")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"ByValue`")]")
  [Void]$StringBuilder.AppendLine("  Param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"ByValue`")]")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$InputObject")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Generate Error Message to show in Error Buffer")
  [Void]$StringBuilder.AppendLine("  `$ErrorActionPreference = `"Continue`"")
  [Void]$StringBuilder.AppendLine("  GenerateErrorMessage")
  [Void]$StringBuilder.AppendLine("  `$ErrorActionPreference = `"Stop`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Enable Verbose logging")
  [Void]$StringBuilder.AppendLine("  `$VerbosePreference = `"Continue`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Check is Thread is Enabled to Run")
  [Void]$StringBuilder.AppendLine("  if (`$SyncedHash.Enabled)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    # Call Imported Test Function")
  [Void]$StringBuilder.AppendLine("    Test-Function -Value `$InputObject")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Check if a Mutex exist")
  [Void]$StringBuilder.AppendLine("    if ([String]::IsNullOrEmpty(`$Mutex))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$HasMutex = `$False")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Open and wait for Mutex")
  [Void]$StringBuilder.AppendLine("      `$MyMutex = [System.Threading.Mutex]::OpenExisting(`$Mutex)")
  [Void]$StringBuilder.AppendLine("      [Void](`$MyMutex.WaitOne())")
  [Void]$StringBuilder.AppendLine("      `$HasMutex = `$True")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Write Data to the Screen")
  [Void]$StringBuilder.AppendLine("    For (`$Count = 0; `$Count -le 8; `$Count++)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Write-Host -Object `"```$InputObject = `$InputObject`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Release the Mutex if it Exists")
  [Void]$StringBuilder.AppendLine("    if (`$HasMutex)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$MyMutex.ReleaseMutex()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `"Return Value: RSJob was Canceled`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#region `$WaitScript")
  [Void]$StringBuilder.AppendLine("`$WaitScript = {")
  [Void]$StringBuilder.AppendLine("  Write-Host -Object `"Completed `$(@(Get-MyRSJob | Where-Object -FilterScript { `$PSItem.State -eq 'Completed' }).Count) Jobs`"")
  [Void]$StringBuilder.AppendLine("  Start-Sleep -Milliseconds 1000")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("<#")
  [Void]$StringBuilder.AppendLine("`$TestFunction = @{}")
  [Void]$StringBuilder.AppendLine("`$TestFunction.Add(`"Test-Function`", (Get-Command -Type Function -Name Test-Function).ScriptBlock)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Start and Get RSPool")
  [Void]$StringBuilder.AppendLine("`$RSPool = Start-MyRSPool -MaxJobs 8 -Functions `$TestFunction -PassThru #-Mutex `"TestMutex`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Create new RunspacePool and start 5 Jobs")
  [Void]$StringBuilder.AppendLine("1..10 | Start-MyRSJob -ScriptBlock `$ScriptBlock -PassThru | Out-String")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Add 5 new Jobs to an existing RunspacePool")
  [Void]$StringBuilder.AppendLine("11..20 | Start-MyRSJob -ScriptBlock `$ScriptBlock -PassThru | Out-String")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Disable Thread Script")
  [Void]$StringBuilder.AppendLine("#`$RSPool.SyncedHash.Enabled = `$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Wait for all Jobs to Complete or Fail")
  [Void]$StringBuilder.AppendLine("Get-MyRSJob | Wait-MyRSJob -SciptBlock `$WaitScript -PassThru | Out-String")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Receive Completed Jobs and Remove them")
  [Void]$StringBuilder.AppendLine("Get-MyRSJob | Receive-MyRSJob -AutoRemove")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("# Close RunspacePool")
  [Void]$StringBuilder.AppendLine("Close-MyRSPool")
  [Void]$StringBuilder.AppendLine("#>")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ******** RSPools Sample Code ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** RSPools Sample Code ********
  
  [Void]$StringBuilder.AppendLine("#endregion ================ Multiple Thread Functions ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptMultiThread"
}
#endregion function Build-MyScriptMultiThread

#region function Build-MyScriptJobsThreads
function Build-MyScriptJobsThreads ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptJobsThreads -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptJobsThreads"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Jobs Multi Thread <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  
  #region ******** Job Thread ScriptBlock ********
  [Void]$StringBuilder.AppendLine("#region ******** Job Thread ScriptBlock ********")
  [Void]$StringBuilder.AppendLine("`$ThreadScriptJob = {")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [String]`$ComputerName")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$ErrorActionPreference = `"Stop`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Set Default Job Data that is returned to the Main Script, Returned values cannot be `$Null, Emptry strings are OK")
  [Void]$StringBuilder.AppendLine("  `$JobData = [PSCustomObject]@{`"Status`" = `"Processing...`";")
  [Void]$StringBuilder.AppendLine("                               `"BeginTime`" = (Get-Date);")
  [Void]$StringBuilder.AppendLine("                               `"EndTime`" = `"`";")
  [Void]$StringBuilder.AppendLine("                               `"ErrorMessage`" = `"`"}")
  [Void]$StringBuilder.AppendLine("")
  #region function Test-MyWorkstation
  [Void]$StringBuilder.AppendLine("  #region function Test-MyWorkstation")
  [Void]$StringBuilder.AppendLine("  function Test-MyWorkstation()")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Verify Remote Workstation is the Correct One")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Verify Remote Workstation is the Correct One")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ComputerName")
  [Void]$StringBuilder.AppendLine("      Name of the Computer to Verify")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Credential")
  [Void]$StringBuilder.AppendLine("      Credentials to use when connecting to the Remote Computer")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Wait")
  [Void]$StringBuilder.AppendLine("      How Long to Wait for Job to be Completed")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Serial")
  [Void]$StringBuilder.AppendLine("      Return Serial Number")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Mobile")
  [Void]$StringBuilder.AppendLine("      Check if System is Desktop / Laptop")
  [Void]$StringBuilder.AppendLine("    .INPUTS")
  [Void]$StringBuilder.AppendLine("    .OUTPUTS")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Test-MyWorkstation -ComputerName `"MyWorkstation`"")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$False, ValueFromPipeline = `$True, ValueFromPipelineByPropertyName = `$True)]")
  [Void]$StringBuilder.AppendLine("      [String[]]`$ComputerName = [System.Environment]::MachineName,")
  [Void]$StringBuilder.AppendLine("      [PSCredential]`$Credential,")
  [Void]$StringBuilder.AppendLine("      [ValidateRange(30, 300)]")
  [Void]$StringBuilder.AppendLine("      [Int]`$Wait = 120,")
  [Void]$StringBuilder.AppendLine("      [Switch]`$Serial,")
  [Void]$StringBuilder.AppendLine("      [Switch]`$Mobile")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Begin")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"Enter Function Test-MyWorkstation`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Default Common Get-WmiObject Options")
  [Void]$StringBuilder.AppendLine("      if (`$PSBoundParameters.ContainsKey(`"Credential`"))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$Params = @{")
  [Void]$StringBuilder.AppendLine("          `"ComputerName`" = `$Null;")
  [Void]$StringBuilder.AppendLine("          `"Credential`" = `$Credential")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$Params = @{")
  [Void]$StringBuilder.AppendLine("          `"ComputerName`" = `$Null")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    Process")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"Enter Function Test-MyWorkstation - Process`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      ForEach (`$Computer in `$ComputerName)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        # Used to Calculate Verify Time")
  [Void]$StringBuilder.AppendLine("        `$StartTime = [DateTime]::Now")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        # Default Custom Object for the Verify Function to Return, Since it will always return a value I create the Object with the default error / failure values and update the poperties as needed")
  [Void]$StringBuilder.AppendLine("        #region >>>>>>>>>>>>>>>> Custom Return Object `$VerifyObject <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("        `$VerifyObject = [PSCustomObject]@{")
  [Void]$StringBuilder.AppendLine("          `"ComputerName`" = `$Computer.ToUpper();")
  [Void]$StringBuilder.AppendLine("          `"FQDN`" = `$Computer.ToUpper();")
  [Void]$StringBuilder.AppendLine("          `"Found`" = `$False;")
  [Void]$StringBuilder.AppendLine("          `"UserName`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Domain`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"DomainMember`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"ProductType`" = 0;")
  [Void]$StringBuilder.AppendLine("          `"Manufacturer`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Model`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"IsMobile`" = `$False;")
  [Void]$StringBuilder.AppendLine("          `"SerialNumber`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Memory`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"OperatingSystem`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"BuildNumber`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Version`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"ServicePack`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Architecture`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Is64Bit`" = `$False;")
  [Void]$StringBuilder.AppendLine("          `"LocalDateTime`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"InstallDate`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"LastBootUpTime`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"IPAddress`" = `"`";")
  [Void]$StringBuilder.AppendLine("          `"Status`" = `"Off-Line`";")
  [Void]$StringBuilder.AppendLine("          `"Time`" = [TimeSpan]::Zero")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        #endregion")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        if (`$Computer -match `"^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])`$`")")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          Try")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not")
  [Void]$StringBuilder.AppendLine("            `$IPAddresses = @([System.Net.Dns]::GetHostAddresses(`$Computer) | Where-Object -FilterScript { `$_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)")
  [Void]$StringBuilder.AppendLine("            ForEach (`$IPAddress in `$IPAddresses)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              # I think this is Faster than using Test-Connection")
  [Void]$StringBuilder.AppendLine("              if (((New-Object -TypeName System.Net.NetworkInformation.Ping).Send(`$IPAddress)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)")
  [Void]$StringBuilder.AppendLine("              {")
  [Void]$StringBuilder.AppendLine("                `$Params.ComputerName = `$IPAddress")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                # Start Setting Return Values as they are Found")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.Status = `"On-Line`"")
  [Void]$StringBuilder.AppendLine("                `$VerifyObject.IPAddress = `$IPAddress")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                # Start Primary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                [Void](`$MyJob = Get-WmiObject -AsJob @Params -Class Win32_ComputerSystem)")
  [Void]$StringBuilder.AppendLine("                # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                [Void](Wait-Job -Job `$MyJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                if (`$MyJob.State -eq `"Completed`" -and `$MyJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  # Get Job Data")
  [Void]$StringBuilder.AppendLine("                  `$MyCompData = Get-Job -ID `$MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Set Found Properties")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.ComputerName = `"`$(`$MyCompData.Name)`"")
  [Void]$StringBuilder.AppendLine("                  if (`$MyCompData.PartOfDomain)")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.FQDN = `"`$(`$MyCompData.Name)``.`$(`$MyCompData.Domain)`"")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                  else")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.FQDN = `"`$(`$MyCompData.Name)`"")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.UserName = `"`$(`$MyCompData.UserName)`"")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Domain = `"`$(`$MyCompData.Domain)`"")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.DomainMember = `$MyCompData.PartOfDomain")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Manufacturer = `"`$(`$MyCompData.Manufacturer)`"")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Model = `"`$(`$MyCompData.Model)`"")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Memory = `"`$(`$MyCompData.TotalPhysicalMemory)`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                  # Verify Remote Computer is the Connect Computer, No need to get any more information")
  [Void]$StringBuilder.AppendLine("                  if (`$MyCompData.Name -eq @(`$Computer.Split(`".`", [System.StringSplitOptions]::RemoveEmptyEntries))[0])")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    # Found Corrct Workstation")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Found = `$True")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                    [Void](`$MyJob = Get-WmiObject -AsJob @Params -Class Win32_OperatingSystem)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                    [Void](Wait-Job -Job `$MyJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                    if (`$MyJob.State -eq `"Completed`" -and `$MyJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      # Get Job Data")
  [Void]$StringBuilder.AppendLine("                      `$MyOSData = Get-Job -ID `$MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                      # Set Found Properties")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.ProductType = `$MyOSData.ProductType")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.OperatingSystem = `"`$(`$MyOSData.Caption)`"")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.ServicePack = `"`$(`$MyOSData.CSDVersion)`"")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.BuildNumber = `"`$(`$MyOSData.BuildNumber)`"")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Version = `"`$(`$MyOSData.Version)`"")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Architecture = `$(if ([String]::IsNullOrEmpty(`$MyOSData.OSArchitecture)) { `"32-bit`" }")
  [Void]$StringBuilder.AppendLine("                        else { `"`$(`$MyOSData.OSArchitecture)`" })")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Is64Bit = (`$VerifyObject.Architecture -eq `"64-bit`")")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.LocalDateTime = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.LocalDateTime)")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.InstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.InstallDate)")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.LastBootUpTime = [System.Management.ManagementDateTimeConverter]::ToDateTime(`$MyOSData.LastBootUpTime)")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                    else")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      `$VerifyObject.Status = `"Verify Operating System Error`"")
  [Void]$StringBuilder.AppendLine("                      [Void](Remove-Job -Job `$MyJob -Force)")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Optional SerialNumber Job")
  [Void]$StringBuilder.AppendLine("                    if (`$Serial.IsPresent)")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                      [Void](`$MyBIOSJob = Get-WmiObject -AsJob @Params -Class Win32_Bios)")
  [Void]$StringBuilder.AppendLine("                      # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                      [Void](Wait-Job -Job `$MyBIOSJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                      # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                      if (`$MyBIOSJob.State -eq `"Completed`" -and `$MyBIOSJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                      {")
  [Void]$StringBuilder.AppendLine("                        # Get Job Data")
  [Void]$StringBuilder.AppendLine("                        `$MyBIOSData = Get-Job -ID `$MyBIOSJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                        # Set Found Property")
  [Void]$StringBuilder.AppendLine("                        `$VerifyObject.SerialNumber = `"`$(`$MyBIOSData.SerialNumber)`"")
  [Void]$StringBuilder.AppendLine("                      }")
  [Void]$StringBuilder.AppendLine("                      else")
  [Void]$StringBuilder.AppendLine("                      {")
  [Void]$StringBuilder.AppendLine("                        `$VerifyObject.Status = `"Verify SerialNumber Error`"")
  [Void]$StringBuilder.AppendLine("                        [Void](Remove-Job -Job `$MyBIOSJob -Force)")
  [Void]$StringBuilder.AppendLine("                      }")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                    # Optional Mobile / ChassisType Job")
  [Void]$StringBuilder.AppendLine("                    if (`$Mobile.IsPresent)")
  [Void]$StringBuilder.AppendLine("                    {")
  [Void]$StringBuilder.AppendLine("                      # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer")
  [Void]$StringBuilder.AppendLine("                      [Void](`$MyChassisJob = Get-WmiObject -AsJob @Params -Class Win32_SystemEnclosure)")
  [Void]$StringBuilder.AppendLine("                      # Wait for Job to Finish or Wait Time has Elasped")
  [Void]$StringBuilder.AppendLine("                      [Void](Wait-Job -Job `$MyChassisJob -Timeout `$Wait)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                      # Check if Job is Complete and has Data")
  [Void]$StringBuilder.AppendLine("                      if (`$MyChassisJob.State -eq `"Completed`" -and `$MyChassisJob.HasMoreData)")
  [Void]$StringBuilder.AppendLine("                      {")
  [Void]$StringBuilder.AppendLine("                        # Get Job Data")
  [Void]$StringBuilder.AppendLine("                        `$MyChassisData = Get-Job -ID `$MyChassisJob.ID | Receive-Job -AutoRemoveJob -Wait -Force")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("                        # Set Found Property")
  [Void]$StringBuilder.AppendLine("                        `$VerifyObject.IsMobile = `$(@(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) -contains ((`$MyChassisData.ChassisTypes)[0]))")
  [Void]$StringBuilder.AppendLine("                      }")
  [Void]$StringBuilder.AppendLine("                      else")
  [Void]$StringBuilder.AppendLine("                      {")
  [Void]$StringBuilder.AppendLine("                        `$VerifyObject.Status = `"Verify is Mobile Error`"")
  [Void]$StringBuilder.AppendLine("                        [Void](Remove-Job -Job `$MyChassisJob -Force)")
  [Void]$StringBuilder.AppendLine("                      }")
  [Void]$StringBuilder.AppendLine("                    }")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                  else")
  [Void]$StringBuilder.AppendLine("                  {")
  [Void]$StringBuilder.AppendLine("                    `$VerifyObject.Status = `"Wrong Workstation Name`"")
  [Void]$StringBuilder.AppendLine("                  }")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("                else")
  [Void]$StringBuilder.AppendLine("                {")
  [Void]$StringBuilder.AppendLine("                  `$VerifyObject.Status = `"Verify Workstation Error`"")
  [Void]$StringBuilder.AppendLine("                  [Void](Remove-Job -Job `$MyJob -Force)")
  [Void]$StringBuilder.AppendLine("                }")
  [Void]$StringBuilder.AppendLine("                # Beak out of Loop, Verify was a Success no need to try other IP Address if any")
  [Void]$StringBuilder.AppendLine("                Break")
  [Void]$StringBuilder.AppendLine("              }")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("          Catch")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            # Workstation Not in DNS")
  [Void]$StringBuilder.AppendLine("            `$VerifyObject.Status = `"Workstation Not in DNS`"")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$VerifyObject.Status = `"Invalid Computer Name`"")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        # Calculate Verify Time")
  [Void]$StringBuilder.AppendLine("        `$VerifyObject.Time = ([DateTime]::Now - `$StartTime)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        # Return Custom Object with Collected Verify Information")
  [Void]$StringBuilder.AppendLine("        Write-Output -InputObject `$VerifyObject")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        `$VerifyObject = `$Null")
  [Void]$StringBuilder.AppendLine("        `$Params = `$Null")
  [Void]$StringBuilder.AppendLine("        `$MyJob = `$Null")
  [Void]$StringBuilder.AppendLine("        `$MyCompData = `$Null")
  [Void]$StringBuilder.AppendLine("        `$MyOSData = `$Null")
  [Void]$StringBuilder.AppendLine("        `$MyBIOSData = `$Null")
  [Void]$StringBuilder.AppendLine("        `$MyChassisData = `$Null")
  [Void]$StringBuilder.AppendLine("        `$StartTime = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("        [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"Exit Function Test-MyWorkstation - Process`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    End")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("      [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"Exit Function Test-MyWorkstation`"")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion")
  #endregion function Test-MyWorkstation
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Try")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if ((`$VerifyData = Test-MyWorkstation -ComputerName `$ComputerName).Found)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Clear all Previous Error Messages")
  [Void]$StringBuilder.AppendLine("      `$Error.Clear()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      <#")
  [Void]$StringBuilder.AppendLine("          `$VerifyData is a Custom Object the has the following properties that you can use in your script")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("          ComputerName    : This is the Name of the Computer that is found, may be different than expected computer name")
  [Void]$StringBuilder.AppendLine("          FQDN            : FQDN of Found Workstation")
  [Void]$StringBuilder.AppendLine("          Found           : True / False - This is True if the Workstation that was pinged was the expected Workstation")
  [Void]$StringBuilder.AppendLine("          UserName        : Domain\UserName of Logged on User, Will be Blank if user is Logged on via RDP")
  [Void]$StringBuilder.AppendLine("          Domain          : Domain \ WorkGroup Workstation is a member of")
  [Void]$StringBuilder.AppendLine("          DomainMember    : True if member of a Domain")
  [Void]$StringBuilder.AppendLine("          ProductType     : Product Type of Installed Operating system")
  [Void]$StringBuilder.AppendLine("          Manufacturer    : Manufacturer of Computer")
  [Void]$StringBuilder.AppendLine("          Model           : Model of Computer")
  [Void]$StringBuilder.AppendLine("          Memory          : Total Memory in Bytes")
  [Void]$StringBuilder.AppendLine("          OperatingSystem : Installed Operating System")
  [Void]$StringBuilder.AppendLine("          ServicePack     : Installed Service Pack")
  [Void]$StringBuilder.AppendLine("          BuildNumber     : Build Number of Operating System")
  [Void]$StringBuilder.AppendLine("          Architecture    : 32-Bit or 64-Bit")
  [Void]$StringBuilder.AppendLine("          LocalDateTime   : Date / Time on the Remote Workstation")
  [Void]$StringBuilder.AppendLine("          InstallDate     : Date / Time the Workstation was Imaged")
  [Void]$StringBuilder.AppendLine("          LastBootUpTime  : Date / Time the Workstation was Rebooted")
  [Void]$StringBuilder.AppendLine("          IPAddress       : IP Address of the Workstation")
  [Void]$StringBuilder.AppendLine("          Status          : On-Line, Wrong Name, Unknown, Off-Line, Error")
  [Void]$StringBuilder.AppendLine("          ErrorMessage    : Error Message if Any")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        ******** Begin Put Your Code Here ********")
  [Void]$StringBuilder.AppendLine("      #>")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Set Returned Job Data for when the Remote Workstation is found")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # if your Script Completed Sucessfully set returned `$JabData.Status to `"Done`" so row will not be processed a second time")
  [Void]$StringBuilder.AppendLine("      `$JobData.Status = `"Done`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      <#")
  [Void]$StringBuilder.AppendLine("        ******** End Put Your Code Here ********")
  [Void]$StringBuilder.AppendLine("      #>")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      # Set Returned Job Data for when the Remote Workstation is not found")
  [Void]$StringBuilder.AppendLine("      `$JobData.Status = `$VerifyData.Status")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      # Set returned Error Information `$JabData.ErrorMessage to the Last Error Message")
  [Void]$StringBuilder.AppendLine("      `$JobData.ErrorMessage = `$VerifyData.ErrorMessage")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Catch")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    # Set Returned Job Status to indicate an error")
  [Void]$StringBuilder.AppendLine("    `$JobData.Status = `"Error - Catch`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Set returned Error Information `$JabData.ErrorMessage to the last Error Message")
  [Void]$StringBuilder.AppendLine("    `$JobData.ErrorMessage = `"`$(`$Error[0].Exception.Message)`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Set Date / Time Job Finished")
  [Void]$StringBuilder.AppendLine("  `$JobData.EndTime = (Get-Date)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #Return Job Data to the Main Script")
  [Void]$StringBuilder.AppendLine("  `$JobData")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$JobData = `$Null")
  [Void]$StringBuilder.AppendLine("  `$VerifyData = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion ******** Job Thread ScriptBlock ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** Job Thread ScriptBlock ********
  
  #region function Process-ListViewItemsJobs - Job
  [Void]$StringBuilder.AppendLine("#region function Process-ListViewItemsJobs - Job")
  [Void]$StringBuilder.AppendLine("function Process-ListViewItemsJobs()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Process ListView Items in Multiple Threads")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Process ListView Items in Multiple Threads")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The ListView Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Thread")
  [Void]$StringBuilder.AppendLine("       The Script Block to Execute")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MaxThreads")
  [Void]$StringBuilder.AppendLine("      Maximum Threads to Process")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Checked")
  [Void]$StringBuilder.AppendLine("      Process Checked ListView Items")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Process-ListViewItems [-Sender ```$MyFormListView] -Thread `$Thread [-MaxThreads 4] [-Checked]")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $($MyFCGConfig.ScriptAuthor)")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.ListView]`$ListView = `$MyFormListView,")
  [Void]$StringBuilder.AppendLine("    [ScriptBlock]`$Thread = `$ThreadscriptJob,")
  [Void]$StringBuilder.AppendLine("    [Int]`$MaxThreads = 4,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Checked")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Process-ListViewItemsJobs`"")
  [Void]$StringBuilder.AppendLine("  Try")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    if (`$ListView.Items.Count)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$ListView.ListViewItemSorter.SortEnable = `$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$Script:ThreadCommand = `$False ")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      if (`$Checked)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$ItemList = @(`$ListView.CheckedItems)")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$ItemList = @(`$ListView.Items | Where-Object -FilterScript { `$PSItem.SubItems[1].Text -ne `"Done`" })")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$ThreadHash = @{}")
  [Void]$StringBuilder.AppendLine("      `$ItemCount = `$ItemList.Count - 1")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      For (`$Count = 0; `$Count -le `$ItemCount; `$Count++)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        if (`$Script:ThreadCommand)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          Write-Verbose -Message `"Break For Loop`"")
  [Void]$StringBuilder.AppendLine("          break")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        Write-Verbose -Message `"Begin Job Thread - `$Count`"")
  [Void]$StringBuilder.AppendLine("        `$ThreadHash.Add(`"`$Count`", (Start-Job -ScriptBlock `$Thread -ArgumentList (`$ItemList[`$Count].Name) -Name `"`$Count`"))")
  [Void]$StringBuilder.AppendLine("        `$ItemList[`$Count].SubItems[1].Text = `"Processing...`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        While ((`$ThreadHash.Count -eq `$MaxThreads) -or (`$ThreadHash.Count -and (`$Count -eq `$ItemCount)))")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (`$Script:ThreadCommand)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            Write-Verbose -Message `"Break Outter While Loop`"")
  [Void]$StringBuilder.AppendLine("            break")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("          While (@(`$ThreadHash.Values | Where-Object -FilterScript { `$PSItem.State -eq `"Running`" }).Count -eq `$ThreadHash.Count)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("            Start-Sleep -Milliseconds 100")
  [Void]$StringBuilder.AppendLine("            if (`$Script:ThreadCommand)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              Write-Verbose -Message `"Break Inner While Loop`"")
  [Void]$StringBuilder.AppendLine("              break")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("          if ((`$FailedJobs = @(`$ThreadHash.Values | Where-Object -FilterScript { @(`"Running`", `"Completed`") -NotContains `$PSItem.State })).Count)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            ForEach (`$FailedJob in `$FailedJobs)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              `$ThreadNum = `$([int]`$(`$FailedJob.Name))")
  [Void]$StringBuilder.AppendLine("              Write-Verbose -Message `"Failed Job Thread - `$ThreadNum`"")
  [Void]$StringBuilder.AppendLine("              `$ItemList[`$ThreadNum].SubItems[1].Text = `"Failed`"")
  [Void]$StringBuilder.AppendLine("              `$ThreadHash.Remove(`$FailedJob.Name)")
  [Void]$StringBuilder.AppendLine("              [Void](Remove-Job -Id `$FailedJob.ID -Force)")
  [Void]$StringBuilder.AppendLine("              [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("          if ((`$FinishedJobs = @(`$ThreadHash.Values | Where-Object -FilterScript { `$PSItem.State -eq `"Completed`"})).Count)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            ForEach (`$FinishedJob in `$FinishedJobs)")
  [Void]$StringBuilder.AppendLine("            {")
  [Void]$StringBuilder.AppendLine("              `$ThreadNum = `$([int]`$(`$FinishedJob.Name))")
  [Void]$StringBuilder.AppendLine("              Write-Verbose -Message `"Completed Job Thread - `$ThreadNum`"")
  [Void]$StringBuilder.AppendLine("              `$JobData = Receive-Job -Id `$FinishedJob.ID -Wait -AutoRemoveJob ")
  [Void]$StringBuilder.AppendLine("              `$ItemList[`$ThreadNum].SubItems[1].Text = `$JobData.Status")
  [Void]$StringBuilder.AppendLine("              if (`$Checked)")
  [Void]$StringBuilder.AppendLine("              {")
  [Void]$StringBuilder.AppendLine("                `$ItemList[`$ThreadNum].Checked = `$False")
  [Void]$StringBuilder.AppendLine("              }")
  [Void]$StringBuilder.AppendLine("              `$ThreadHash.Remove(`$FinishedJob.Name)")
  [Void]$StringBuilder.AppendLine("              [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("            }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"Begin Removing Remaining Jobs`"")
  [Void]$StringBuilder.AppendLine("      [Void](Get-Job | Remove-Job -Force)")
  [Void]$StringBuilder.AppendLine("      Write-Verbose -Message `"End Removing Remaining Jobs`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$ThreadHash = `$Null")
  [Void]$StringBuilder.AppendLine("      `$ItemCount = `$Null")
  [Void]$StringBuilder.AppendLine("      `$Count = `$Null")
  [Void]$StringBuilder.AppendLine("      `$ItemList = `$Null")
  [Void]$StringBuilder.AppendLine("      `$ThreadNum = `$Null")
  [Void]$StringBuilder.AppendLine("      `$FinishedJobs = `$Null")
  [Void]$StringBuilder.AppendLine("      `$FinishedJob = `$Null")
  [Void]$StringBuilder.AppendLine("      `$FailedJobs = `$Null")
  [Void]$StringBuilder.AppendLine("      `$FailedJob = `$Null")
  [Void]$StringBuilder.AppendLine("      `$Script:ThreadCommand = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("      [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$ListView.ListViewItemSorter.SortEnable = `$True")
  [Void]$StringBuilder.AppendLine("      `$ListView.Sort()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Catch")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    Write-Debug -Message `"ErrMsg: `$(`$Error[0].Exception.Message)`"")
  [Void]$StringBuilder.AppendLine("    Write-Debug -Message `"Line: `$(`$Error[0].InvocationInfo.ScriptLineNumber)`"")
  [Void]$StringBuilder.AppendLine("    Write-Debug -Message `"Code: `$((`$Error[0].InvocationInfo.Line).Trim())`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Process-ListViewItemsJobs`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Process-ListViewItemsJobs - Job")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Process-ListViewItemsJobs - Job
  
  [Void]$StringBuilder.AppendLine("#endregion ================ Jobs Multi Thread ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptJobsThreads"
}
#endregion function Build-MyScriptJobsThreads

#region function Build-MyScriptCustom
function Build-MyScriptCustom ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptCustom -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptCustom"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> $($MyScriptName) Custom Code <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  
  #region ******** $FormIcon ********
  [Void]$StringBuilder.AppendLine("#region ******** `$$($MyScriptName)FormIcon ********")
  [Void]$StringBuilder.AppendLine("# Icons for Forms are 16x16")
  [Void]$StringBuilder.AppendLine("`$$($MyScriptName)FormIcon = @`"")
  [Void]$StringBuilder.AppendLine("AAABAAEAEBAAAAAAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgTgAAHpfAACDQQAAiQIAAAAAAAAAAAAAAAAAAAAA/T8SBPxFEUb8UxJe/D4MMQAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAgKODAAAiLkJCaH/CAi6/wAAsv8AAJDMAACQGQAAAAAAAAAA/VYlIf11Ldb8p0X//KU8//yRKP/8UxCr/EQMBwcHlpUnJ7L/QEDH/05O1v9DQ+D/DQ3f/wAAlbsAAAAAAAAAAP19Q8f9wnn//ceE//7I")
  [Void]$StringBuilder.AppendLine("hv/9vW3//KE0//xQEIgODp7vIyOx/zIyw/8+PtP/R0fg/0RE7P8EBMP/BgCTHulKOST+unX//saF//7Jif/+yIj//seD//29av/8ch3qBwea+xkZrf8iIr//LS3P/zU13f85Oer/Fhbe/wcAmTTnTkAy/sWG//7K")
  [Void]$StringBuilder.AppendLine("kP/+ypD//siK//3FgP/9wHT//Icx/QAAmsKOjtf/Gxu9/xsby/8hIdr/JSXo/xER1fQHA6oL51FFCP6me+7+6NH//syX//7Iiv/+wnz//bxr//16M80GBp82MjK19aqq5v85OdL/Nzfe/w8P5P8HB8l0AAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAD+clpg/9a9/v7r1//+zpj//saE//2nWPv9XitFAAAAAAwMqC4GBq+qEBDA211d1cIRF79bAAAAAAAAAAAAAAAAAAAAAO90Wkn+kWy6/qV63P6Zd7X+Yjg9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFHlpDxCZ")
  [Void]$StringBuilder.AppendLine("QowSp0LUEKI90RGUM4NGhjgKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFKtQBx20V8060Hv/RtOC/znNd/8XvFX/DZo1wgqWNAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABq2")
  [Void]$StringBuilder.AppendLine("XWU/14b/UNuR/1rclf9i25f/WNaN/xq6VP8MlzVcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkxW6aPNyL/0nekv9R3pX/VtuU/1fYkP89znn/D6A8lwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAIMNthF/mpf9E4pb/R+CU/0nckP9I14n/P9B9/xKnRYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABy6ZShU4p/5tvXY/0Pilv8724r/OdWB/yzJb/0UqUw0AAAAAAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAAAAAAAAAAAAAAAAKsR1VlTfnfOA7Lj/iuq6/zfPfPkYtVprAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAivWoSJcNwVDLEdVk0um0bAAAAAAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAw8MAAAGAAAABgAAAAAAAAAAAAAAAAAAAAYAAAIPBAAD4HwAA8A8AAPAPAADwDwAA8A8AAPAPAAD4HwAA/D8AAA==")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("#endregion ******** `$$($MyScriptName)FormIcon ********")
  [Void]$StringBuilder.AppendLine("#`$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String(`$$($MyScriptName)FormIcon)))")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** $FormIcon ********
  
  #region ******** $ExitIcon ********
  [Void]$StringBuilder.AppendLine("#region ******** `$ExitIcon ********")
  [Void]$StringBuilder.AppendLine("`$ExitIcon = @`"")
  [Void]$StringBuilder.AppendLine("AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1ToVAgWar/F0B5/wAAAFcAAABNAAAAIQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAAAAABxQnCIfWKjvI1+x/xY8cv8AAABDAAAAPgAAADoAAAAmAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcUp/TIV6x/ylktP8VOW3/AAAALgAAACkAAAAjAAAAHgAAABgAAAAFAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAAAAAAAAAAAjYLP/HlSg/yVkt/8ybrz/FDhq/wAAADgAAAAuAAAAJAAAABgAAAAJI2Cz/wAAAAAAAAAAAAAAAAAAAAAAAAAAJWS3/yFZpv8par3/O3fC/xM1Zf8AAAA4AAAALgAAACQAAAAYAAAACQ6F")
  [Void]$StringBuilder.AppendLine("RP8AcwD/AAAAAAAAAAAAAAAAAAAAAGRziP8kXqr/LG/C/0Bup/85SmL/AAAAOAAAAC4AAAAkAAAAGACUAKQAmQD/AHMA/wAAAAAAAAAAAAAAAAAAAAAqar7/J2Ov/y90yP9adpb/Tl93/wAAADgAAAAuAAAAJACE")
  [Void]$StringBuilder.AppendLine("AG8AmQD/a8lw/wBzAP8AcwD/AHMA/wBzAP8AcwD/LG3B/ylmtP8yec3/VJHV/xQ2Z/8AAAA4AAAALgB7AHcAmQD/V8Bb/0q8T/9Yw17/X8Zm/2bKbv910H3/AHMA/y1ww/8rarf/NH3Q/1yZ2/8UNmf/AAAAOAAA")
  [Void]$StringBuilder.AppendLine("AC4AmQD/fs6A/0K4Rv82tDv/PrhE/0a8TP9QwVf/Zspu/wBzAP8vcsb/LWy6/zeA0/9koOD/FDZn/wAAADgAAAAuAHsAdwCZAP+Az4L/ccp0/2zIcP93zXz/ftCC/2jJbv8AcwD/MHTI/y5uvP84gtb/YaDh/xQ2")
  [Void]$StringBuilder.AppendLine("Z/8AAAA4AAAALgAAACQAhABvAJkA/4TQhv8AmQD/AJkA/wCZAP8AmQD/AJkA/2Z2i/8vcL7/P4jZ/4m/7v8vYpa/AAAAOAAAAC4AAAAkAAAAGACUAKQAmQD/AJkA/wAAAAAAAAAAAAAAAAAAAAAxdsr/M3TA/3ey")
  [Void]$StringBuilder.AppendLine("6P9xnsO/AAMFRgAAADgAAAAuAAAAJAAAABgAAAAJEoxM/wCZAP8AAAAAAAAAAAAAAAAAAAAAMnfL/0yMz/9FgsDeAAMFRgADBUYAAAA4AAAALgAAACQAAAAYAAAACTJ3y/8AAAAAAAAAAAAAAAAAAAAAAAAAADJ3")
  [Void]$StringBuilder.AppendLine("y/8yd8v/MnfL/zJ3y/8yd8v/MnfL/zJ3y/8yd8v/MnfL/zJ3y/8yd8v/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAwP+sQYA/rEGAH6xBAB+sQQAPrEEAD6xBAACsQQAArEEAAKxBAACsQQAArEEAD6xBAA+sQQAfrEEAH6xB//+sQQ==")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("#endregion ******** `$ExitIcon ********")
  [Void]$StringBuilder.AppendLine("#`$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String(`$ExitIcon)))")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** $ExitIcon ********
  
  #region ******** $HelpIcon ********
  [Void]$StringBuilder.AppendLine("#region ******** `$HelpIcon ********")
  [Void]$StringBuilder.AppendLine("`$HelpIcon = @`"")
  [Void]$StringBuilder.AppendLine("AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC6XSwQvF8sgMFiLd/IZzH/0nI7/9Z7Q//UeD7/0W8yz9VyM2AAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAAAAAAAAAAC2Wiswulwr38lgKP/WaCv/2nE1/998P//jiUr/6Jlb/+ypbv/kl1r/23s7z9x3NRAAAAAAAAAAAAAAAACyVykwuVkr78xbKf/SYSX/1mkq/+CPXv/w4t7/8NrM/+uWUv/vnFL/9bRu//W9")
  [Void]$StringBuilder.AppendLine("f//ffj3P23Y1EAAAAAAAAAAAs1cqz8heMf/OWiL/0mEk/9ZpKv/lrIz/8Ojo//Do6P/spnD/75pO//SlVv/5uG//8bZ3/9h0NK8AAAAArlMoYLxeM//LWyj/zlke/9FgJP/VZyn/23c7/+rFsf/qvJ3/6IxE/+yV")
  [Void]$StringBuilder.AppendLine("S//xnVH/9KNV//S2df/fjVD/03AzMKxSKK/Ia0L/ylMb/81XHf/QXiL/1GUn/+Sri//x6ur/8enp/+WGQP/pjkb/7JRK/+6YTf/unFP/56Bm/9BuMo+yWzP/0XhP/8tUHf/MVRz/z1sg/9NiJf/gmXL/8uvr//Lq")
  [Void]$StringBuilder.AppendLine("6v/mm2f/5YY//+eLQ//pjkX/6Y5F/+eZXv/MazG/tWA5/9J4Tv/QZTL/zVgh/85YHv/RXiP/1GUn/+7UyP/z7Oz/79bK/+GERP/igTz/44M+/+ODPv/iilD/yWkwv7VhO//Vflb/0GY0/9FnNP/RYy3/z10j/9Jg")
  [Void]$StringBuilder.AppendLine("JP/YdkD/8uXi//Pt7f/sx7P/3Xc1/955Nv/eeTb/3ntD/8VmL7+qUyzf2o5s/9BlNP/RZjT/0mg0/9NrNf/UajL/1Ggu/9+Saf/17+//9O7u/91/R//acDD/2nAw/9hwOP/CYy6vpUwmj9GKav/TckX/0GY0/9Fn")
  [Void]$StringBuilder.AppendLine("NP/puaL/7su7/96PZv/rwq3/9vLy//Xw8P/ei1z/2nU7/9p1O//PbTX/v2AtYKRMJSC0Yj7/3ZNy/9BlNP/WeU3//v39//z7+//7+Pj/+fb2//j19f/z4tv/1m83/9dwOP/Vbzf/v2Au77xeLBAAAAAApEslgMd9")
  [Void]$StringBuilder.AppendLine("XP/bjGn/0Gg4/9mCWv/wzr///fz8//z6+v/uy7r/2oVZ/9RrNv/UbDn/wmEv/7hbK1AAAAAAAAAAAAAAAACjSyWfw3dV/96Xd//UeE7/0Gg4/9BmNP/RZjT/0Wk4/9JuQP/QbUP/vV4x/7RZKmAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAAAAAAAKNLJXCtWDLvxntZ/86DYv/XjGv/1Ihl/8h1T/+9ZTz/slcr37FWKVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApEwlEKVMJmCmTiaPqE8mv6lQJ7+rUSeArFIoUAAAAAAAAAAAAAAAAAAA")
  [Void]$StringBuilder.AppendLine("AAAAAAAA4A+sQcADrEGAAaxBgAGsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgAGsQcADrEHgB6xB8B+sQQ==")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("#endregion ******** `$HelpIcon ********")
  [Void]$StringBuilder.AppendLine("#`$Form.Icon = New-Object -TypeName System.Drawing.Icon(New-Object -TypeName System.IO.MemoryStream([System.Convert]::FromBase64String(`$HelpIcon)))")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** $HelpIcon ******** 
  
  [Void]$StringBuilder.AppendLine("#endregion ================ $($MyScriptName) Custom Code ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptCustom"
}
#endregion function Build-MyScriptCustom

#region function Build-MyScriptListViewSort
function Build-MyScriptListViewSort ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptListViewSort -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
  )
  Write-Verbose -Message "Enter Function Build-MyScriptListViewSort"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> My Custom ListView Sort <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$MyCode = @`"")
  [Void]$StringBuilder.AppendLine("using System;")
  [Void]$StringBuilder.AppendLine("using System.Windows.Forms;")
  [Void]$StringBuilder.AppendLine("using System.Collections;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("namespace MyCustom")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  public class ListViewSort : IComparer")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    private int _Column = 0;")
  [Void]$StringBuilder.AppendLine("    private bool _Ascending = true;")
  [Void]$StringBuilder.AppendLine("    private bool _Enable = true;")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public ListViewSort()")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      _Column = 0;")
  [Void]$StringBuilder.AppendLine("      _Ascending = true;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public ListViewSort(int Column)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      _Column = Column;")
  [Void]$StringBuilder.AppendLine("      _Ascending = true;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public ListViewSort(int Column, bool Order)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      _Column = Column;")
  [Void]$StringBuilder.AppendLine("      _Ascending = Order;")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public int Column")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      get { return _Column; }")
  [Void]$StringBuilder.AppendLine("      set { _Column = value; }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public bool Ascending")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      get { return _Ascending; }")
  [Void]$StringBuilder.AppendLine("      set { _Ascending = value; }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public bool Enable")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      get { return _Enable; }")
  [Void]$StringBuilder.AppendLine("      set { _Enable = value; }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    public int Compare(object RowX, object RowY)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if (_Enable)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        if (_Ascending)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          return String.Compare(((System.Windows.Forms.ListViewItem)RowX).SubItems[_Column].Text, ((System.Windows.Forms.ListViewItem)RowY).SubItems[_Column].Text);")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          return String.Compare(((System.Windows.Forms.ListViewItem)RowY).SubItems[_Column].Text, ((System.Windows.Forms.ListViewItem)RowX).SubItems[_Column].Text);")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      else")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        return 0;")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("`"@")
  [Void]$StringBuilder.AppendLine("Add-Type -TypeDefinition `$MyCode -ReferencedAssemblies `"System.Windows.Forms`" -Debug:`$False")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion ================ My Custom ListView Sort ================")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptListViewSort"
}
#endregion function Build-MyScriptListViewSort


#region function Build-MyScriptDialog
function Build-MyScriptDialog ()
{
  <#
    .SYNOPSIS
      Gererates Script Dialog
    .DESCRIPTION
      Gererates Script Dialog
    .PARAMETER MyScriptName
    .PARAMETER MyControlName
    .PARAMETER MyControlType
    .EXAMPLE
      Build-MyScriptDialog -MyScriptName $MyScriptName -MyControlName $MyControlName -MyControlType $MyControlType
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [parameter(Mandatory = $True)]
    [String]$MyControlName,
    [parameter(Mandatory = $True)]
    [ValidateSet("GroupBox", "Panel", "SplitContainer")]
    [String]$MyControlType
  )
  Write-Verbose -Message "Enter Function Build-MyScriptDialog"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  
  [Void]$StringBuilder.AppendLine("#region function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("function Show-$($MyControlName)Dialog ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DialogTitle")
  if ($MyControlType -eq "GroupBox")
  {
    [Void]$StringBuilder.AppendLine("    .PARAMETER GroupText")
  }
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Height")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonLeft")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonMid")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonRight")
  if ($MyControlType -eq "GroupBox")
  {
    [Void]$StringBuilder.AppendLine("    .EXAMPLE")
    [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle -GroupBoxText `$GroupBoxText")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("    .EXAMPLE")
    [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle")
  }
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$DialogTitle = `"`$(`$$($MyScriptName)Config.ScriptName)`",")
  if ($MyControlType -eq "GroupBox")
  {
    [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
    [Void]$StringBuilder.AppendLine("    [String]`$GroupBoxText,")
  }
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = 35,")
  [Void]$StringBuilder.AppendLine("    [Int]`$Height = 15,")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonLeft = `"&OK`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonMid = `"&Reset`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonRight = `"&Cancel`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region >>>>>>>>>>>>>>>> Begin **** $($MyControlName)Dialog **** Begin <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogFormComponents = New-Object -TypeName System.ComponentModel.Container")
  [Void]$StringBuilder.AppendLine("")
  
  #region Dialog Form
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog Form")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Icon = `$$($MyScriptName)Form.Icon")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.KeyPreview = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MaximizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), (`$$($MyScriptName)Config.Font.Height * `$Height))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Name = `"$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Owner = `$$($MyScriptName)Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ShowInTaskbar = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Text = `$DialogTitle")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormKeyDown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormKeyDown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.Close()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::Arrow")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_KeyDown({ Start-$($MyControlName)DialogFormKeyDown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormLoad ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormLoad")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Load Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Load Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Load Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Load Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormLoad -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Load Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::Arrow")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Load Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormLoad ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Load({ Start-$($MyControlName)DialogFormLoad -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormMove")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Move Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Move Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormMove -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::Arrow")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Move({ Start-$($MyControlName)DialogFormMove -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormShown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Shown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Shown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormShown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Sender.Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    #`$$($MyControlName)DialogForm.Cursor = [System.Windows.Forms.Cursors]::Arrow")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Shown({ Start-$($MyControlName)DialogFormShown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion Dialog Form
  
  Switch ($MyControlType)
  {
    "GroupBox"
    {
      #region Main GroupBox
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain GroupBox")
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox")
      [Void]$StringBuilder.AppendLine("  # Location of First Control = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.Font.Height)")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainGroupBox)")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainGroupBox.BackColor = `$$($MyScriptName)Config.Colors.Back")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainGroupBox.Font = `$$($MyScriptName)Config.Font.Bold")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainGroupBox.ForeColor = `$$($MyScriptName)Config.Colors.GroupFore")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainGroupBox.Name = `"$($MyControlName)DialogMainGroupBox`"")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainGroupBox.Text = `$GroupBoxText")
      [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainGroupBox Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size((`$(`$$($MyControlName)DialogMainGroupBox.Controls[`$$($MyControlName)DialogMainGroupBox.Controls.Count - 1]).Right + `$$($MyScriptName)Config.FormSpacer), (`$(`$$($MyControlName)DialogMainGroupBox.Controls[`$$($MyControlName)DialogMainGroupBox.Controls.Count - 1]).Bottom + `$$($MyScriptName)Config.FormSpacer))")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainGroupBox Controls ********")
      [Void]$StringBuilder.AppendLine("")
      #endregion Main GroupBox
      Break
    }
    "Panel"
    {
      #region Main Panel
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain Panel")
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainPanel)")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainPanel.BackColor = `$$($MyScriptName)Config.Colors.Back")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Name = `"$($MyControlName)DialogMainPanel`"")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Text = `"$($MyControlName)DialogMainPanel`"")
      [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainPanel Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainPanel.ClientSize = New-Object -TypeName System.Drawing.Size((`$(`$$($MyControlName)DialogMainPanel.Controls[`$$($MyControlName)DialogMainPanel.Controls.Count - 1]).Right + `$$($MyScriptName)Config.FormSpacer), (`$(`$$($MyControlName)DialogMainPanel.Controls[`$$($MyControlName)DialogMainPanel.Controls.Count - 1]).Bottom + `$$($MyScriptName)Config.FormSpacer))")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainPanel Controls ********")
      [Void]$StringBuilder.AppendLine("")
      #endregion Main Panel
      Break
    }
    "SplitContainer"
    {
      #region Main SplitContainer
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain SplitContainer")
      [Void]$StringBuilder.AppendLine("  # ************************************************")
      [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainSplitContainer)")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.BackColor = `$$($MyScriptName)Config.Colors.Back")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.FixedPanel = [System.Windows.Forms.FixedPanel]::None")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Font = `$$($MyScriptName)Config.Font.Regular")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer.IsSplitterFixed = `$True")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer.Name = `"$($MyControlName)DialogMainSplitContainer`"")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Panel1Collapsed = `$False")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Panel1MinSize = 25")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Panel2Collapsed = `$False")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Panel2MinSize = 25")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.SplitterDistance = 50")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.SplitterIncrement = 1")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.SplitterWidth = 4")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.TabIndex = 0")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.TabStop = `$True")
      [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogMainSplitContainer.Tag = New-Object -TypeName System.Object")
      [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainSplitContainer.Text = `"$($MyControlName)DialogMainSplitContainer`"")
      [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainSplitContainer Panel1 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainSplitContainer Panel1 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainSplitContainer Panel2 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainSplitContainer Panel2 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      #endregion Main SplitContainer
      Break
    }
  }
  
  #region Bottom Panel / Buttons
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogBtm Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogBtmPanel)")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmPanel.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Name = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Text = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Evenly Space Buttons - Move Size to after Text")
  [Void]$StringBuilder.AppendLine("  `$NumButtons = 3")
  [Void]$StringBuilder.AppendLine("  `$TempSpace = [Math]::Floor(`$$($MyControlName)DialogBtmPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * (`$NumButtons + 1)))")
  [Void]$StringBuilder.AppendLine("  `$TempWidth = [Math]::Floor(`$TempSpace / `$NumButtons)")
  [Void]$StringBuilder.AppendLine("  `$TempMod = `$TempSpace % `$NumButtons")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmLeftButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Name = `"$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmLeftButton.TabIndex = 0")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmLeftButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmLeftButton.Tag = New-Object -TypeName System.Object")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Text = `$ButtonLeft")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmLeftButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmLeftButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # OK Code Goes here")
  [Void]$StringBuilder.AppendLine("    [Void][System.Windows.Forms.MessageBox]::Show(`$$($MyScriptName)Form, `"Missing or Invalid Value.`", `$$($MyScriptName)Config.ScriptName, `"OK`", `"Warning`")")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.add_Click({ Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmMidButton)")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmLeftButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Name = `"$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmMidButton.TabIndex = 0")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmMidButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmMidButton.Tag = New-Object -TypeName System.Object")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Text = `$ButtonMid")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Size = New-Object -TypeName System.Drawing.Size((`$TempWidth + `$TempMod), `$$($MyControlName)DialogBtmMidButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmMidButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.add_Click({ Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmRightButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmMidButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Name = `"$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmRightButton.TabIndex = 0")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmRightButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmRightButton.Tag = New-Object -TypeName System.Object")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Text = `$ButtonRight")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmRightButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmRightButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName))")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Cancel Code Goes here")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.add_Click({ Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.ClientSize = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogBtmRightButton.Right + `$$($MyScriptName)Config.FormSpacer), (`$$($MyControlName)DialogBtmRightButton.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  #endregion Bottom Panel / Buttons
  
  [Void]$StringBuilder.AppendLine("  #endregion ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ================ End **** $($MyControlName)Dialog **** End ================")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if ((`$DialogResult = `$$($MyControlName)DialogForm.ShowDialog()) -eq [System.Windows.Forms.DialogResult]::OK)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$ReturnValue = @()")
  [Void]$StringBuilder.AppendLine("    @{`"Success`" = `$True; `"DialogResult`" = `$DialogResult; `"ReturnValue`" = `$ReturnValue}")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    @{`"Success`" = `$False; `"DialogResult`" = `$DialogResult}")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogFormComponents.Dispose()")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("")
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptDialog"
}
#endregion function Build-MyScriptDialog

#region function Build-MyScriptUserInputDialog
function Build-MyScriptUserInputDialog ()
{
  <#
    .SYNOPSIS
      Gererates Script Dialog
    .DESCRIPTION
      Gererates Script Dialog
    .PARAMETER MyScriptName
    .EXAMPLE
      Build-MyScriptUserInputDialog -MyScriptName $MyScriptName -MyControlName $MyControlName -MyControlType $MyControlType
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [parameter(Mandatory = $True)]
    [String]$MyControlName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptUserInputDialog"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ********* My Code ********
  
  #region function Show-MyControlNameDialog
  [Void]$StringBuilder.AppendLine("#region function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("function Show-$($MyControlName)Dialog ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DialogTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MessageText")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Items")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MaxLength")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Multi")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Height")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonLeft")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonMid")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonRight")
  [Void]$StringBuilder.AppendLine("    .PARAMETER AutoClose")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding(DefaultParameterSetName = `"Single`")]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$DialogTitle = `"`$(`$$($MyScriptName)Config.ScriptName)`",")
  [Void]$StringBuilder.AppendLine("    [String]`$MessageText = `"Status Message`",")
  [Void]$StringBuilder.AppendLine("    [String[]]`$Items = @(),")
  [Void]$StringBuilder.AppendLine("    [Int]`$MaxLength = [Int]::MaxValue,")
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = 35,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True, ParameterSetName = `"Multi`")]")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Multi,")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$False, ParameterSetName = `"Multi`")]")
  [Void]$StringBuilder.AppendLine("    [Int]`$Height = 18,")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonLeft = `"&OK`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonMid = `"&Reset`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonRight = `"&Cancel`",")
  [Void]$StringBuilder.AppendLine("    [Switch]`$AutoClose")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region >>>>>>>>>>>>>>>> Begin **** $($MyControlName)Dialog **** Begin <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog Form")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Icon = `$$($MyScriptName)Form.Icon")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.KeyPreview = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MaximizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  if (`$Multi.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), (`$$($MyScriptName)Config.Font.Height * `$Height))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), 0)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Name = `"$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Owner = `$$($MyScriptName)Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ShowInTaskbar = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Text = `$DialogTitle")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormKeyDown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormKeyDown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By MyUserName)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.Close()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_KeyDown({ Start-$($MyControlName)DialogFormKeyDown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormShown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Shown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Shown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormShown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.DeselectAll()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Sender.Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Shown({ Start-$($MyControlName)DialogFormShown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Name = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Text = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"MessageText`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    #region `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)MainLabel)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Name = `"$($MyControlName)MainLabel`"")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), 23)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Text = `$MessageText")
  [Void]$StringBuilder.AppendLine("    #endregion `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Returns the minimum size required to display the text")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText(`$$($MyControlName)MainLabel.Text, `$$($MyControlName)MainLabel.Font, `$$($MyControlName)MainLabel.Size, ([System.Windows.Forms.TextFormatFlags](`"Top`", `"Left`", `"WordBreak`")))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$TempBottom = `$$($MyControlName)MainLabel.Bottom")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempBottom = 0")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)MainTextBox)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.AutoSize = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$TempBottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.MaxLength = `$MaxLength")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Multiline = `$Multi.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Name = `"$($MyControlName)MainTextBox`"")
  [Void]$StringBuilder.AppendLine("  if (`$Multi.IsPresent)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.Lines = `$Items")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), (`$$($MyControlName)DialogMainPanel.ClientSize.Height - (`$$($MyControlName)MainTextBox.Top + `$$($MyScriptName)Config.FormSpacer)))")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::None")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.Text = `$Items[0]")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainTextBox.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), `$$($MyControlName)MainTextBox.PreferredHeight)")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.TabIndex = 0")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.WordWrap = `$False")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$TempClientSize = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)MainTextBox.Right + `$$($MyScriptName)Config.FormSpacer), (`$$($MyControlName)MainTextBox.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogBtm Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogBtmPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Name = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Text = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Evenly Space Buttons - Move Size to after Text")
  [Void]$StringBuilder.AppendLine("  `$NumButtons = 3")
  [Void]$StringBuilder.AppendLine("  `$TempSpace = [Math]::Floor(`$$($MyControlName)DialogBtmPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * (`$NumButtons + 1)))")
  [Void]$StringBuilder.AppendLine("  `$TempWidth = [Math]::Floor(`$TempSpace / `$NumButtons)")
  [Void]$StringBuilder.AppendLine("  `$TempMod = `$TempSpace % `$NumButtons")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmLeftButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Name = `"$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabIndex = 1")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Text = `$ButtonLeft")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmLeftButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmLeftButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By MyUserName)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`"`$(`$$($MyControlName)MainTextBox.Text.Trim())`".Length)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void][System.Windows.Forms.MessageBox]::Show(`$$($MyControlName)DialogForm, `"Missing or Invalid Value.`", `$$($MyScriptName)Config.ScriptName, `"OK`", `"Warning`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.add_Click({ Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmMidButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmLeftButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Name = `"$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.TabIndex = 2")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Text = `$ButtonMid")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Size = New-Object -TypeName System.Drawing.Size((`$TempWidth + `$TempMod), `$$($MyControlName)DialogBtmMidButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmMidButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By MyUserName)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$Multi.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)MainTextBox.Lines = `$Items")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)MainTextBox.Text = `$Items[0]")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.add_Click({ Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmRightButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmMidButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Name = `"$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabIndex = 3")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Text = `$ButtonRight")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmRightButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmRightButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By MyUserName)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Cancel Code Goes here")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.add_Click({ Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.ClientSize = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogBtmRightButton.Right + `$$($MyScriptName)Config.FormSpacer), (`$$($MyControlName)DialogBtmRightButton.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ClientSize = New-Object -TypeName System.Drawing.Size(`$$($MyControlName)DialogForm.ClientSize.Width, (`$TempClientSize.Height + `$$($MyControlName)DialogBtmPanel.Height))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ================ End **** $($MyControlName)Dialog **** End ================")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$DialogResult = `$$($MyControlName)DialogForm.ShowDialog()")
  [Void]$StringBuilder.AppendLine("  @{`"Success`" = (`$DialogResult -eq [System.Windows.Forms.DialogResult]::OK); `"DialogResult`" = `$DialogResult; `"Items`" = `$$($MyControlName)MainTextBox.Lines}")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Show-MyControlNameDialog
  
  #endregion ********* My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptUserInputDialog"
}
#endregion function Build-MyScriptUserInputDialog

#region function Build-MyScriptInfoDialog
function Build-MyScriptInfoDialog ()
{
  <#
    .SYNOPSIS
      Gererates Script Dialog
    .DESCRIPTION
      Gererates Script Dialog
    .PARAMETER MyScriptName
    .EXAMPLE
      Build-MyScriptInfoDialog -MyScriptName $MyScriptName -MyControlName $MyControlName -MyControlType $MyControlType
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [parameter(Mandatory = $True)]
    [String]$MyControlName,
    [parameter(Mandatory = $True)]
    [ValidateSet("WebBrowser", "RichTextBox")]
    [String]$MyControlType
  )
  Write-Verbose -Message "Enter Function Build-MyScriptInfoDialog"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ********* My Code ********
  
  #region MyControlName Dialog Info Topics
  [Void]$StringBuilder.AppendLine("#region $($MyControlName) Dialog Info Topics")
  [Void]$StringBuilder.AppendLine("")
  if ($MyControlType -eq "WebBrowser")
  {
    [Void]$StringBuilder.AppendLine("# Compressed HTML")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$InfoIntro Compressed HTML")
    [Void]$StringBuilder.AppendLine("`$InfoIntro = @`"")
    [Void]$StringBuilder.AppendLine("H4sIAAAAAAAEAHu/e79NRklujh0vl4KCTUZqYgqYBWSXZJbkpNr5Rip4pOYUKITkF2QmF9voQ0TBivXhqm2S8lMqYfpSMssUEnMy0/NslZJT80pSi5TsbDKKgNjIDmySZ15JUX5KaXJJZn4e0AwjiKw+UBvMhKQi")
    [Void]$StringBuilder.AppendLine("KCskI7NYAYh8KxUwtEKcALcYzgQaCfKOggIAU+uXZNoAAAA=")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$InfoIntro Compressed HTML")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info01 Compressed HTML")
    [Void]$StringBuilder.AppendLine("`$Info01 = @`"")
    [Void]$StringBuilder.AppendLine("H4sIAAAAAAAEAHu/e79NRklujh0vl4KCTUZqYgqYBWSXZJbkpNr5Rip4pOYUKITkF2QmF9voQ0TBivXhqm2S8lMqYfpSMssUEnMy0/NslZJT80pSi5TsbDKKgNjIDmGSgoEhUL8RREYfqAWmO6kIygrJyCxWACLf")
    [Void]$StringBuilder.AppendLine("SiQHQOyF2wZnAs0C+UFBAQAohQVwzwAAAA==")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info01 Compressed HTML")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info02 Compressed HTML")
    [Void]$StringBuilder.AppendLine("`$Info02 = @`"")
    [Void]$StringBuilder.AppendLine("H4sIAAAAAAAEAHu/e79NRklujh0vl4KCTUZqYgqYBWSXZJbkpNr5Rip4pOYUKITkF2QmF9voQ0TBivXhqm2S8lMqYfpSMssUEnMy0/NslZJT80pSi5TsbDKKgNjIDmGSgoERUL8RREYfqAWmO6kIygrJyCxWACLf")
    [Void]$StringBuilder.AppendLine("SiQHQOyF2wZnAs0C+UFBAQDX1agEzwAAAA==")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info02 Compressed HTML")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info03 Compressed HTML")
    [Void]$StringBuilder.AppendLine("`$Info03 = @`"")
    [Void]$StringBuilder.AppendLine("H4sIAAAAAAAEAHu/e79NRklujh0vl4KCTUZqYgqYBWSXZJbkpNr5Rip4pOYUKITkF2QmF9voQ0TBivXhqm2S8lMqYfpSMssUEnMy0/NslZJT80pSi5TsbDKKgNjIDmGSgoExUL8RREYfqAWmO6kIygrJyCxWACLf")
    [Void]$StringBuilder.AppendLine("SiQHQOyF2wZnAs0C+UFBAQC95xyezwAAAA==")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info03 Compressed HTML")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("# Web Site / Pages")
    [Void]$StringBuilder.AppendLine("#`$InfoIntro = `"http://www.MyDomain.Local/Help/Intro,html`"")
    [Void]$StringBuilder.AppendLine("#`$Info01 = `"http://www.MyDomain.Local/Help/Topic01.html`"")
    [Void]$StringBuilder.AppendLine("#`$Info02 = `"http://www.MyDomain.Local/Help/Topic02.html`"")
    [Void]$StringBuilder.AppendLine("#`$Info03 = `"http://www.MyDomain.Local/Help/Topic03.html`"")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("#region `$InfoIntro Compressed RTF")
    [Void]$StringBuilder.AppendLine("`$InfoIntro = @`"")
    [Void]$StringBuilder.AppendLine("77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p")
    [Void]$StringBuilder.AppendLine("bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgSW50b2R1Y3Rpb25ccGFyDQpcYjBc")
    [Void]$StringBuilder.AppendLine("ZjFcZnMyMFxwYXINClRoaXMgaXMgTXkgSGVscCBJbnRvZHVjdGlvbiFccGFyDQoNClxwYXJkXHNhMjAwXHNsMjc2XHNsbXVsdDFcZjJcZnMyMlxsYW5nOVxwYXINCn0NCgA=")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$InfoIntro Compressed RTF")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info01 Compressed RTF")
    [Void]$StringBuilder.AppendLine("`$Info01 = @`"")
    [Void]$StringBuilder.AppendLine("77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p")
    [Void]$StringBuilder.AppendLine("bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMDFccGFyDQpcYjBcZjFc")
    [Void]$StringBuilder.AppendLine("ZnMyMFxwYXINClRoaXMgaXMgTXkgSGVscCBUb3BpYyFccGFyDQoNClxwYXJkXHNhMjAwXHNsMjc2XHNsbXVsdDFcZjJcZnMyMlxsYW5nOVxwYXINCn0NCgA=")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info01 Compressed RTF")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info02 Compressed RTF")
    [Void]$StringBuilder.AppendLine("`$Info02 = @`"")
    [Void]$StringBuilder.AppendLine("77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p")
    [Void]$StringBuilder.AppendLine("bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMFxmMSAyXGYwXHBhcg0K")
    [Void]$StringBuilder.AppendLine("XGIwXGYxXGZzMjBccGFyDQpUaGlzIGlzIE15IEhlbHAgVG9waWMhXHBhcg0KDQpccGFyZFxzYTIwMFxzbDI3NlxzbG11bHQxXGYyXGZzMjJcbGFuZzlccGFyDQp9DQoA")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info02 Compressed RTF")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("#region `$Info03 Compressed RTF")
    [Void]$StringBuilder.AppendLine("`$Info03 = @`"")
    [Void]$StringBuilder.AppendLine("77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p")
    [Void]$StringBuilder.AppendLine("bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMFxmMSAzXGYwXHBhcg0K")
    [Void]$StringBuilder.AppendLine("XGIwXGYxXGZzMjBccGFyDQpUaGlzIGlzIE15IEhlbHAgVG9waWMhXHBhcg0KDQpccGFyZFxzYTIwMFxzbDI3NlxzbG11bHQxXGYyXGZzMjJcbGFuZzlccGFyDQp9DQoA")
    [Void]$StringBuilder.AppendLine("`"@")
    [Void]$StringBuilder.AppendLine("#endregion `$Info03 Compressed RTF")
  }
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogTopics = [Ordered]@{ }")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogContent = [Ordered]@{ }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogTopics.Add(`"InfoIntro`", `"Info Introduction`")")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogContent.Add(`"InfoIntro`", `$InfoIntro)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogTopics.Add(`"Info01`", `"Info Topic 01`")")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogContent.Add(`"Info01`", `$Info01)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogTopics.Add(`"Info02`", `"Info Topic 02`")")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogContent.Add(`"Info02`", `$Info02)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogTopics.Add(`"Info03`", `"Info Topic 03`")")
  [Void]$StringBuilder.AppendLine("`$$($MyControlName)DialogContent.Add(`"Info03`", `$Info03)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("`$InfoIntro = `$Null")
  [Void]$StringBuilder.AppendLine("`$Info01 = `$Null")
  [Void]$StringBuilder.AppendLine("`$Info02 = `$Null")
  [Void]$StringBuilder.AppendLine("`$Info03 = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#endregion $($MyControlName) Dialog Info Topics")
  [Void]$StringBuilder.AppendLine("")
  #endregion MyControlName Dialog Info Topics

  #region function Show-MyControlNameDialog
  [Void]$StringBuilder.AppendLine("#region function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("function Show-$($MyControlName)Dialog ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DialogTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER WindowsTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER InfoTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DefInfoTopic")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Height")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$DialogTitle = `"`$(`$$($MyScriptName)Config.ScriptName)`",")
  [Void]$StringBuilder.AppendLine("    [String]`$WindowTitle = `"`$(`$$($MyScriptName)Config.ScriptName) Info`",")
  [Void]$StringBuilder.AppendLine("    [String]`$InfoTitle = `" << $($MyScriptName) Info Topics >> `",")
  [Void]$StringBuilder.AppendLine("    [String]`$DefInfoTopic = `"InfoIntro`",")
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = 60,")
  [Void]$StringBuilder.AppendLine("    [Int]`$Height = 24")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region >>>>>>>>>>>>>>>> Begin **** $($MyControlName)Dialog **** Begin <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog Form")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Icon = `$$($MyScriptName)Form.Icon")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MaximizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), (`$$($MyScriptName)Config.Font.Height * `$Height))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Name = `"$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Owner = `$$($MyScriptName)Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ShowInTaskbar = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Text = `$DialogTitle")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormMove")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Move Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Move Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormMove -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Move({ Start-$($MyControlName)DialogFormMove -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormResize ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormResize")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Resize Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Resize Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Resize Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Resize Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormResize -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Resize Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Resize Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormResize ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Resize({ Start-$($MyControlName)DialogFormResize -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormShown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Shown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Shown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormShown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Sender.Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Start-$($MyControlName)DialogLeftToolStripItemClick -Sender (`$$($MyControlName)DialogLeftMenuStrip.Items[`$DefInfoTopic]) -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Shown({ Start-$($MyControlName)DialogFormShown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Name = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Text = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  if ($MyControlType -eq "WebBrowser")
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainWebBrowser = New-Object -TypeName System.Windows.Forms.WebBrowser")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser = New-Object -TypeName System.Windows.Forms.WebBrowser")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainWebBrowser)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.AllowWebBrowserDrop = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom, Right`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.DocumentText = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.Font = `$$($MyScriptName)Config.Font.Regular")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.IsWebBrowserContextMenuEnabled = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.Name = `"$($MyControlName)DialogMainWebBrowser`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.ScriptErrorsSuppressed = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), (`$$($MyControlName)DialogMainPanel.ClientSize.Height - (`$$($MyControlName)DialogMainWebBrowser.Top + `$$($MyScriptName)Config.FormSpacer)))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.TabStop = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainWebBrowser.WebBrowserShortcutsEnabled = `$False")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainWebBrowser = New-Object -TypeName System.Windows.Forms.WebBrowser")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainRichTextBox)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom, Right`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.DetectUrls = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Font = `$$($MyScriptName)Config.Font.Regular")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.MaxLength = [Int]::MaxValue")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Multiline = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Name = `"$($MyControlName)DialogMainRichTextBox`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.ReadOnly = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Rtf = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), (`$$($MyControlName)DialogMainPanel.ClientSize.Height - (`$$($MyControlName)DialogMainRichTextBox.Top + `$$($MyScriptName)Config.FormSpacer)))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.TabStop = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.Text = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainRichTextBox.WordWrap = `$False")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
  }
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogLeft MenuStrip")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogLeftMenuStrip)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MainMenuStrip = `$$($MyControlName)DialogLeftMenuStrip")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.ImageList = `$$($MyScriptName)ImageList")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.Name = `"$($MyControlName)DialogLeftMenuStrip`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.ShowItemToolTips = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogLeftMenuStrip.Text = `"$($MyControlName)DialogLeftMenuStrip`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogLeftToolStripItemClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogLeftToolStripItemClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogLeft ToolStripItem Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogLeft ToolStripItem Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The ToolStripItem Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the ToolStripItem Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogLeftToolStripItemClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.ToolStripItem]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogLeftToolStripItem`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmStatusStrip.Items[`"Status`"].Text = `"Showing: `$(`$Sender.Text)`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Switch (`$Sender.Name)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `"Exit`"")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK")
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      Default")
  [Void]$StringBuilder.AppendLine("      {")
  if ($MyControlType -eq "WebBrowser")
  {
    [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainWebBrowser.DocumentText = `$Null")
    [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainWebBrowser.DocumentText = (Decode-MyData -Data `$$($MyControlName)DialogContent[`$Sender.Name] -AsString)")
    [Void]$StringBuilder.AppendLine("        #`$$($MyControlName)DialogMainWebBrowser.Navigate((`$$($MyControlName)DialogContent[`$Sender.Name]))")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainRichTextBox.Clear()")
    [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainRichTextBox.Rtf = (Decode-MyData -Data `$$($MyControlName)DialogContent[`$Sender.Name] -AsString)")
  }
  [Void]$StringBuilder.AppendLine("        Break")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogLeftToolStripItem`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogLeftToolStripItemClick ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  New-MenuSeparator -Menu `$$($MyControlName)DialogLeftMenuStrip")
  [Void]$StringBuilder.AppendLine("  New-MenuLabel -Menu `$$($MyControlName)DialogLeftMenuStrip -Text `$InfoTitle -Name `"Info Topics`" -Tag `"Info Topics`" -Font (`$$($MyScriptName)Config.Font.Bold)")
  [Void]$StringBuilder.AppendLine("  New-MenuSeparator -Menu `$$($MyControlName)DialogLeftMenuStrip")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  forEach (`$Key in `$$($MyControlName)DialogTopics.Keys)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    (New-MenuItem -Menu `$$($MyControlName)DialogLeftMenuStrip -Text (`$$($MyControlName)DialogTopics[`$Key]) -Name `$Key -Tag `$Key -Alignment `"MiddleLeft`" -DisplayStyle `"ImageAndText`" -ImageKey `"HelpIcon`" -PassThru).add_Click({ Start-$($MyControlName)DialogLeftToolStripItemClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  New-MenuSeparator -Menu `$$($MyControlName)DialogLeftMenuStrip")
  [Void]$StringBuilder.AppendLine("  (New-MenuItem -Menu `$$($MyControlName)DialogLeftMenuStrip -Text `"E&xit`" -Name `"Exit`" -Tag `"Exit`" -Alignment `"MiddleLeft`" -DisplayStyle `"ImageAndText`" -ImageKey `"ExitIcon`" -PassThru).add_Click({ Start-$($MyControlName)DialogLeftToolStripItemClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("  New-MenuSeparator -Menu `$$($MyControlName)DialogLeftMenuStrip")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogTopPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.Name = `"$($MyControlName)DialogTopPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.Text = `"$($MyControlName)DialogTopPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogTopPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogTopLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.Controls.Add(`$$($MyControlName)DialogTopLabel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.BackColor = `$$($MyScriptName)Config.Colors.TitleBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Font = `$$($MyScriptName)Config.Font.Title")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.ForeColor = `$$($MyScriptName)Config.Colors.TitleFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Name = `"$($MyControlName)DialogTopLabel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Text = `$WindowTitle")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopLabel.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogTopPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), `$$($MyControlName)DialogTopLabel.PreferredHeight)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogTopLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size(`$$($MyControlName)DialogTopPanel.ClientSize.Width, (`$$($MyControlName)DialogTopLabel.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogTopPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogBtm StatusStrip")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogBtmStatusStrip)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.ImageList = `$$($MyScriptName)ImageList")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.Name = `"$($MyControlName)DialogBtmStatusStrip`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.ShowItemToolTips = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmStatusStrip.Text = `"$($MyControlName)DialogBtmStatusStrip`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  New-MenuLabel -Menu `$$($MyControlName)DialogBtmStatusStrip -Text `"Status`" -Name `"Status`" -Tag `"Status`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ================ End **** $($MyControlName)Dialog **** End ================")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [Void]`$$($MyControlName)DialogForm.ShowDialog()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Show-MyControlNameDialog
  
  #endregion ********* My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptInfoDialog"
}
#endregion function Build-MyScriptInfoDialog

#region function Build-MyScriptSelectIconDialog
function Build-MyScriptSelectIconDialog ()
{
  <#
    .SYNOPSIS
      Gererates Script Dialog
    .DESCRIPTION
      Gererates Script Dialog
    .PARAMETER MyScriptName
    .EXAMPLE
      Build-MyScriptSelectIconDialog -MyScriptName $MyScriptName -MyControlName $MyControlName -MyControlType $MyControlType
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [parameter(Mandatory = $True)]
    [String]$MyControlName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptSelectIconDialog"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ********* My Code ********
  
  #region function Show-MyControlNameDialog
  [Void]$StringBuilder.AppendLine("#region function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("function Show-$($MyControlName)Dialog ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DialogTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER FileMessage")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IconMessage")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IconPath")
  [Void]$StringBuilder.AppendLine("    .PARAMETER IconIndex")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Multi")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Height")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonLeft")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonMid")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonRight")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$DialogTitle = `"`$(`$$($MyScriptName)Config.ScriptName)`",")
  [Void]$StringBuilder.AppendLine("    [String]`$FileMessage = `"Selected Icon File / Library`",")
  [Void]$StringBuilder.AppendLine("    [String]`$IconMessage = `"File / Library Icons...`",")
  [Void]$StringBuilder.AppendLine("    [String]`$IconPath = `"`",")
  [Void]$StringBuilder.AppendLine("    [Int[]]`$IconIndex = -1,")
  [Void]$StringBuilder.AppendLine("    [Switch]`$Multi,")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(35, 60)]")
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = 38,")
  [Void]$StringBuilder.AppendLine("    [ValidateRange(25, 35)]")
  [Void]$StringBuilder.AppendLine("    [Int]`$Height = 25,")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonLeft = `"&OK`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonMid = `"&Reset`",")
  [Void]$StringBuilder.AppendLine("    [String]`$ButtonRight = `"&Cancel`"")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region >>>>>>>>>>>>>>>> Begin **** $($MyControlName)Dialog **** Begin <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogFormComponents = New-Object -TypeName System.ComponentModel.Container")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog ImageList")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogImageList = New-Object -TypeName System.Windows.Forms.ImageList")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogImageList = New-Object -TypeName System.Windows.Forms.ImageList(`$$($MyControlName)DialogFormComponents)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogImageList.ImageSize = New-Object -TypeName System.Drawing.Size(32, 32)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogImageList = New-Object -TypeName System.Windows.Forms.ImageList")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog Form")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Icon = `$$($MyScriptName)Form.Icon")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.KeyPreview = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MaximizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), (`$$($MyScriptName)Config.Font.Height * `$Height))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Name = `"$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Owner = `$$($MyScriptName)Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ShowInTaskbar = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Text = `$DialogTitle")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormKeyDown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      KeyDown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form KeyDown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormKeyDown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.Close()")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit KeyDown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormKeyDown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_KeyDown({ Start-$($MyControlName)DialogFormKeyDown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormMove")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Move Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Move Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Move Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormMove -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Move Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormMove ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Move({ Start-$($MyControlName)DialogFormMove -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormShown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Shown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Shown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormShown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Sender.Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$TempIconPath = `"`$(`$$($MyControlName)DialogMainFileTextBox.Text)`".Trim()")
  [Void]$StringBuilder.AppendLine("    `$TempIconIndex = @(`$$($MyControlName)DialogMainFileTextBox.Tag)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (-not [String]::IsNullOrEmpty(`$TempIconPath))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      if ([System.IO.File]::Exists(`$TempIconPath))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempIconCount = [Extract.MyIcon]::IconCount(`$TempIconPath)")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainIconListView.BeginUpdate()")
  [Void]$StringBuilder.AppendLine("        For (`$Count = 0; `$Count -lt `$TempIconCount; `$Count++)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          `$$($MyControlName)DialogImageList.Images.Add(([Extract.MyIcon]::IconReturn(`$TempIconPath, `$Count, `$True)))")
  [Void]$StringBuilder.AppendLine("          [Void](`$$($MyControlName)DialogMainIconListView.Items.Add(`"`$(`"{0:###00}`" -f `$Count)`", `$Count))")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainIconListView.EndUpdate()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("        if (`$$($MyControlName)DialogMainIconListView.CheckBoxes)")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (`$TempIconIndex.Count -and (`$TempIconIndex[0] -gt -1))")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            `$TempIconIndex | ForEach-Object -Process { `$$($MyControlName)DialogMainIconListView.Items[`$PSItem].Checked = `$True }")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("        else")
  [Void]$StringBuilder.AppendLine("        {")
  [Void]$StringBuilder.AppendLine("          if (`$TempIconIndex[0] -gt -1)")
  [Void]$StringBuilder.AppendLine("          {")
  [Void]$StringBuilder.AppendLine("            `$$($MyControlName)DialogMainIconListView.Items[`$TempIconIndex[0]].Selected = `$True")
  [Void]$StringBuilder.AppendLine("            `$$($MyControlName)DialogMainIconListView.Select()")
  [Void]$StringBuilder.AppendLine("            `$$($MyControlName)DialogMainIconListView.Items[`$TempIconIndex[0]].EnsureVisible()")
  [Void]$StringBuilder.AppendLine("          }")
  [Void]$StringBuilder.AppendLine("        }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Shown({ Start-$($MyControlName)DialogFormShown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Name = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Text = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainFileLabel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.AutoSize = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$$($MyScriptName)Config.FormSpacer * 2))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.Name = `"$($MyControlName)DialogMainFileLabel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.TabStop = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.Text = `$FileMessage")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainFileButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.AutoSize = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.Name = `"$($MyControlName)DialogMainFileButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.TabIndex = 0")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.Text = `"  &Browse...  `"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyControlName)DialogMainFileButton.Width + `$$($MyScriptName)Config.FormSpacer)), (`$$($MyControlName)DialogMainFileLabel.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogMainFileButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogMainFileButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogMainFile Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogMainFile Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogMainFileButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogMainFileButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)OpenFileDialog.Title = `"Extact Icons`"")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)OpenFileDialog.Filter = `"All Icon Files|*.ico;*.exe;*.dll|Icon Files|*.ico|EXE Files|*.exe|DLL Files|*.dll|All Files|*.*`"")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)OpenFileDialog.FilterIndex = 0")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)OpenFileDialog.FileName = `"`"")
  [Void]$StringBuilder.AppendLine("    If (`$$($MyScriptName)OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogImageList.Images.Clear()")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainIconListView.Items.Clear()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("      `$TempIconPath = `"`$(`$$($MyScriptName)OpenFileDialog.FileName)`".Trim()")
  [Void]$StringBuilder.AppendLine("      `$TempIconCount = [Extract.MyIcon]::IconCount(`$TempIconPath)")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainIconListView.BeginUpdate()")
  [Void]$StringBuilder.AppendLine("      For (`$Count = 0; `$Count -lt `$TempIconCount; `$Count++)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogImageList.Images.Add(([Extract.MyIcon]::IconReturn(`$TempIconPath, `$Count, `$True)))")
  [Void]$StringBuilder.AppendLine("        [Void](`$$($MyControlName)DialogMainIconListView.Items.Add(`"`$(`"{0:###00}`" -f `$Count)`", `$Count))")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainIconListView.EndUpdate()")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainFileTextBox.Text = `$TempIconPath")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainFileTextBox.Tag = @(-1)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogMainFileButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogMainFileButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileButton.add_Click({ Start-$($MyControlName)DialogMainFileButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainFileTextBox)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.AutoSize = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$$($MyControlName)DialogMainFileLabel.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Name = `"$($MyControlName)DialogMainFileTextBox`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.ReadOnly = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Size = New-Object -TypeName System.Drawing.Size(((`$$($MyControlName)DialogMainFileButton.Left - `$$($MyScriptName)Config.FormSpacer) - `$$($MyControlName)DialogMainFileTextBox.Left), `$$($MyControlName)DialogMainFileButton.Height)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.TabStop = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Text = `$IconPath")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.Tag = `$IconIndex")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainFileTextBox.WordWrap = `$False")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainIconLabel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.AutoSize = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$$($MyControlName)DialogMainFileTextBox.Bottom + (`$$($MyScriptName)Config.FormSpacer * 2)))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.Name = `"$($MyControlName)DialogMainIconLabel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.TabStop = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.Text = `$IconMessage")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)DialogMainIconListView)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.CheckBoxes = `$Multi.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.HeaderStyle = [System.Windows.Forms.ColumnHeaderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.HideSelection = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.LabelWrap = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.LargeImageList = `$$($MyControlName)DialogImageList")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$$($MyControlName)DialogMainIconLabel.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.MultiSelect = `$Multi.IsPresent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Name = `"$($MyControlName)DialogMainIconListView`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.ShowGroups = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), ((`$$($MyControlName)DialogMainPanel.ClientSize.Height - `$$($MyScriptName)Config.FormSpacer) - `$$($MyControlName)DialogMainIconListView.Top))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Sorting = [System.Windows.Forms.SortOrder]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.TabIndex = 1")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.Text = `"$($MyControlName)DialogMainIconListView`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.View = [System.Windows.Forms.View]::LargeIcon")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogMainIconListViewSelectedIndexChanged ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogMainIconListViewSelectedIndexChanged")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      SelectedIndexChanged Event for the $($MyControlName)DialogMainIcon ListView Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      SelectedIndexChanged Event for the $($MyControlName)DialogMainIcon ListView Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The ListView Control that fired the SelectedIndexChanged Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the ListView SelectedIndexChanged Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogMainIconListViewSelectedIndexChanged -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.ListView]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter SelectedIndexChanged Event for ```$$($MyControlName)DialogMainIconListView`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit SelectedIndexChanged Event for ```$$($MyControlName)DialogMainIconListView`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogMainIconListViewSelectedIndexChanged ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainIconListView.add_SelectedIndexChanged({ Start-$($MyControlName)DialogMainIconListViewSelectedIndexChanged -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogBtm Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogBtmPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Name = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Text = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Evenly Space Buttons - Move Size to after Text")
  [Void]$StringBuilder.AppendLine("  `$NumButtons = 3")
  [Void]$StringBuilder.AppendLine("  `$TempSpace = [Math]::Floor(`$$($MyControlName)DialogBtmPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * (`$NumButtons + 1)))")
  [Void]$StringBuilder.AppendLine("  `$TempWidth = [Math]::Floor(`$TempSpace / `$NumButtons)")
  [Void]$StringBuilder.AppendLine("  `$TempMod = `$TempSpace % `$NumButtons")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmLeftButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Name = `"$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabIndex = 2")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Text = `$ButtonLeft")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmLeftButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmLeftButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmLeft Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if ((`$$($MyControlName)DialogMainIconListView.CheckedIndices.Count -and `$$($MyControlName)DialogMainIconListView.CheckBoxes) -or (`$$($MyControlName)DialogMainIconListView.SelectedIndices.Count -and (-not `$$($MyControlName)DialogMainIconListView.CheckBoxes)))")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      [Void][System.Windows.Forms.MessageBox]::Show(`$$($MyControlName)DialogForm, `"No Icons Selected`", `$$($MyScriptName)Config.ScriptName, `"OK`", `"Warning`")")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmLeftButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmLeftButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.add_Click({ Start-$($MyControlName)DialogBtmLeftButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmMidButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmLeftButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Name = `"$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.TabIndex = 3")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Text = `$ButtonMid")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Size = New-Object -TypeName System.Drawing.Size((`$TempWidth + `$TempMod), `$$($MyControlName)DialogBtmMidButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmMidButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmMid Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$TempIconIndex = `$$($MyControlName)DialogMainFileTextBox.Tag")
  [Void]$StringBuilder.AppendLine("    if (`$$($MyControlName)DialogMainIconListView.CheckBoxes)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainIconListView.CheckedIndices | ForEach-Object -Process { `$$($MyControlName)DialogMainIconListView.Items[`$PSItem].Checked = `$False }")
  [Void]$StringBuilder.AppendLine("      if (`$TempIconIndex.Count -and (`$TempIconIndex[0] -gt -1))")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$TempIconIndex | ForEach-Object -Process { `$$($MyControlName)DialogMainIconListView.Items[`$PSItem].Checked = `$True }")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogMainIconListView.SelectedIndices.Clear()")
  [Void]$StringBuilder.AppendLine("      if (`$TempIconIndex[0] -gt -1)")
  [Void]$StringBuilder.AppendLine("      {")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainIconListView.Items[`$TempIconIndex[0]].Selected = `$True")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainIconListView.Select()")
  [Void]$StringBuilder.AppendLine("        `$$($MyControlName)DialogMainIconListView.Items[`$TempIconIndex[0]].EnsureVisible()")
  [Void]$StringBuilder.AppendLine("      }")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmMidButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmMidButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.add_Click({ Start-$($MyControlName)DialogBtmMidButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmRightButton)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Right`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Font = `$$($MyScriptName)Config.Font.Bold")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmMidButton.Right + `$$($MyScriptName)Config.FormSpacer), `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Name = `"$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabIndex = 5")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabStop = `$True")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Text = `$ButtonRight")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmRightButton.PreferredSize.Height)")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogBtmRightButtonClick")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Click Event for the $($MyControlName)DialogBtmRight Button Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Button Control that fired the Click Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Button Click Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Button]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Click Event for ```$$($MyControlName)DialogBtmRightButton`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogBtmRightButtonClick ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.add_Click({ Start-$($MyControlName)DialogBtmRightButtonClick -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.ClientSize = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogBtmRightButton.Right + `$$($MyScriptName)Config.FormSpacer), (`$$($MyControlName)DialogBtmRightButton.Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ================ End **** $($MyControlName)Dialog **** End ================")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$DialogResult = `$$($MyControlName)DialogForm.ShowDialog()")
  [Void]$StringBuilder.AppendLine("  if (`$$($MyControlName)DialogMainIconListView.CheckBoxes)")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    @{`"Success`" = (`$DialogResult -eq [System.Windows.Forms.DialogResult]::OK); `"DialogResult`" = `$DialogResult; `"IconPath`" = `$$($MyControlName)DialogMainFileTextBox.Text; `"IconIndex`" = @(`$$($MyControlName)DialogMainIconListView.CheckedIndices)}")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    @{`"Success`" = (`$DialogResult -eq [System.Windows.Forms.DialogResult]::OK); `"DialogResult`" = `$DialogResult; `"IconPath`" = `$$($MyControlName)DialogMainFileTextBox.Text; `"IconIndex`" = @(`$$($MyControlName)DialogMainIconListView.SelectedIndices)}")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogFormComponents.Dispose()")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Show-MyControlNameDialog
  
  #endregion ********* My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptSelectIconDialog"
}
#endregion function Build-MyScriptSelectIconDialog

#region function Build-MyScriptStatusDialog
function Build-MyScriptStatusDialog ()
{
  <#
    .SYNOPSIS
      Gererates Script Dialog
    .DESCRIPTION
      Gererates Script Dialog
    .PARAMETER MyScriptName
    .EXAMPLE
      Build-MyScriptStatusDialog -MyScriptName $MyScriptName -MyControlName $MyControlName -MyControlType $MyControlType
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [parameter(Mandatory = $True)]
    [String]$MyControlName,
    [parameter(Mandatory = $True)]
    [ValidateSet("TextBox", "RichTextBox")]
    [String]$MyControlType,
    [ValidateRange(1, 2)]
    [Int]$Buttons = 1
  )
  Write-Verbose -Message "Enter Function Build-MyScriptStatusDialog"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ********* My Code ********
  
  #region function Show-MyControlNameDialog
  [Void]$StringBuilder.AppendLine("#region function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("function Show-$($MyControlName)Dialog ()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shows Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("    .PARAMETER DialogTitle")
  [Void]$StringBuilder.AppendLine("    .PARAMETER MessageText")
  [Void]$StringBuilder.AppendLine("    .PARAMETER ScriptBlock")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Items")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Width")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Height")
  if ($Buttons -eq 1)
  {
    [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonMid")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonLeft")
    [Void]$StringBuilder.AppendLine("    .PARAMETER ButtonRight")
  }
  [Void]$StringBuilder.AppendLine("    .PARAMETER AutoClose")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      `$Return = Show-$($MyControlName)Dialog -DialogTitle `$DialogTitle")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [String]`$DialogTitle = `"`$(`$$($MyScriptName)Config.ScriptName)`",")
  [Void]$StringBuilder.AppendLine("    [String]`$MessageText = `"Status Message`",")
  [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [ScriptBlock]`$ScriptBlock = { },")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$Items = @(),")
  [Void]$StringBuilder.AppendLine("    [Int]`$Width = 35,")
  [Void]$StringBuilder.AppendLine("    [Int]`$Height = 18,")
  if ($Buttons -eq 1)
  {
    [Void]$StringBuilder.AppendLine("    [String]`$ButtonMid = `"&OK`",")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("    [String]`$ButtonLeft = `"&OK`",")
    [Void]$StringBuilder.AppendLine("    [String]`$ButtonRight = `"&Cancel`",")
}
  [Void]$StringBuilder.AppendLine("    [Switch]`$AutoClose")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region >>>>>>>>>>>>>>>> Begin **** $($MyControlName)Dialog **** Begin <<<<<<<<<<<<<<<<")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)Dialog Form")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.BackColor = `$$($MyScriptName)Config.Colors.Back")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Font = `$$($MyScriptName)Config.Font.Regular")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ForeColor = `$$($MyScriptName)Config.Colors.Fore")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Icon = `$$($MyScriptName)Form.Icon")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.KeyPreview = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MaximizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimizeBox = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size((`$$($MyScriptName)Config.Font.Width * `$Width), (`$$($MyScriptName)Config.Font.Height * `$Height))")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Name = `"$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Owner = `$$($MyScriptName)Form")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.ShowInTaskbar = `$False")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Text = `$DialogTitle")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogForm = New-Object -TypeName System.Windows.Forms.Form")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  function Start-$($MyControlName)DialogFormShown")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Shown Event for the $($MyControlName)Dialog Form Control")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
  [Void]$StringBuilder.AppendLine("       The Form Control that fired the Shown Event")
  [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
  [Void]$StringBuilder.AppendLine("       The Event Arguments for the Form Shown Event")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("       Start-$($MyControlName)DialogFormShown -Sender `$Sender -EventArg `$EventArg")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Function By Ken Sweet)")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("    [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("    param (")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Form]`$Sender,")
  [Void]$StringBuilder.AppendLine("      [parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("      [Object]`$EventArg")
  [Void]$StringBuilder.AppendLine("    )")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Enter Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Config.AutoExit = 0")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$Sender.Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if (`$Items.Count)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$DialogResult = Invoke-Command -ScriptBlock `$ScriptBlock -ArgumentList `$$($MyControlName)Main$($MyControlType), `$Items")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("    else")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$DialogResult = Invoke-Command -ScriptBlock `$ScriptBlock -ArgumentList `$$($MyControlName)Main$($MyControlType)")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  if ($Buttons -eq 1)
  {
    [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmMidButton.Enabled = `$True")
    [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmMidButton.DialogResult = `$DialogResult")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmLeftButton.Enabled = `$True")
    [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmLeftButton.DialogResult = `$DialogResult")
    [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogBtmRightButton.Enabled = `$True")
  }
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    if ((`$DialogResult -eq [System.Windows.Forms.DialogResult]::OK) -and `$AutoClose.IsPresent)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlName)DialogForm.DialogResult = `$DialogResult")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("    [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    Write-Verbose -Message `"Exit Shown Event for ```$$($MyControlName)DialogForm`"")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Function Start-$($MyControlName)DialogFormShown ********")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.add_Shown({ Start-$($MyControlName)DialogFormShown -Sender `$This -EventArg `$PSItem })")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogMain Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogMainPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Name = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Text = `"$($MyControlName)DialogMainPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"MessageText`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    #region `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)MainLabel)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Name = `"$($MyControlName)MainLabel`"")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), 23)")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Text = `$MessageText")
  [Void]$StringBuilder.AppendLine("    #endregion `$$($MyControlName)MainLabel = New-Object -TypeName System.Windows.Forms.Label")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    # Returns the minimum size required to display the text")
  [Void]$StringBuilder.AppendLine("    `$$($MyControlName)MainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText(`$$($MyControlName)MainLabel.Text, `$$($MyControlName)MainLabel.Font, `$$($MyControlName)MainLabel.Size, ([System.Windows.Forms.TextFormatFlags](`"Top`", `"Left`", `"WordBreak`")))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("    `$TempBottom = `$$($MyControlName)MainLabel.Bottom")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    `$TempBottom = 0")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  if ($MyControlType -eq "RichTextBox")
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)MainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)MainRichTextBox)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.DetectUrls = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Font = `$$($MyScriptName)Config.Font.Regular")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$TempBottom + `$$($MyScriptName)Config.FormSpacer))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.MaxLength = [Int]::MaxValue")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Multiline = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Name = `"$($MyControlName)MainRichTextBox`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.ReadOnly = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Rtf = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), (`$$($MyControlName)DialogMainPanel.ClientSize.Height - (`$$($MyControlName)MainRichTextBox.Top + `$$($MyScriptName)Config.FormSpacer)))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.TabStop = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.Text = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainRichTextBox.WordWrap = `$False")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)MainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox")
    [Void]$StringBuilder.AppendLine("")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogMainPanel.Controls.Add(`$$($MyControlName)MainTextBox)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Bottom`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.BackColor = `$$($MyScriptName)Config.Colors.TextBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Font = `$$($MyScriptName)Config.Font.Regular")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.ForeColor = `$$($MyScriptName)Config.Colors.TextFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, (`$TempBottom + `$$($MyScriptName)Config.FormSpacer))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.MaxLength = [Int]::MaxValue")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Multiline = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Name = `"$($MyControlName)MainTextBox`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.ReadOnly = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Size = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)DialogMainPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * 2)), (`$$($MyControlName)DialogMainPanel.ClientSize.Height - (`$$($MyControlName)MainTextBox.Top + `$$($MyScriptName)Config.FormSpacer)))")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.TabStop = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.Text = `"`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)MainTextBox.WordWrap = `$False")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)MainTextBox = New-Object -TypeName System.Windows.Forms.TextBox")
    [Void]$StringBuilder.AppendLine("")
  }
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogMainPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  # $($MyControlName)DialogBtm Panel")
  [Void]$StringBuilder.AppendLine("  # ************************************************")
  [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Controls.Add(`$$($MyControlName)DialogBtmPanel)")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Name = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Text = `"$($MyControlName)DialogBtmPanel`"")
  [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #region ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # Evenly Space Buttons - Move Size to after Text")
  [Void]$StringBuilder.AppendLine("  `$NumButtons = 3")
  [Void]$StringBuilder.AppendLine("  `$TempSpace = [Math]::Floor(`$$($MyControlName)DialogBtmPanel.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * (`$NumButtons + 1)))")
  [Void]$StringBuilder.AppendLine("  `$TempWidth = [Math]::Floor(`$TempSpace / `$NumButtons)")
  [Void]$StringBuilder.AppendLine("  `$TempMod = `$TempSpace % `$NumButtons")
  [Void]$StringBuilder.AppendLine("")
  if ($Buttons -eq 1)
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmMidButton)")
    [Void]$StringBuilder.AppendLine("  #`$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left, Right`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Enabled = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Font = `$$($MyScriptName)Config.Font.Bold")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Location = New-Object -TypeName System.Drawing.Point((`$TempWidth + (`$$($MyScriptName)Config.FormSpacer * 2)), `$$($MyScriptName)Config.FormSpacer)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Name = `"$($MyControlName)DialogBtmMidButton`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.TabStop = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Text = `$ButtonMid")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmMidButton.Size = New-Object -TypeName System.Drawing.Size((`$TempWidth + `$TempMod), `$$($MyControlName)DialogBtmMidButton.PreferredSize.Height)")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button")
  }
  else
  {
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmLeftButton)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Left`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.DialogResult = [System.Windows.Forms.DialogResult]::None")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Enabled = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Font = `$$($MyScriptName)Config.Font.Bold")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Location = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Name = `"$($MyControlName)DialogBtmLeftButton`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabIndex = 0")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.TabStop = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Text = `$ButtonLeft")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmLeftButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmLeftButton.PreferredSize.Height)")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("  #region `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.Controls.Add(`$$($MyControlName)DialogBtmRightButton)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles](`"Top, Right`")")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.BackColor = `$$($MyScriptName)Config.Colors.ButtonBack")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Enabled = `$False")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Font = `$$($MyScriptName)Config.Font.Bold")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.ForeColor = `$$($MyScriptName)Config.Colors.ButtonFore")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Location = New-Object -TypeName System.Drawing.Point((`$$($MyControlName)DialogBtmLeftButton.Right + `$TempWidth + `$TempMod + (`$$($MyScriptName)Config.FormSpacer * 2)), `$$($MyScriptName)Config.FormSpacer)")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Name = `"$($MyControlName)DialogBtmRightButton`"")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabIndex = 1")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.TabStop = `$True")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Text = `$ButtonRight")
    [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmRightButton.Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, `$$($MyControlName)DialogBtmRightButton.PreferredSize.Height)")
    [Void]$StringBuilder.AppendLine("  #endregion `$$($MyControlName)DialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button")
  }
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogBtmPanel.ClientSize = New-Object -TypeName System.Drawing.Size((`$$($MyControlName)Main$($MyControlType).Right + `$$($MyScriptName)Config.FormSpacer), ((`$$($MyControlName)DialogBtmPanel.Controls[`$$($MyControlName)DialogBtmPanel.Controls.Count - 1]).Bottom + `$$($MyScriptName)Config.FormSpacer))")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** `$$($MyControlName)DialogBtmPanel Controls ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ******** Controls for $($MyControlName)Dialog Form ********")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  #endregion ================ End **** $($MyControlName)Dialog **** End ================")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$DialogResult = `$$($MyControlName)DialogForm.ShowDialog()")
  [Void]$StringBuilder.AppendLine("  @{`"Success`" = (`$DialogResult -eq [System.Windows.Forms.DialogResult]::OK); `"DialogResult`" = `$DialogResult}")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlName)DialogForm.Dispose()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
  [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Show-$($MyControlName)Dialog`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Show-$($MyControlName)Dialog")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Show-MyControlNameDialog
  
  #region function Display-MyStatusControlType - Sample Code
  [Void]$StringBuilder.AppendLine("#region function Display-MyStatus$($MyControlType)")
  [Void]$StringBuilder.AppendLine("function Display-MyStatus$($MyControlType)()")
  [Void]$StringBuilder.AppendLine("{")
  [Void]$StringBuilder.AppendLine("  <#")
  [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
  [Void]$StringBuilder.AppendLine("      Display Utility Status Sample Function")
  [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
  [Void]$StringBuilder.AppendLine("      Display Utility Status Sample Function")
  [Void]$StringBuilder.AppendLine("    .PARAMETER $($MyControlType)")
  [Void]$StringBuilder.AppendLine("    .PARAMETER Items")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Display-MyStatus$($MyControlType) -$($MyControlType) `$$($MyControlType)")
  [Void]$StringBuilder.AppendLine("    .EXAMPLE")
  [Void]$StringBuilder.AppendLine("      Display-MyStatus$($MyControlType) -$($MyControlType) `$$($MyControlType) -Items `$Items")
  [Void]$StringBuilder.AppendLine("    .NOTES")
  [Void]$StringBuilder.AppendLine("      Original Script By Ken Sweet")
  [Void]$StringBuilder.AppendLine("    .LINK")
  [Void]$StringBuilder.AppendLine("  #>")
  [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
  [Void]$StringBuilder.AppendLine("  param (")
  [Void]$StringBuilder.AppendLine("    [Parameter(Mandatory = `$True)]")
  [Void]$StringBuilder.AppendLine("    [System.Windows.Forms.$($MyControlType)]`$$($MyControlType),")
  [Void]$StringBuilder.AppendLine("    [Object[]]`$Items")
  [Void]$StringBuilder.AppendLine("  )")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter Function Display-MyStatus$($MyControlType)`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$DisplayResult = [System.Windows.Forms.DialogResult]::OK")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlType).Refresh()")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  # **********************")
  [Void]$StringBuilder.AppendLine("  # Update $($MyControlType) Text...")
  [Void]$StringBuilder.AppendLine("  # **********************")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlType).AppendText(`"Update $($MyControlType) Text...``r``n`")")
  [Void]$StringBuilder.AppendLine("  `$$($MyControlType).Refresh()")
  [Void]$StringBuilder.AppendLine("")
  if ($MyControlType -eq "RichTextBox")
  {
    [Void]$StringBuilder.AppendLine("  # **************")
    [Void]$StringBuilder.AppendLine("  # RFT Formatting ")
    [Void]$StringBuilder.AppendLine("  # **************")
    [Void]$StringBuilder.AppendLine("  # Permanate till Changed")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionBullet = `$True")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionIndent = 10")
    [Void]$StringBuilder.AppendLine("  # Resets After AppendText")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionBackColor = `$$($MyScriptName)Config.Colors.TextBack")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionCharOffset = 0")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionColor = `$$($MyScriptName)Config.Colors.TextFore")
    [Void]$StringBuilder.AppendLine("  #`$RichTextBox.SelectionFont = `$$($MyScriptName)Config.Font.Bold")
    [Void]$StringBuilder.AppendLine("")
  }
  [Void]$StringBuilder.AppendLine("  if (`$PSBoundParameters.ContainsKey(`"Items`"))")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    ForEach (`$Item in `$Items)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlType).AppendText(`"Found List Item: `$(`$Item)``r``n`")")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlType).ScrollToCaret()")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("      Start-Sleep -Milliseconds 100")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("  else")
  [Void]$StringBuilder.AppendLine("  {")
  [Void]$StringBuilder.AppendLine("    For (`$Count = 1; `$Count -le 9; `$Count++)")
  [Void]$StringBuilder.AppendLine("    {")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlType).AppendText(`"`$(`"*`" * `$Count)``r``n`")")
  [Void]$StringBuilder.AppendLine("      `$$($MyControlType).ScrollToCaret()")
  [Void]$StringBuilder.AppendLine("      [System.Windows.Forms.Application]::DoEvents()")
  [Void]$StringBuilder.AppendLine("      Start-Sleep -Milliseconds 100")
  [Void]$StringBuilder.AppendLine("    }")
  [Void]$StringBuilder.AppendLine("  }")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  `$DisplayResult")
  [Void]$StringBuilder.AppendLine("  `$DisplayResult = `$Null")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit Function Display-MyStatus$($MyControlType)`"")
  [Void]$StringBuilder.AppendLine("}")
  [Void]$StringBuilder.AppendLine("#endregion function Display-MyStatus$($MyControlType)")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#Show-$($MyControlName)Dialog -ScriptBlock { [CmdletBinding()] param ([System.Windows.Forms.$($MyControlType)]`$$($MyControlType)) Display-MyStatus$($MyControlType) -$($MyControlType) `$$($MyControlType) } -DialogTitle `"Test Title 1`"")
  [Void]$StringBuilder.AppendLine("")
  [Void]$StringBuilder.AppendLine("#`$Items = @(1..99)")
  [Void]$StringBuilder.AppendLine("#Show-$($MyControlName)Dialog -ScriptBlock { [CmdletBinding()] param ([System.Windows.Forms.$($MyControlType)]`$$($MyControlType), [Object[]]`$Items) Display-MyStatus$($MyControlType) -$($MyControlType) `$$($MyControlType) -Items `$Items } -DialogTitle `"Test Title 2`" -Items `$Items")
  [Void]$StringBuilder.AppendLine("")
  #endregion function Display-MyStatusControlType - Sample Code
    
  #endregion ********* My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptStatusDialog"
}
#endregion function Build-MyScriptStatusDialog


#region function Show-MySIDialog
function Show-MySIDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-MySIDialog
    .DESCRIPTION
      Shows Show-MySIDialog
    .PARAMETER DialogTitle
    .PARAMETER FileMessage
    .PARAMETER IconMessage
    .PARAMETER IconPath
    .PARAMETER IconIndex
    .PARAMETER Multi
    .PARAMETER Width
    .PARAMETER Height
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-MySIDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$DialogTitle = "$($MyFCGConfig.ScriptName)",
    [String]$FileMessage = "Selected Icon File / Library",
    [String]$IconMessage = "File / Library Icons...",
    [String]$IconPath = "",
    [Int[]]$IconIndex = -1,
    [Switch]$Multi,
    [ValidateRange(35, 60)]
    [Int]$Width = 38,
    [ValidateRange(25, 35)]
    [Int]$Height = 25,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-MySIDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** MySIDialog **** Begin <<<<<<<<<<<<<<<<
  
  $MySIDialogFormComponents = New-Object -TypeName System.ComponentModel.Container
  
  # ************************************************
  # MySIDialog ImageList
  # ************************************************
  #region $MySIDialogImageList = New-Object -TypeName System.Windows.Forms.ImageList
  $MySIDialogImageList = New-Object -TypeName System.Windows.Forms.ImageList($MySIDialogFormComponents)
  $MySIDialogImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit
  $MySIDialogImageList.ImageSize = New-Object -TypeName System.Drawing.Size(32, 32)
  #endregion $MySIDialogImageList = New-Object -TypeName System.Windows.Forms.ImageList
  
  # ************************************************
  # MySIDialog Form
  # ************************************************
  #region $MySIDialogForm = New-Object -TypeName System.Windows.Forms.Form
  $MySIDialogForm = New-Object -TypeName System.Windows.Forms.Form
  $MySIDialogForm.BackColor = $MyFCGConfig.Colors.Back
  $MySIDialogForm.Font = $MyFCGConfig.Font.Regular
  $MySIDialogForm.ForeColor = $MyFCGConfig.Colors.Fore
  $MySIDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $MySIDialogForm.Icon = $MyFCGForm.Icon
  $MySIDialogForm.KeyPreview = $True
  $MySIDialogForm.MaximizeBox = $False
  $MySIDialogForm.MinimizeBox = $False
  $MySIDialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size(($MyFCGConfig.Font.Width * $Width), ($MyFCGConfig.Font.Height * $Height))
  $MySIDialogForm.Name = "MySIDialogForm"
  $MySIDialogForm.Owner = $MyFCGForm
  $MySIDialogForm.ShowInTaskbar = $False
  $MySIDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MySIDialogForm.Text = $DialogTitle
  #endregion $MySIDialogForm = New-Object -TypeName System.Windows.Forms.Form
  
  #region ******** Function Start-MySIDialogFormKeyDown ********
  function Start-MySIDialogFormKeyDown
  {
  <#
    .SYNOPSIS
      KeyDown Event for the MySIDialog Form Control
    .DESCRIPTION
      KeyDown Event for the MySIDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-MySIDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MySIDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $MySIDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$MySIDialogForm"
  }
  #endregion ******** Function Start-MySIDialogFormKeyDown ********
  $MySIDialogForm.add_KeyDown({ Start-MySIDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-MySIDialogFormMove ********
  function Start-MySIDialogFormMove
  {
  <#
    .SYNOPSIS
      Move Event for the MySIDialog Form Control
    .DESCRIPTION
      Move Event for the MySIDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the Move Event
    .PARAMETER EventArg
       The Event Arguments for the Form Move Event
    .EXAMPLE
       Start-MySIDialogFormMove -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Move Event for `$MySIDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    Write-Verbose -Message "Exit Move Event for `$MySIDialogForm"
  }
  #endregion ******** Function Start-MySIDialogFormMove ********
  $MySIDialogForm.add_Move({ Start-MySIDialogFormMove -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-MySIDialogFormShown ********
  function Start-MySIDialogFormShown
  {
  <#
    .SYNOPSIS
      Shown Event for the MySIDialog Form Control
    .DESCRIPTION
      Shown Event for the MySIDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the Shown Event
    .PARAMETER EventArg
       The Event Arguments for the Form Shown Event
    .EXAMPLE
       Start-MySIDialogFormShown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MySIDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    $Sender.Refresh()
    
    $TempIconPath = "$($MySIDialogMainFileTextBox.Text)".Trim()
    $TempIconIndex = @($MySIDialogMainFileTextBox.Tag)
    
    if (-not [String]::IsNullOrEmpty($TempIconPath))
    {
      if ([System.IO.File]::Exists($TempIconPath))
      {
        $TempIconCount = [Extract.MyIcon]::IconCount($TempIconPath)
        $MySIDialogMainIconListView.BeginUpdate()
        For ($Count = 0; $Count -lt $TempIconCount; $Count++)
        {
          $MySIDialogImageList.Images.Add(([Extract.MyIcon]::IconReturn($TempIconPath, $Count, $True)))
          [Void]($MySIDialogMainIconListView.Items.Add("$("{0:###00}" -f $Count)", $Count))
        }
        $MySIDialogMainIconListView.EndUpdate()
        
        if ($MySIDialogMainIconListView.CheckBoxes)
        {
          if ($TempIconIndex.Count -and ($TempIconIndex[0] -gt -1))
          {
            $TempIconIndex | ForEach-Object -Process { $MySIDialogMainIconListView.Items[$PSItem].Checked = $True }
          }
        }
        else
        {
          if ($TempIconIndex[0] -gt -1)
          {
            $MySIDialogMainIconListView.Items[$TempIconIndex[0]].Selected = $True
            $MySIDialogMainIconListView.Select()
            $MySIDialogMainIconListView.Items[$TempIconIndex[0]].EnsureVisible()
          }
        }
      }
    }
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$MySIDialogForm"
  }
  #endregion ******** Function Start-MySIDialogFormShown ********
  $MySIDialogForm.add_Shown({ Start-MySIDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for MySIDialog Form ********
  
  # ************************************************
  # MySIDialogMain Panel
  # ************************************************
  #region $MySIDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MySIDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MySIDialogForm.Controls.Add($MySIDialogMainPanel)
  $MySIDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MySIDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $MySIDialogMainPanel.Name = "MySIDialogMainPanel"
  $MySIDialogMainPanel.Text = "MySIDialogMainPanel"
  #endregion $MySIDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  
  #region ******** $MySIDialogMainPanel Controls ********
  
  #region $MySIDialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label
  $MySIDialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label
  $MySIDialogMainPanel.Controls.Add($MySIDialogMainFileLabel)
  $MySIDialogMainFileLabel.AutoSize = $True
  $MySIDialogMainFileLabel.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, ($MyFCGConfig.FormSpacer * 2))
  $MySIDialogMainFileLabel.Name = "MySIDialogMainFileLabel"
  $MySIDialogMainFileLabel.TabStop = $False
  $MySIDialogMainFileLabel.Text = $FileMessage
  $MySIDialogMainFileLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
  #endregion $MySIDialogMainFileLabel = New-Object -TypeName System.Windows.Forms.Label
  
  #region $MySIDialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogMainPanel.Controls.Add($MySIDialogMainFileButton)
  $MySIDialogMainFileButton.AutoSize = $True
  $MySIDialogMainFileButton.BackColor = $MyFCGConfig.Colors.ButtonBack
  $MySIDialogMainFileButton.Font = $MyFCGConfig.Font.Bold
  $MySIDialogMainFileButton.ForeColor = $MyFCGConfig.Colors.ButtonFore
  $MySIDialogMainFileButton.Name = "MySIDialogMainFileButton"
  $MySIDialogMainFileButton.TabIndex = 0
  $MySIDialogMainFileButton.TabStop = $True
  $MySIDialogMainFileButton.Text = "  &Browse...  "
  $MySIDialogMainFileButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MySIDialogMainFileButton.Location = New-Object -TypeName System.Drawing.Point(($MySIDialogMainPanel.ClientSize.Width - ($MySIDialogMainFileButton.Width + $MyFCGConfig.FormSpacer)), ($MySIDialogMainFileLabel.Bottom + $MyFCGConfig.FormSpacer))
  #endregion $MySIDialogMainFileButton = New-Object -TypeName System.Windows.Forms.Button
  
  #region ******** Function Start-MySIDialogMainFileButtonClick ********
  function Start-MySIDialogMainFileButtonClick
  {
  <#
    .SYNOPSIS
      Click Event for the MySIDialogMainFile Button Control
    .DESCRIPTION
      Click Event for the MySIDialogMainFile Button Control
    .PARAMETER Sender
       The Button Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the Button Click Event
    .EXAMPLE
       Start-MySIDialogMainFileButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MySIDialogMainFileButton"
    
    $MyFCGConfig.AutoExit = 0
    
    $MyFCGOpenFileDialog.Title = "Extact Icons"
    $MyFCGOpenFileDialog.Filter = "All Icon Files|*.ico;*.exe;*.dll|Icon Files|*.ico|EXE Files|*.exe|DLL Files|*.dll|All Files|*.*"
    $MyFCGOpenFileDialog.FilterIndex = 0
    $MyFCGOpenFileDialog.FileName = ""
    If ($MyFCGOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
    {
      $MySIDialogImageList.Images.Clear()
      $MySIDialogMainIconListView.Items.Clear()
      
      $TempIconPath = "$($MyFCGOpenFileDialog.FileName)".Trim()
      $TempIconCount = [Extract.MyIcon]::IconCount($TempIconPath)
      $MySIDialogMainIconListView.BeginUpdate()
      For ($Count = 0; $Count -lt $TempIconCount; $Count++)
      {
        $MySIDialogImageList.Images.Add(([Extract.MyIcon]::IconReturn($TempIconPath, $Count, $True)))
        [Void]($MySIDialogMainIconListView.Items.Add("$("{0:###00}" -f $Count)", $Count))
      }
      $MySIDialogMainIconListView.EndUpdate()
      $MySIDialogMainFileTextBox.Text = $TempIconPath
      $MySIDialogMainFileTextBox.Tag = @(-1)
    }
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Click Event for `$MySIDialogMainFileButton"
  }
  #endregion ******** Function Start-MySIDialogMainFileButtonClick ********
  $MySIDialogMainFileButton.add_Click({ Start-MySIDialogMainFileButtonClick -Sender $This -EventArg $PSItem })
  
  #region $MySIDialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MySIDialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MySIDialogMainPanel.Controls.Add($MySIDialogMainFileTextBox)
  $MySIDialogMainFileTextBox.AutoSize = $False
  $MySIDialogMainFileTextBox.BackColor = $MyFCGConfig.Colors.TextBack
  $MySIDialogMainFileTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $MySIDialogMainFileTextBox.Font = $MyFCGConfig.Font.Regular
  $MySIDialogMainFileTextBox.ForeColor = $MyFCGConfig.Colors.TextFore
  $MySIDialogMainFileTextBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, ($MySIDialogMainFileLabel.Bottom + $MyFCGConfig.FormSpacer))
  $MySIDialogMainFileTextBox.Name = "MySIDialogMainFileTextBox"
  $MySIDialogMainFileTextBox.ReadOnly = $True
  $MySIDialogMainFileTextBox.Size = New-Object -TypeName System.Drawing.Size((($MySIDialogMainFileButton.Left - $MyFCGConfig.FormSpacer) - $MySIDialogMainFileTextBox.Left), $MySIDialogMainFileButton.Height)
  $MySIDialogMainFileTextBox.TabStop = $False
  $MySIDialogMainFileTextBox.Text = $IconPath
  $MySIDialogMainFileTextBox.Tag = $IconIndex
  $MySIDialogMainFileTextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
  $MySIDialogMainFileTextBox.WordWrap = $False
  #endregion $MySIDialogMainFileTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  
  #region $MySIDialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label
  $MySIDialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label
  $MySIDialogMainPanel.Controls.Add($MySIDialogMainIconLabel)
  $MySIDialogMainIconLabel.AutoSize = $True
  $MySIDialogMainIconLabel.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, ($MySIDialogMainFileTextBox.Bottom + ($MyFCGConfig.FormSpacer * 2)))
  $MySIDialogMainIconLabel.Name = "MySIDialogMainIconLabel"
  $MySIDialogMainIconLabel.TabStop = $False
  $MySIDialogMainIconLabel.Text = $IconMessage
  $MySIDialogMainIconLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
  #endregion $MySIDialogMainIconLabel = New-Object -TypeName System.Windows.Forms.Label
  
  #region $MySIDialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView
  $MySIDialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView
  $MySIDialogMainPanel.Controls.Add($MySIDialogMainIconListView)
  $MySIDialogMainIconListView.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom, Right")
  $MySIDialogMainIconListView.BackColor = $MyFCGConfig.Colors.TextBack
  $MySIDialogMainIconListView.CheckBoxes = $Multi.IsPresent
  $MySIDialogMainIconListView.Font = $MyFCGConfig.Font.Bold
  $MySIDialogMainIconListView.ForeColor = $MyFCGConfig.Colors.TextFore
  $MySIDialogMainIconListView.HeaderStyle = [System.Windows.Forms.ColumnHeaderStyle]::None
  $MySIDialogMainIconListView.HideSelection = $False
  $MySIDialogMainIconListView.LabelWrap = $False
  $MySIDialogMainIconListView.LargeImageList = $MySIDialogImageList
  $MySIDialogMainIconListView.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, ($MySIDialogMainIconLabel.Bottom + $MyFCGConfig.FormSpacer))
  $MySIDialogMainIconListView.MultiSelect = $Multi.IsPresent
  $MySIDialogMainIconListView.Name = "MySIDialogMainIconListView"
  $MySIDialogMainIconListView.ShowGroups = $False
  $MySIDialogMainIconListView.Size = New-Object -TypeName System.Drawing.Size(($MySIDialogMainPanel.ClientSize.Width - ($MyFCGConfig.FormSpacer * 2)), (($MySIDialogMainPanel.ClientSize.Height - $MyFCGConfig.FormSpacer) - $MySIDialogMainIconListView.Top))
  $MySIDialogMainIconListView.Sorting = [System.Windows.Forms.SortOrder]::None
  $MySIDialogMainIconListView.TabIndex = 1
  $MySIDialogMainIconListView.TabStop = $True
  $MySIDialogMainIconListView.Text = "MySIDialogMainIconListView"
  $MySIDialogMainIconListView.View = [System.Windows.Forms.View]::LargeIcon
  #endregion $MySIDialogMainIconListView = New-Object -TypeName System.Windows.Forms.ListView
  
  #region ******** Function Start-MySIDialogMainIconListViewSelectedIndexChanged ********
  function Start-MySIDialogMainIconListViewSelectedIndexChanged
  {
  <#
    .SYNOPSIS
      SelectedIndexChanged Event for the MySIDialogMainIcon ListView Control
    .DESCRIPTION
      SelectedIndexChanged Event for the MySIDialogMainIcon ListView Control
    .PARAMETER Sender
       The ListView Control that fired the SelectedIndexChanged Event
    .PARAMETER EventArg
       The Event Arguments for the ListView SelectedIndexChanged Event
    .EXAMPLE
       Start-MySIDialogMainIconListViewSelectedIndexChanged -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ListView]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter SelectedIndexChanged Event for `$MySIDialogMainIconListView"
    
    $MyFCGConfig.AutoExit = 0
    
    Write-Verbose -Message "Exit SelectedIndexChanged Event for `$MySIDialogMainIconListView"
  }
  #endregion ******** Function Start-MySIDialogMainIconListViewSelectedIndexChanged ********
  $MySIDialogMainIconListView.add_SelectedIndexChanged({ Start-MySIDialogMainIconListViewSelectedIndexChanged -Sender $This -EventArg $PSItem })
  
  #endregion ******** $MySIDialogMainPanel Controls ********
  
  # ************************************************
  # MySIDialogBtm Panel
  # ************************************************
  #region $MySIDialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MySIDialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MySIDialogForm.Controls.Add($MySIDialogBtmPanel)
  $MySIDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MySIDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $MySIDialogBtmPanel.Name = "MySIDialogBtmPanel"
  $MySIDialogBtmPanel.Text = "MySIDialogBtmPanel"
  #endregion $MySIDialogBtmPanel = New-Object -TypeName System.Windows.Forms.Panel
  
  #region ******** $MySIDialogBtmPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($MySIDialogBtmPanel.ClientSize.Width - ($MyFCGConfig.FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $MySIDialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmPanel.Controls.Add($MySIDialogBtmLeftButton)
  $MySIDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $MySIDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $MySIDialogBtmLeftButton.BackColor = $MyFCGConfig.Colors.ButtonBack
  $MySIDialogBtmLeftButton.Font = $MyFCGConfig.Font.Bold
  $MySIDialogBtmLeftButton.ForeColor = $MyFCGConfig.Colors.ButtonFore
  $MySIDialogBtmLeftButton.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, $MyFCGConfig.FormSpacer)
  $MySIDialogBtmLeftButton.Name = "MySIDialogBtmLeftButton"
  $MySIDialogBtmLeftButton.TabIndex = 2
  $MySIDialogBtmLeftButton.TabStop = $True
  $MySIDialogBtmLeftButton.Text = $ButtonLeft
  $MySIDialogBtmLeftButton.Size = New-Object -TypeName System.Drawing.Size($TempWidth, $MySIDialogBtmLeftButton.PreferredSize.Height)
  #endregion $MySIDialogBtmLeftButton = New-Object -TypeName System.Windows.Forms.Button
  
  #region ******** Function Start-MySIDialogBtmLeftButtonClick ********
  function Start-MySIDialogBtmLeftButtonClick
  {
  <#
    .SYNOPSIS
      Click Event for the MySIDialogBtmLeft Button Control
    .DESCRIPTION
      Click Event for the MySIDialogBtmLeft Button Control
    .PARAMETER Sender
       The Button Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the Button Click Event
    .EXAMPLE
       Start-MySIDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MySIDialogBtmLeftButton"
    
    $MyFCGConfig.AutoExit = 0
    
    if (($MySIDialogMainIconListView.CheckedIndices.Count -and $MySIDialogMainIconListView.CheckBoxes) -or ($MySIDialogMainIconListView.SelectedIndices.Count -and (-not $MySIDialogMainIconListView.CheckBoxes)))
    {
      $MySIDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($MySIDialogForm, "No Icons Selected", $MyFCGConfig.ScriptName, "OK", "Warning")
    }
    
    
    Write-Verbose -Message "Exit Click Event for `$MySIDialogBtmLeftButton"
  }
  #endregion ******** Function Start-MySIDialogBtmLeftButtonClick ********
  $MySIDialogBtmLeftButton.add_Click({ Start-MySIDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })
  
  #region $MySIDialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmPanel.Controls.Add($MySIDialogBtmMidButton)
  $MySIDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $MySIDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $MySIDialogBtmMidButton.BackColor = $MyFCGConfig.Colors.ButtonBack
  $MySIDialogBtmMidButton.Font = $MyFCGConfig.Font.Bold
  $MySIDialogBtmMidButton.ForeColor = $MyFCGConfig.Colors.ButtonFore
  $MySIDialogBtmMidButton.Location = New-Object -TypeName System.Drawing.Point(($MySIDialogBtmLeftButton.Right + $MyFCGConfig.FormSpacer), $MyFCGConfig.FormSpacer)
  $MySIDialogBtmMidButton.Name = "MySIDialogBtmMidButton"
  $MySIDialogBtmMidButton.TabIndex = 3
  $MySIDialogBtmMidButton.TabStop = $True
  $MySIDialogBtmMidButton.Text = $ButtonMid
  $MySIDialogBtmMidButton.Size = New-Object -TypeName System.Drawing.Size(($TempWidth + $TempMod), $MySIDialogBtmMidButton.PreferredSize.Height)
  #endregion $MySIDialogBtmMidButton = New-Object -TypeName System.Windows.Forms.Button
  
  #region ******** Function Start-MySIDialogBtmMidButtonClick ********
  function Start-MySIDialogBtmMidButtonClick
  {
  <#
    .SYNOPSIS
      Click Event for the MySIDialogBtmMid Button Control
    .DESCRIPTION
      Click Event for the MySIDialogBtmMid Button Control
    .PARAMETER Sender
       The Button Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the Button Click Event
    .EXAMPLE
       Start-MySIDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MySIDialogBtmMidButton"
    
    $MyFCGConfig.AutoExit = 0
    
    $TempIconIndex = $MySIDialogMainFileTextBox.Tag
    if ($MySIDialogMainIconListView.CheckBoxes)
    {
      $MySIDialogMainIconListView.CheckedIndices | ForEach-Object -Process { $MySIDialogMainIconListView.Items[$PSItem].Checked = $False }
      if ($TempIconIndex.Count -and ($TempIconIndex[0] -gt -1))
      {
        $TempIconIndex | ForEach-Object -Process { $MySIDialogMainIconListView.Items[$PSItem].Checked = $True }
      }
    }
    else
    {
      $MySIDialogMainIconListView.SelectedIndices.Clear()
      if ($TempIconIndex[0] -gt -1)
      {
        $MySIDialogMainIconListView.Items[$TempIconIndex[0]].Selected = $True
        $MySIDialogMainIconListView.Select()
        $MySIDialogMainIconListView.Items[$TempIconIndex[0]].EnsureVisible()
      }
    }
    
    Write-Verbose -Message "Exit Click Event for `$MySIDialogBtmMidButton"
  }
  #endregion ******** Function Start-MySIDialogBtmMidButtonClick ********
  $MySIDialogBtmMidButton.add_Click({ Start-MySIDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })
  
  #region $MySIDialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button
  $MySIDialogBtmPanel.Controls.Add($MySIDialogBtmRightButton)
  $MySIDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $MySIDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $MySIDialogBtmRightButton.BackColor = $MyFCGConfig.Colors.ButtonBack
  $MySIDialogBtmRightButton.Font = $MyFCGConfig.Font.Bold
  $MySIDialogBtmRightButton.ForeColor = $MyFCGConfig.Colors.ButtonFore
  $MySIDialogBtmRightButton.Location = New-Object -TypeName System.Drawing.Point(($MySIDialogBtmMidButton.Right + $MyFCGConfig.FormSpacer), $MyFCGConfig.FormSpacer)
  $MySIDialogBtmRightButton.Name = "MySIDialogBtmRightButton"
  $MySIDialogBtmRightButton.TabIndex = 5
  $MySIDialogBtmRightButton.TabStop = $True
  $MySIDialogBtmRightButton.Text = $ButtonRight
  $MySIDialogBtmRightButton.Size = New-Object -TypeName System.Drawing.Size($TempWidth, $MySIDialogBtmRightButton.PreferredSize.Height)
  #endregion $MySIDialogBtmRightButton = New-Object -TypeName System.Windows.Forms.Button
  
  #region ******** Function Start-MySIDialogBtmRightButtonClick ********
  function Start-MySIDialogBtmRightButtonClick
  {
  <#
    .SYNOPSIS
      Click Event for the MySIDialogBtmRight Button Control
    .DESCRIPTION
      Click Event for the MySIDialogBtmRight Button Control
    .PARAMETER Sender
       The Button Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the Button Click Event
    .EXAMPLE
       Start-MySIDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MySIDialogBtmRightButton"
    
    $MyFCGConfig.AutoExit = 0
    
    # Cancel Code Goes here
    
    $MySIDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    
    Write-Verbose -Message "Exit Click Event for `$MySIDialogBtmRightButton"
  }
  #endregion ******** Function Start-MySIDialogBtmRightButtonClick ********
  $MySIDialogBtmRightButton.add_Click({ Start-MySIDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })
  
  $MySIDialogBtmPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($MySIDialogBtmRightButton.Right + $MyFCGConfig.FormSpacer), ($MySIDialogBtmRightButton.Bottom + $MyFCGConfig.FormSpacer))
  
  #endregion ******** $MySIDialogBtmPanel Controls ********
  
  #endregion ******** Controls for MySIDialog Form ********
  
  #endregion ================ End **** MySIDialog **** End ================
  
  $DialogResult = $MySIDialogForm.ShowDialog()
  if ($MySIDialogMainIconListView.CheckBoxes)
  {
    @{ "Success" = ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK); "DialogResult" = $DialogResult; "IconPath" = $MySIDialogMainFileTextBox.Text; "IconIndex" = @($MySIDialogMainIconListView.CheckedIndices) }
  }
  else
  {
    @{ "Success" = ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK); "DialogResult" = $DialogResult; "IconPath" = $MySIDialogMainFileTextBox.Text; "IconIndex" = @($MySIDialogMainIconListView.SelectedIndices) }
  }
  
  $MySIDialogFormComponents.Dispose()
  $MySIDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-MySIDialog"
}
#endregion function Show-MySIDialog

#region MyHelp Dialog Info Topics

#region $InfoIntro Compressed RTF
$InfoIntro = @"
77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p
bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgSW50b2R1Y3Rpb25ccGFyDQpcYjBc
ZjFcZnMyMFxwYXINClRoaXMgaXMgTXkgSGVscCBJbnRvZHVjdGlvbiFccGFyDQoNClxwYXJkXHNhMjAwXHNsMjc2XHNsbXVsdDFcZjJcZnMyMlxsYW5nOVxwYXINCn0NCgA=
"@
#endregion $InfoIntro Compressed RTF

#region $Info01 Compressed RTF
$Info01 = @"
77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p
bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMDFccGFyDQpcYjBcZjFc
ZnMyMFxwYXINClRoaXMgaXMgTXkgSGVscCBUb3BpYyFccGFyDQoNClxwYXJkXHNhMjAwXHNsMjc2XHNsbXVsdDFcZjJcZnMyMlxsYW5nOVxwYXINCn0NCgA=
"@
#endregion $Info01 Compressed RTF

#region $Info02 Compressed RTF
$Info02 = @"
77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p
bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMFxmMSAyXGYwXHBhcg0K
XGIwXGYxXGZzMjBccGFyDQpUaGlzIGlzIE15IEhlbHAgVG9waWMhXHBhcg0KDQpccGFyZFxzYTIwMFxzbDI3NlxzbG11bHQxXGYyXGZzMjJcbGFuZzlccGFyDQp9DQoA
"@
#endregion $Info02 Compressed RTF

#region $Info03 Compressed RTF
$Info03 = @"
77u/e1xydGYxXGFuc2lcYW5zaWNwZzEyNTJcZGVmZjBcbm91aWNvbXBhdFxkZWZsYW5nMTAzM3tcZm9udHRibHtcZjBcZm5pbCBWZXJkYW5hO317XGYxXGZuaWxcZmNoYXJzZXQwIFZlcmRhbmE7fXtcZjJcZm5p
bFxmY2hhcnNldDAgQ2FsaWJyaTt9fQ0Ke1wqXGdlbmVyYXRvciBSaWNoZWQyMCAxMC4wLjE5MDQxfVx2aWV3a2luZDRcdWMxIA0KXHBhcmRccWNcYlxmMFxmczMwIEhlbHAgVG9waWMgMFxmMSAzXGYwXHBhcg0K
XGIwXGYxXGZzMjBccGFyDQpUaGlzIGlzIE15IEhlbHAgVG9waWMhXHBhcg0KDQpccGFyZFxzYTIwMFxzbDI3NlxzbG11bHQxXGYyXGZzMjJcbGFuZzlccGFyDQp9DQoA
"@
#endregion $Info03 Compressed RTF

$MyHelpDialogTopics = [Ordered]@{ }
$MyHelpDialogContent = [Ordered]@{ }

$MyHelpDialogTopics.Add("InfoIntro", "Info Introduction")
$MyHelpDialogContent.Add("InfoIntro", $InfoIntro)

$MyHelpDialogTopics.Add("Info01", "Info Topic 01")
$MyHelpDialogContent.Add("Info01", $Info01)

$MyHelpDialogTopics.Add("Info02", "Info Topic 02")
$MyHelpDialogContent.Add("Info02", $Info02)

$MyHelpDialogTopics.Add("Info03", "Info Topic 03")
$MyHelpDialogContent.Add("Info03", $Info03)

$InfoIntro = $Null
$Info01 = $Null
$Info02 = $Null
$Info03 = $Null

#endregion MyHelp Dialog Info Topics

#region function Show-MyHelpDialog
function Show-MyHelpDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-MyHelpDialog
    .DESCRIPTION
      Shows Show-MyHelpDialog
    .PARAMETER DialogTitle
    .PARAMETER WindowsTitle
    .PARAMETER InfoTitle
    .PARAMETER DefInfoTopic
    .PARAMETER Width
    .PARAMETER Height
    .EXAMPLE
      $Return = Show-MyHelpDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$DialogTitle = "$($MyFCGConfig.ScriptName)",
    [String]$WindowTitle = "$($MyFCGConfig.ScriptName) Info",
    [String]$InfoTitle = " << MyFCG Info Topics >> ",
    [String]$DefInfoTopic = "InfoIntro",
    [Int]$Width = 60,
    [Int]$Height = 24
  )
  Write-Verbose -Message "Enter Function Show-MyHelpDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** MyHelpDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # MyHelpDialog Form
  # ************************************************
  #region $MyHelpDialogForm = New-Object -TypeName System.Windows.Forms.Form
  $MyHelpDialogForm = New-Object -TypeName System.Windows.Forms.Form
  $MyHelpDialogForm.BackColor = $MyFCGConfig.Colors.Back
  $MyHelpDialogForm.Font = $MyFCGConfig.Font.Regular
  $MyHelpDialogForm.ForeColor = $MyFCGConfig.Colors.Fore
  $MyHelpDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  $MyHelpDialogForm.Icon = $MyFCGForm.Icon
  $MyHelpDialogForm.MaximizeBox = $False
  $MyHelpDialogForm.MinimizeBox = $False
  $MyHelpDialogForm.MinimumSize = New-Object -TypeName System.Drawing.Size(($MyFCGConfig.Font.Width * $Width), ($MyFCGConfig.Font.Height * $Height))
  $MyHelpDialogForm.Name = "MyHelpDialogForm"
  $MyHelpDialogForm.Owner = $MyFCGForm
  $MyHelpDialogForm.ShowInTaskbar = $False
  $MyHelpDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyHelpDialogForm.Text = $DialogTitle
  #endregion $MyHelpDialogForm = New-Object -TypeName System.Windows.Forms.Form
  
  #region ******** Function Start-MyHelpDialogFormMove ********
  function Start-MyHelpDialogFormMove
  {
  <#
    .SYNOPSIS
      Move Event for the MyHelpDialog Form Control
    .DESCRIPTION
      Move Event for the MyHelpDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the Move Event
    .PARAMETER EventArg
       The Event Arguments for the Form Move Event
    .EXAMPLE
       Start-MyHelpDialogFormMove -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Move Event for `$MyHelpDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    Write-Verbose -Message "Exit Move Event for `$MyHelpDialogForm"
  }
  #endregion ******** Function Start-MyHelpDialogFormMove ********
  $MyHelpDialogForm.add_Move({ Start-MyHelpDialogFormMove -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-MyHelpDialogFormResize ********
  function Start-MyHelpDialogFormResize
  {
  <#
    .SYNOPSIS
      Resize Event for the MyHelpDialog Form Control
    .DESCRIPTION
      Resize Event for the MyHelpDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the Resize Event
    .PARAMETER EventArg
       The Event Arguments for the Form Resize Event
    .EXAMPLE
       Start-MyHelpDialogFormResize -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Resize Event for `$MyHelpDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    Write-Verbose -Message "Exit Resize Event for `$MyHelpDialogForm"
  }
  #endregion ******** Function Start-MyHelpDialogFormResize ********
  $MyHelpDialogForm.add_Resize({ Start-MyHelpDialogFormResize -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-MyHelpDialogFormShown ********
  function Start-MyHelpDialogFormShown
  {
  <#
    .SYNOPSIS
      Shown Event for the MyHelpDialog Form Control
    .DESCRIPTION
      Shown Event for the MyHelpDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the Shown Event
    .PARAMETER EventArg
       The Event Arguments for the Form Shown Event
    .EXAMPLE
       Start-MyHelpDialogFormShown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MyHelpDialogForm"
    
    $MyFCGConfig.AutoExit = 0
    
    $Sender.Refresh()
    
    Start-MyHelpDialogLeftToolStripItemClick -Sender ($MyHelpDialogLeftMenuStrip.Items[$DefInfoTopic]) -EventArg $EventArg
    
    Write-Verbose -Message "Exit Shown Event for `$MyHelpDialogForm"
  }
  #endregion ******** Function Start-MyHelpDialogFormShown ********
  $MyHelpDialogForm.add_Shown({ Start-MyHelpDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for MyHelpDialog Form ********
  
  # ************************************************
  # MyHelpDialogMain Panel
  # ************************************************
  #region $MyHelpDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyHelpDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyHelpDialogForm.Controls.Add($MyHelpDialogMainPanel)
  $MyHelpDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyHelpDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $MyHelpDialogMainPanel.Name = "MyHelpDialogMainPanel"
  $MyHelpDialogMainPanel.Text = "MyHelpDialogMainPanel"
  #endregion $MyHelpDialogMainPanel = New-Object -TypeName System.Windows.Forms.Panel
  
  #region ******** $MyHelpDialogMainPanel Controls ********
  
  #region $MyHelpDialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
  $MyHelpDialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
  $MyHelpDialogMainPanel.Controls.Add($MyHelpDialogMainRichTextBox)
  $MyHelpDialogMainRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom, Right")
  $MyHelpDialogMainRichTextBox.BackColor = $MyFCGConfig.Colors.TextBack
  $MyHelpDialogMainRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $MyHelpDialogMainRichTextBox.DetectUrls = $True
  $MyHelpDialogMainRichTextBox.Font = $MyFCGConfig.Font.Regular
  $MyHelpDialogMainRichTextBox.ForeColor = $MyFCGConfig.Colors.TextFore
  $MyHelpDialogMainRichTextBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, $MyFCGConfig.FormSpacer)
  $MyHelpDialogMainRichTextBox.MaxLength = [Int]::MaxValue
  $MyHelpDialogMainRichTextBox.Multiline = $True
  $MyHelpDialogMainRichTextBox.Name = "MyHelpDialogMainRichTextBox"
  $MyHelpDialogMainRichTextBox.ReadOnly = $True
  $MyHelpDialogMainRichTextBox.Rtf = ""
  $MyHelpDialogMainRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
  $MyHelpDialogMainRichTextBox.Size = New-Object -TypeName System.Drawing.Size(($MyHelpDialogMainPanel.ClientSize.Width - ($MyFCGConfig.FormSpacer * 2)), ($MyHelpDialogMainPanel.ClientSize.Height - ($MyHelpDialogMainRichTextBox.Top + $MyFCGConfig.FormSpacer)))
  $MyHelpDialogMainRichTextBox.TabStop = $False
  $MyHelpDialogMainRichTextBox.Text = ""
  $MyHelpDialogMainRichTextBox.WordWrap = $False
  #endregion $MyHelpDialogMainRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
  
  #endregion ******** $MyHelpDialogMainPanel Controls ********
  
  # ************************************************
  # MyHelpDialogLeft MenuStrip
  # ************************************************
  #region $MyHelpDialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
  $MyHelpDialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
  $MyHelpDialogForm.Controls.Add($MyHelpDialogLeftMenuStrip)
  $MyHelpDialogForm.MainMenuStrip = $MyHelpDialogLeftMenuStrip
  $MyHelpDialogLeftMenuStrip.BackColor = $MyFCGConfig.Colors.Back
  $MyHelpDialogLeftMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left
  $MyHelpDialogLeftMenuStrip.Font = $MyFCGConfig.Font.Regular
  $MyHelpDialogLeftMenuStrip.ForeColor = $MyFCGConfig.Colors.Fore
  $MyHelpDialogLeftMenuStrip.ImageList = $MyFCGImageList
  $MyHelpDialogLeftMenuStrip.Name = "MyHelpDialogLeftMenuStrip"
  $MyHelpDialogLeftMenuStrip.ShowItemToolTips = $True
  $MyHelpDialogLeftMenuStrip.Text = "MyHelpDialogLeftMenuStrip"
  #endregion $MyHelpDialogLeftMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
  
  #region ******** Function Start-MyHelpDialogLeftToolStripItemClick ********
  function Start-MyHelpDialogLeftToolStripItemClick
  {
  <#
    .SYNOPSIS
      Click Event for the MyHelpDialogLeft ToolStripItem Control
    .DESCRIPTION
      Click Event for the MyHelpDialogLeft ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-MyHelpDialogLeftToolStripItemClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ToolStripItem]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyHelpDialogLeftToolStripItem"
    
    $MyFCGConfig.AutoExit = 0
    
    $MyHelpDialogBtmStatusStrip.Items["Status"].Text = "Showing: $($Sender.Text)"
    
    Switch ($Sender.Name)
    {
      "Exit"
      {
        $MyHelpDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        Break
      }
      Default
      {
        $MyHelpDialogMainRichTextBox.Clear()
        $MyHelpDialogMainRichTextBox.Rtf = (Decode-MyData -Data $MyHelpDialogContent[$Sender.Name] -AsString)
        Break
      }
    }
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Click Event for `$MyHelpDialogLeftToolStripItem"
  }
  #endregion ******** Function Start-MyHelpDialogLeftToolStripItemClick ********
  
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip
  New-MenuLabel -Menu $MyHelpDialogLeftMenuStrip -Text $InfoTitle -Name "Info Topics" -Tag "Info Topics" -Font ($MyFCGConfig.Font.Bold)
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip
  
  forEach ($Key in $MyHelpDialogTopics.Keys)
  {
    (New-MenuItem -Menu $MyHelpDialogLeftMenuStrip -Text ($MyHelpDialogTopics[$Key]) -Name $Key -Tag $Key -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({ Start-MyHelpDialogLeftToolStripItemClick -Sender $This -EventArg $PSItem })
  }
  
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip
  (New-MenuItem -Menu $MyHelpDialogLeftMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({ Start-MyHelpDialogLeftToolStripItemClick -Sender $This -EventArg $PSItem })
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip
  
  #region $MyHelpDialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyHelpDialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyHelpDialogForm.Controls.Add($MyHelpDialogTopPanel)
  $MyHelpDialogTopPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyHelpDialogTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
  $MyHelpDialogTopPanel.Name = "MyHelpDialogTopPanel"
  $MyHelpDialogTopPanel.Text = "MyHelpDialogTopPanel"
  #endregion $MyHelpDialogTopPanel = New-Object -TypeName System.Windows.Forms.Panel
  
  #region ******** $MyHelpDialogTopPanel Controls ********
  
  #region $MyHelpDialogTopLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyHelpDialogTopLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyHelpDialogTopPanel.Controls.Add($MyHelpDialogTopLabel)
  $MyHelpDialogTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $MyHelpDialogTopLabel.BackColor = $MyFCGConfig.Colors.TitleBack
  $MyHelpDialogTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyHelpDialogTopLabel.Font = $MyFCGConfig.Font.Title
  $MyHelpDialogTopLabel.ForeColor = $MyFCGConfig.Colors.TitleFore
  $MyHelpDialogTopLabel.Location = New-Object -TypeName System.Drawing.Point($MyFCGConfig.FormSpacer, $MyFCGConfig.FormSpacer)
  $MyHelpDialogTopLabel.Name = "MyHelpDialogTopLabel"
  $MyHelpDialogTopLabel.Text = $WindowTitle
  $MyHelpDialogTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyHelpDialogTopLabel.Size = New-Object -TypeName System.Drawing.Size(($MyHelpDialogTopPanel.ClientSize.Width - ($MyFCGConfig.FormSpacer * 2)), $MyHelpDialogTopLabel.PreferredHeight)
  #endregion $MyHelpDialogTopLabel = New-Object -TypeName System.Windows.Forms.Label
  
  $MyHelpDialogTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size($MyHelpDialogTopPanel.ClientSize.Width, ($MyHelpDialogTopLabel.Bottom + $MyFCGConfig.FormSpacer))
  
  #endregion ******** $MyHelpDialogTopPanel Controls ********
  
  # ************************************************
  # MyHelpDialogBtm StatusStrip
  # ************************************************
  #region $MyHelpDialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
  $MyHelpDialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
  $MyHelpDialogForm.Controls.Add($MyHelpDialogBtmStatusStrip)
  $MyHelpDialogBtmStatusStrip.BackColor = $MyFCGConfig.Colors.Back
  $MyHelpDialogBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $MyHelpDialogBtmStatusStrip.Font = $MyFCGConfig.Font.Regular
  $MyHelpDialogBtmStatusStrip.ForeColor = $MyFCGConfig.Colors.Fore
  $MyHelpDialogBtmStatusStrip.ImageList = $MyFCGImageList
  $MyHelpDialogBtmStatusStrip.Name = "MyHelpDialogBtmStatusStrip"
  $MyHelpDialogBtmStatusStrip.ShowItemToolTips = $True
  $MyHelpDialogBtmStatusStrip.Text = "MyHelpDialogBtmStatusStrip"
  #endregion $MyHelpDialogBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
  
  New-MenuLabel -Menu $MyHelpDialogBtmStatusStrip -Text "Status" -Name "Status" -Tag "Status"
  
  #endregion ******** Controls for MyHelpDialog Form ********
  
  #endregion ================ End **** MyHelpDialog **** End ================
  
  [Void]$MyHelpDialogForm.ShowDialog()
  
  $MyHelpDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-MyHelpDialog"
}
#endregion function Show-MyHelpDialog


#region function Build-MyScriptLibrary
function Build-MyScriptLibrary ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScriptLibrary -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName
  )
  Write-Verbose -Message "Enter Function Build-MyScriptLibrary"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  #region ******** My Code ********
  
  [Void]$StringBuilder.Append((Build-MyScriptWindowsAPIs -MyScriptName $MyScriptName))
  [Void]$StringBuilder.Append((Build-MyScriptFunctions -MyScriptName $MyScriptName))
  [Void]$StringBuilder.Append((Build-MyScriptMultiThread -MyScriptName $MyScriptName))
  [Void]$StringBuilder.Append((Build-MyScriptJobsThreads -MyScriptName $MyScriptName))
  
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptLibrary"
}
#endregion function Build-MyScriptLibrary

#region function Build-MyScriptEvent
function Build-MyScriptEvent ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Build-MyScriptEvent
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$MyScriptName,
    [String]$MyControlName,
    [Object]$Control,
    [Object[]]$ControlEvent
  )
  Write-Verbose -Message "Enter Function Build-MyScriptEvent"
  
  $ControlName = $Control.Name
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  ForEach ($TempEvent in $ControlEvent)
  {
    $EventName = $TempEvent.Name
    if ($Control.Name -eq "Form")
    {
      $FunctionName = "$($MyScriptName)$($ControlName)$($EventName)"
    }
    else
    {
      $FunctionName = "$($MyScriptName)$($MyControlName)$($ControlName)$($EventName)"
    }
    
    #region ******** My Code ********
    [Void]$StringBuilder.AppendLine("#region ******** Function Start-$($FunctionName) ********")
    [Void]$StringBuilder.AppendLine("function Start-$($FunctionName)")
    [Void]$StringBuilder.AppendLine("{")
    [Void]$StringBuilder.AppendLine("  <#")
    [Void]$StringBuilder.AppendLine("    .SYNOPSIS")
    [Void]$StringBuilder.AppendLine("      $($EventName) Event for the $($MyScriptName)$($MyControlName) $($ControlName) Control")
    [Void]$StringBuilder.AppendLine("    .DESCRIPTION")
    [Void]$StringBuilder.AppendLine("      $($EventName) Event for the $($MyScriptName)$($MyControlName) $($ControlName) Control")
    [Void]$StringBuilder.AppendLine("    .PARAMETER Sender")
    [Void]$StringBuilder.AppendLine("       The $($ControlName) Control that fired the $($EventName) Event")
    [Void]$StringBuilder.AppendLine("    .PARAMETER EventArg")
    [Void]$StringBuilder.AppendLine("       The Event Arguments for the $($ControlName) $($EventName) Event")
    [Void]$StringBuilder.AppendLine("    .EXAMPLE")
    [Void]$StringBuilder.AppendLine("       Start-$($FunctionName) -Sender `$Sender -EventArg `$EventArg")
    [Void]$StringBuilder.AppendLine("    .NOTES")
    [Void]$StringBuilder.AppendLine("      Original Function By $([System.Environment]::UserName)")
    [Void]$StringBuilder.AppendLine("  #>")
    [Void]$StringBuilder.AppendLine("  [CmdletBinding()]")
    [Void]$StringBuilder.AppendLine("  param (")
    [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
    [Void]$StringBuilder.AppendLine("    [$($Control.Fullname)]`$Sender,")
    [Void]$StringBuilder.AppendLine("    [parameter(Mandatory = `$True)]")
    [Void]$StringBuilder.AppendLine("    [Object]`$EventArg")
    [Void]$StringBuilder.AppendLine("  )")
    [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Enter $($EventName) Event for ```$$($MyScriptName)$($MyControlName)$($ControlName)`"")
    [Void]$StringBuilder.AppendLine("  #`$$($MyScriptName)Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor")
    [Void]$StringBuilder.AppendLine("")
    
    if (($Control.Name -eq "Timer") -and ($TempEvent.Name -eq "Tick"))
    {
      [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.AutoExit += 1")
      [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Auto Exit in `$(`$$($MyScriptName)Config.AutoExitMax - `$$($MyScriptName)Config.AutoExit) Minutes`"")
      [Void]$StringBuilder.AppendLine("  if (`$$($MyScriptName)Config.AutoExit -ge `$$($MyScriptName)Config.AutoExitMax)")
      [Void]$StringBuilder.AppendLine("  {")
      [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Close()")
      [Void]$StringBuilder.AppendLine("  }")
      [Void]$StringBuilder.AppendLine("  ElseIf (($MyFCGConfig.AutoExitMax - $MyFCGConfig.AutoExit) -le 5)")
      [Void]$StringBuilder.AppendLine("  {")
      [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)BtmStatusStrip.Items[`"Status`"].Text = `"Auto Exit in `$(`$$($MyScriptName)Config.AutoExitMax - `$$($MyScriptName)Config.AutoExit) Minutes`"")
      [Void]$StringBuilder.AppendLine("  }")
    }
    else
    {
      [Void]$StringBuilder.AppendLine("  `$$($MyScriptName)Config.AutoExit = 0")
    }
    [Void]$StringBuilder.AppendLine("")
    
    Switch ($Control.Name)
    {
      "Form"
      {
        Switch ($TempEvent.Name)
        {
          "Shown"
          {
            [Void]$StringBuilder.AppendLine("  `$Sender.Refresh()")
            Break
          }
          "KeyDown"
          {
            [Void]$StringBuilder.AppendLine("  if (`$EventArg.Control -and `$EventArg.Alt -and `$EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F10)")
            [Void]$StringBuilder.AppendLine("  {")
            [Void]$StringBuilder.AppendLine("    if (`$$($MyScriptName)Form.Tag)")
            [Void]$StringBuilder.AppendLine("    {")
            [Void]$StringBuilder.AppendLine("      # Hide Console Window")
            [Void]$StringBuilder.AppendLine("      `$Script:VerbosePreference = `"SilentlyContinue`"")
            [Void]$StringBuilder.AppendLine("      `$Script:DebugPreference = `"SilentlyContinue`"")
            [Void]$StringBuilder.AppendLine("      [System.Console]::Title = `"RUNNING: `$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`"")
            [Void]$StringBuilder.AppendLine("      [Void][Console.Window]::Hide()")
            [Void]$StringBuilder.AppendLine("      `$$($MyScriptName)Form.Tag = `$False")
            [Void]$StringBuilder.AppendLine("    }")
            [Void]$StringBuilder.AppendLine("    else")
            [Void]$StringBuilder.AppendLine("    {")
            [Void]$StringBuilder.AppendLine("      # Show Console Window")
            [Void]$StringBuilder.AppendLine("      `$Script:VerbosePreference = `"Continue`"")
            [Void]$StringBuilder.AppendLine("      `$Script:DebugPreference = `"Continue`"")
            [Void]$StringBuilder.AppendLine("      [Void][Console.Window]::Show()")
            [Void]$StringBuilder.AppendLine("      [System.Console]::Title = `"DEBUG: `$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`"")
            [Void]$StringBuilder.AppendLine("      `$$($MyScriptName)Form.Tag = `$True")
            [Void]$StringBuilder.AppendLine("    }")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Activate()")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Select()")
            [Void]$StringBuilder.AppendLine("  }")
            [Void]$StringBuilder.AppendLine("  elseif (`$EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F1)")
            [Void]$StringBuilder.AppendLine("  {")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)ToolTip.Active = (-not `$$($MyScriptName)ToolTip.Active)")
            [Void]$StringBuilder.AppendLine("  }")
            Break
          }
          "Closing"
          {
            [Void]$StringBuilder.AppendLine("  if (`$$($MyScriptName)Config.Production)")
            [Void]$StringBuilder.AppendLine("  {")
            [Void]$StringBuilder.AppendLine("    # Show Console Window")
            [Void]$StringBuilder.AppendLine("    `$Script:VerbosePreference = `"Continue`"")
            [Void]$StringBuilder.AppendLine("    `$Script:DebugPreference = `"Continue`"")
            [Void]$StringBuilder.AppendLine("")
            [Void]$StringBuilder.AppendLine("    [Void][Console.Window]::Show()")
            [Void]$StringBuilder.AppendLine("    [System.Console]::Title = `"CLOSING: `$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`"")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Tag = `$True")
            [Void]$StringBuilder.AppendLine("  }")
            Break
          }
          "Load"
          {
            [Void]$StringBuilder.AppendLine("  `$Screen = ([System.Windows.Forms.Screen]::FromControl(`$Sender)).WorkingArea")
            [Void]$StringBuilder.AppendLine("  `$Sender.Left = [Math]::Floor((`$Screen.Width - `$Sender.Width) / 2)")
            [Void]$StringBuilder.AppendLine("  `$Sender.Top = [Math]::Floor((`$Screen.Height - `$Sender.Height) / 2)")
            [Void]$StringBuilder.AppendLine("")
            [Void]$StringBuilder.AppendLine("  if (`$$($MyScriptName)Config.Production)")
            [Void]$StringBuilder.AppendLine("  {")
            [Void]$StringBuilder.AppendLine("    # Enable `$$($MyScriptName)Timer")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Timer.Enabled = (`$$($MyScriptName)Config.AutoExitMax -gt 0)")
            [Void]$StringBuilder.AppendLine("")
            [Void]$StringBuilder.AppendLine("    # Disable Control Close Menu / [X]")
            [Void]$StringBuilder.AppendLine("    #[ControlBox.Menu]::DisableFormClose(`$$($MyScriptName)Form.Handle)")
            [Void]$StringBuilder.AppendLine("")
            [Void]$StringBuilder.AppendLine("    # Hide Console Window")
            [Void]$StringBuilder.AppendLine("    `$Script:VerbosePreference = `"SilentlyContinue`"")
            [Void]$StringBuilder.AppendLine("    `$Script:DebugPreference = `"SilentlyContinue`"")
            [Void]$StringBuilder.AppendLine("")
            [Void]$StringBuilder.AppendLine("    [System.Console]::Title = `"RUNNING: `$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`"")
            [Void]$StringBuilder.AppendLine("    [Void][Console.Window]::Hide()")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Tag = `$False")
            [Void]$StringBuilder.AppendLine("  }")
            [Void]$StringBuilder.AppendLine("  else")
            [Void]$StringBuilder.AppendLine("  {")
            [Void]$StringBuilder.AppendLine("    [Void][Console.Window]::Show()")
            [Void]$StringBuilder.AppendLine("    [System.Console]::Title = `"DEBUG: `$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`"")
            [Void]$StringBuilder.AppendLine("    `$$($MyScriptName)Form.Tag = `$True")
            [Void]$StringBuilder.AppendLine("  }")
            Break
          }
        }
        Break
      }
      Default
      {
        Switch ($TempEvent.Name)
        {
          "ColumnClick"
          {
            [Void]$StringBuilder.AppendLine("  `$Sender.ListViewItemSorter.Column = `$EventArg.Column")
            [Void]$StringBuilder.AppendLine("  `$Sender.ListViewItemSorter.Ascending = (-not `$Sender.ListViewItemSorter.Ascending)")
            [Void]$StringBuilder.AppendLine("  `$Sender.Sort()")
            Break
          }
          "DrawItem"
          {
            [Void]$StringBuilder.AppendLine("  #`$EventArg.DrawBackground()")
            [Void]$StringBuilder.AppendLine("  #`$EventArg.Graphics.DrawString(`$Sender.Items[`$EventArg.Index].Text, `$EventArg.Font, `$(New-Object -TypeName System.Drawing.SolidBrush(`$Sender.ForeColor)), `$EventArg.Bounds.X, `$EventArg.Bounds.Y, [System.Drawing.StringFormat]::GenericTypographic)")
            break
          }
          Default
          {
            [Void]$StringBuilder.AppendLine("  #`$$($MyScriptName)BtmStatusStrip.Items[`"Status`"].Text = `"`$(`$Sender.Name)`"")
            Break
          }
        }
        Break
      }
    }
    
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("  [System.GC]::Collect()")
    [Void]$StringBuilder.AppendLine("  [System.GC]::WaitForPendingFinalizers()")
    [Void]$StringBuilder.AppendLine("")
    [Void]$StringBuilder.AppendLine("  #`$$($MyScriptName)Form.Cursor = [System.Windows.Forms.Cursors]::Arrow")
    [Void]$StringBuilder.AppendLine("  Write-Verbose -Message `"Exit $($EventName) Event for ```$$($MyScriptName)$($MyControlName)$($ControlName)`"")
    [Void]$StringBuilder.AppendLine("}")
    [Void]$StringBuilder.AppendLine("#endregion ******** Function Start-$($FunctionName) ********")
    [Void]$StringBuilder.AppendLine("`$$($MyScriptName)$($MyControlName)$($ControlName).$($TempEvent.AddMethod.Name)({Start-$($FunctionName) -Sender `$This -EventArg `$PSItem})")
    [Void]$StringBuilder.AppendLine("")
    #endregion ******** My Code ********
    
    $EventName = $Null
    $FunctionName = $Null
  }
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  $ControlName = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptEvent"
}
#endregion function Build-MyScriptEvent

#region function Build-MyScriptControl
function Build-MyScriptControl ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .EXAMPLE
      Build-MyScriptControl
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$MyScriptName,
    [String]$MyControlName,
    [Object]$Control
  )
  Write-Verbose -Message "Enter Function Build-MyScriptControl"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  if ($Control.Name -eq "Form")
  {
    $TempName = "$($MyScriptName)"
    $TempControlName = "$($MyScriptName)$($Control.Name)"
    $TempControl = "`$$($MyScriptName)$($Control.Name)"
  }
  else
  {
    $TempName = "$($MyScriptName)$($MyControlName)"
    $TempControlName = "$($MyScriptName)$($MyControlName)$($Control.Name)"
    $TempControl = "`$$($MyScriptName)$($MyControlName)$($Control.Name)"
  }
  
  #region ******** My Code ********
  
  # Form Container Controls Notes / Comments Section
  if ($Control.Name -in @("ImageList", "Form", "ContextMenuStrip", "MenuStrip", "ToolStrip", "ToolStripContainer", "StatusStrip", "GroupBox", "Panel", "SplitContainer", "TabControl"))
  {
    [Void]$StringBuilder.AppendLine("# ************************************************")
    [Void]$StringBuilder.AppendLine("# $($TempName) $($Control.Name)")
    [Void]$StringBuilder.AppendLine("# ************************************************")
  }
  [Void]$StringBuilder.AppendLine("#region $($TempControl) = New-Object -TypeName $($Control.FullName)")
  
  #region ******** Add Constructors ********
  Switch ($Control.Name)
  {
    { $PSItem -in @("Timer", "ImageList", "ToolTip", "NotifyIcon") }
    {
      [Void]$StringBuilder.AppendLine("$($TempControl) = New-Object -TypeName $($Control.FullName)(`$$($TempName)FormComponents)")
      Break
    }
    Default
    {
      ForEach ($Constructor in @(Get-MyFormControlConstructors -Control $Control))
      {
        $Parameters = @($Constructor.GetParameters())
        if ($Parameters.Count)
        {
          [Void]$StringBuilder.AppendLine("$($TempControl) = New-Object -TypeName $($Control.FullName)($(@($Parameters | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "))")
        }
        else
        {
          [Void]$StringBuilder.AppendLine("$($TempControl) = New-Object -TypeName $($Control.FullName)")
        }
      }
      Break
    }
  }
  #endregion ******** Add Constructors ********
  
  #region ******** Add Control ********
  Switch ($Control.Name)
  {
    { $PSItem -in @("Timer", "ImageList", "ToolTip", "NotifyIcon", "Form", "ColorDialog", "FolderBrowserDialog", "FontDialog", "OpenFileDialog", "PageSetupDialog", "PrintPreviewDialog", "SaveFileDialog") }
    {
      # Skip These Controls
      Break
    }
    "Button"
    {
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Controls.Add($($TempControl))")
      [Void]$StringBuilder.AppendLine("# Evenly Space Buttons - Move Size to after Text")
      [Void]$StringBuilder.AppendLine("#`$NumButtons = 2")
      [Void]$StringBuilder.AppendLine("#`$TempSpace = [Math]::Floor(`$Container.ClientSize.Width - (`$$($MyScriptName)Config.FormSpacer * (`$NumButtons + 1)))")
      [Void]$StringBuilder.AppendLine("#`$TempWidth = [Math]::Floor(`$TempSpace / `$NumButtons)")
      [Void]$StringBuilder.AppendLine("#`$TempMod = `$TempSpace % `$NumButtons")
      [Void]$StringBuilder.AppendLine("#$($TempControl).Size = New-Object -TypeName System.Drawing.Size(`$TempWidth, $($TempControl).PreferredSize.Height)")
      Break
    }
    "ColumnHeader"
    {
      [Void]$StringBuilder.AppendLine("[Void]`$ListView.Columns.Add($($StringBuilder))")
      Break
    }
    "TreeNode"
    {
      [Void]$StringBuilder.AppendLine("[Void]`$TreeView.Nodes.Add($($TempControl))")
      Break
    }
    "ListViewItem"
    {
      [Void]$StringBuilder.AppendLine("[Void]`$ListView.Items.Add($($TempControl))")
      Break
    }
    "GroupBox"
    {
      [Void]$StringBuilder.AppendLine("# Location of First Control = New-Object -TypeName System.Drawing.Point(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.Font.Height)")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Controls.Add($($TempControl))")
      Break
    }
    "TabPage"
    {
      [Void]$StringBuilder.AppendLine("[Void]`$TabControl.Controls.Add($($TempControl))")
      Break
    }
    "DataGridView"
    {
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Controls.Add($TempControl)")
      Break
    }
    { $PSItem -like @("DataGridView*") }
    {
      [Void]$StringBuilder.AppendLine("[Void]`$DataGridView.Columns.Add($($TempControl))")
      Break
    }
    { $PSItem -in @("ContextMenuStrip", "MenuStrip", "ToolStrip", "StatusStrip") }
    {
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Controls.Add($($TempControl))")
      if ($Control.Name -eq "MenuStrip")
      {
        [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Main$($Control.Name) = $($TempControl)")
      }
      else
      {
        [Void]$StringBuilder.AppendLine("#`$$($MyScriptName)Form.$($Control.Name) = $($TempControl)")
      }
      Break
    }
    { $PSItem -like @("ToolStrip*") }
    {
      [Void]$StringBuilder.AppendLine("#[Void]`$ToolMenuStrip.Items.Add($($TempControl))")
      [Void]$StringBuilder.AppendLine("#[Void]`$ToolMenuStrip.DropDownItems.Add($($TempControl))")
      Break
    }
    Default
    {
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)Form.Controls.Add($TempControl)")
      Break
    }
  }
  #endregion ******** Add Control ********
  
  #region ******** Add Properties ********
  $DefaultControl = New-Object -TypeName ($Control.FullName)
  ForEach ($Property in @(Get-MyFormControlProperties -Control $Control | Where-Object -FilterScript { $PSItem.Name -notlike "Access*" }))
  {
    $DefaultValue = $($DefaultControl.PSObject.Properties[($Property.Name)].Value)
    Switch ($Property.PropertyType.FullName)
    {
      { $PSItem -in @("System.Windows.Forms.IWindowTarget", "System.ComponentModel.ISite", "System.IFormatProvider") }
      {
        # Ignore These Properties...
        Break
      }
      "System.String"
      {
        #region System.String
        Switch ($Property.Name)
        {
          "DisplayMember" { $CodeValue = "`"Text`""; Break }
          "ValueMember" { $CodeValue = "`"Value`""; Break }
          "Name" { $CodeValue = "`"$($TempControlName)`""; Break }
          "ToolTipTitle" { $CodeValue = "`"`$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`""; Break }
          "Text"
          {
            if ($Control.Name -eq "Form")
            {
              $CodeValue = "`"`$(`$$($MyScriptName)Config.ScriptName) - `$(`$$($MyScriptName)Config.ScriptVersion)`""
            }
            else
            {
              $CodeValue = "`"$($TempControlName)`""
            }
            Break
          }
          Default { $CodeValue = "`"$($DefaultValue)`""; Break }
        }
        if ($Property.Name -in @("Name", "Text"))
        {
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.String
        Break
      }
      "System.Char"
      {
        #region System.Char
        if ($Property.Name -eq "PasswordChar")
        {
          $CodeValue = "`"`""
        }
        else
        {
          $CodeValue = "`"$($DefaultValue)`""
        }
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        #endregion System.Char
        Break
      }
      "System.Boolean"
      {
        #region System.Boolean
        if ((($Control.Name -eq "Form") -and ($Property.Name -eq "KeyPreview")) -or (($Control.Name -eq "Button") -and ($Property.Name -eq "KeyPreview")))
        {
          $CodeValue = "`$True"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        ElseIf (($Control.Name -in @("ListBox", "CheckedListBox")) -and ($Property.Name -eq "IntegralHeight"))
        {
          $CodeValue = "`$False"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          $CodeValue = "`$$($DefaultValue)"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.Boolean
        Break
      }
      "System.Int32"
      {
        #region System.Int32
        Switch ($Property.Name)
        {
          "ItemHeight" { $CodeValue = "`$$($MyScriptName)Config.Font.Height"; Break }
          "Interval" { $CodeValue = "`$$($MyScriptName)Config.AutoExitTic"; Break }
          Default { $CodeValue = "$($DefaultValue)"; Break }
        }
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        #endregion System.Int32
        Break
      }
      "System.Int32[]"
      {
        $CodeValue = ($DefaultValue -join ", ")
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.String[]"
      {
        $CodeValue = ($DefaultValue -join ", ")
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Double"
      {
        $CodeValue = "$($DefaultValue)"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Single"
      {
        $CodeValue = "$($DefaultValue)"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Decimal"
      {
        $CodeValue = "$($DefaultValue)"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.DateTime"
      {
        $CodeValue = "[DateTime]::Parse(`"$($DefaultValue))`""
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Object"
      {
        #region System.Object
        if (($Control.Name -eq "Form") -and ($Property.Name -eq "Tag"))
        {
          $CodeValue = "(-not `$$($MyScriptName)Config.Production)"
        }
        else
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)"
        }
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        #endregion System.Object
        Break
      }
      "System.Drawing.Color"
      {
        #region System.Drawing.Color
        Switch ($Control.Name)
        {
          { $PSItem -in @("Form", "ContextMenuStrip", "MenuStrip", "StatusStrip", "ToolStrip") }
          {
            if ($Property.Name -in @("ForeColor", "BackColor"))
            {
              Switch ($Property.Name)
              {
                "ForeColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.Fore"; Break }
                "BackColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.Back"; Break }
              }
              [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
            }
            else
            {
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [System.Drawing.Color]::$($DefaultValue.ToString())")
            }
            Break
          }
          { $PSItem -in @("TextBox", "ComboBox", "CheckedListBox", "ListBox", "ListView", "TreeView", "RichTextBox", "DateTimePicker", "DataGridView", "ToolStripComboBox", "ToolStripTextBox") }
          {
            if ($Property.Name -in @("ForeColor", "BackColor"))
            {
              Switch ($Property.Name)
              {
                "ForeColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.TextFore"; Break }
                "BackColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.TextBack"; Break }
              }
              [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
            }
            else
            {
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [System.Drawing.Color]::$($DefaultValue.ToString())")
            }
            Break
          }
          "GroupBox"
          {
            if ($Property.Name -in @("ForeColor", "BackColor"))
            {
              Switch ($Property.Name)
              {
                "ForeColor"
                {
                  $CodeValue = "`$$($MyScriptName)Config.Colors.GroupFore"
                  [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
                  Break
                }
                "BackColor"
                {
                  $CodeValue = "`$$($MyScriptName)Config.Colors.Back"
                  [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
                  Break
                }
              }
            }
            else
            {
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [System.Drawing.Color]::$($DefaultValue.ToString())")
            }
            Break
          }
          "Button"
          {
            if ($Property.Name -in @("ForeColor", "BackColor"))
            {
              Switch ($Property.Name)
              {
                "ForeColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.ButtonFore"; Break }
                "BackColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.ButtonBack"; Break }
              }
              [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
            }
            else
            {
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [System.Drawing.Color]::$($DefaultValue.ToString())")
            }
            Break
          }
          { $PSItem -in @("Label", "CheckBox", "RadioButton") }
          {
            Switch ($Property.Name)
            {
              "ForeColor"
              {
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Colors.Fore")
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Colors.TitleFore")
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Colors.LabelFore")
                Break
              }
              "BackColor"
              {
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Colors.Back")
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Colors.TitleBack")
                Break
              }
              Default
              {
                [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [System.Drawing.Color]::$($DefaultValue.ToString())")
                Break
              }
            }
          }
          Default
          {
            if ($Property.Name -in @("ForeColor", "BackColor"))
            {
              Switch ($Property.Name)
              {
                "ForeColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.Fore"; Break }
                "BackColor" { $CodeValue = "`$$($MyScriptName)Config.Colors.Back"; Break }
              }
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
            }
            else
            {
              [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = [$($Property.PropertyType.FullName)]::$($DefaultValue.ToString())")
            }
            Break
          }
          
        }
        #endregion System.Drawing.Color
        Break
      }
      "System.Drawing.Font"
      {
        #region System.Drawing.Font
        Switch ($Control.Name)
        {
          { $PSItem -in @("Form", "ContextMenuStrip", "MenuStrip", "StatusStrip", "ToolStrip") }
          {
            [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Regular")
            Break
          }
          "Label"
          {
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Regular")
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Bold")
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Title")
            Break
          }
          { $PSItem -in @("GroupBox", "Button", "ListView", "TabControl", "CheckBox", "RadioButton") }
          {
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Bold")
            Break
          }
          Default
          {
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Config.Font.Regular")
            Break
          }
        }
        #endregion System.Drawing.Font
        Break
      }
      "System.Drawing.Icon"
      {
        #region System.Drawing.Icon
        if ($Control.Name -eq "Form")
        {
          $CodeValue = "New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$$($MyScriptName)FormIcon)))))"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = `$$($MyScriptName)Form.Icon")
          $CodeValue = "New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$IconString)))))"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.Drawing.Icon
        Break
      }
      "System.Drawing.Image"
      {
        $CodeValue = "[System.Drawing.Image]::FromStream((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$ImageString)))))"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Drawing.Point"
      {
        #region System.Drawing.Point
        if (($Control.Name -ne "Form") -and ($Property.Name -eq "Location"))
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)(`$$($MyScriptName)Config.FormSpacer, `$$($MyScriptName)Config.FormSpacer)"
          if (($Control.Name -in @("ContextMenuStrip", "MenuStrip", "StatusStrip", "ToolStrip")) -or (($Control.Name -in @("Panel", "SplitContainer")) -and ($MyControlName -eq "Main")))
          {
            [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
          }
          else
          {
            [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
          }
        }
        else
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)($($DefaultValue.X), $($DefaultValue.Y))"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.Drawing.Point
        Break
      }
      "System.Drawing.Rectangle"
      {
        $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)($($DefaultValue.X), $($DefaultValue.Y), $($DefaultValue.Width), $($DefaultValue.Height))"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Windows.Forms.AnchorStyles"
      {
        $CodeValue = "[$($Property.PropertyType.FullName)](`"$($DefaultValue.ToString())`")"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Windows.Forms.Cursor"
      {
        $CodeValue = "[$($Property.PropertyType.FullName)s]::Default"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      "System.Windows.Forms.ImageList"
      {
        #region System.Windows.Forms.ImageList
        $CodeValue = "`$$($MyScriptName)ImageList"
        if ($Control.Name -in @("ContextMenuStrip", "MenuStrip", "ToolStrip", "StatusStrip"))
        {
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.Windows.Forms.ImageList
        Break
      }
      "System.Windows.Forms.Padding"
      {
        $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)($($DefaultValue.Left), $($DefaultValue.Top), $($DefaultValue.Right), $($DefaultValue.Bottom))"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
      { $PSItem -in @("System.Drawing.Size", "System.Drawing.SizeF") }
      {
        #region @("System.Drawing.Size", "System.Drawing.SizeF")
        if (($Control.Name -eq "Form") -and ($Property.Name -eq "MinimumSize"))
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)((`$$($MyScriptName)Config.Font.Width * `$$($MyScriptName)Config.FormMinWidth), (`$$($MyScriptName)Config.Font.Height * `$$($MyScriptName)Config.FormMinHeight))"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)($($DefaultValue.Width), $($DefaultValue.Height))"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion @("System.Drawing.Size", "System.Drawing.SizeF")
        Break
      }
      "System.Collections.IComparer"
      {
        #region System.Collections.IComparer
        if ($Property.Name -eq "ListViewItemSorter")
        {
          $CodeValue = "New-Object -TypeName MyCustom.ListViewSort"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)s"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion System.Collections.IComparer
        Break
      }
      { $Property.PropertyType.BaseType.Name -eq "Enum" }
      {
        #region All Enumeration
        if (($Property.Name -eq "Dock") -and ($Control.Name -in @("Panel", "SplitContainer")) -and ($MyControlName -eq "Main"))
        {
          $CodeValue = "[$($Property.PropertyType.FullName)]::Fill"
          [Void]$StringBuilder.AppendLine("$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        else
        {
          $CodeValue = "[$($Property.PropertyType.FullName)]::$($DefaultValue.ToString())"
          [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        }
        #endregion All Enumeration
        Break
      }
      Default
      {
        $CodeValue = "New-Object -TypeName $($Property.PropertyType.FullName)"
        [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name) = $($CodeValue)")
        Break
      }
    }
  }
  
  Try
  {
    $DefaultControl.Dispose()
  }
  Catch { }
  $DefaultControl = $Null
  #endregion ******** Add Properties ********
  
  [Void]$StringBuilder.AppendLine("#endregion $($TempControl) = New-Object -TypeName $($Control.FullName)")
  [Void]$StringBuilder.AppendLine("")
  
  #region ******** Add Control Items ********
  $CodeValue = $Null
  ForEach ($Property in @(Get-MyFormControlItems -Control $Control))
  {
    ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("Add"))
    {
      $CodeValue = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
      [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name).Add($($CodeValue))")
    }
    ForEach ($Add in $Property.PropertyType.GetDeclaredMethods("AddRange"))
    {
      $CodeValue = @($Add.GetParameters() | ForEach-Object -Process { "[$($PSItem.ParameterType.FullName)]`$$($PSItem.Name.SubString(0, 1).ToUpper())$($PSItem.Name.SubString(1))" }) -join ", "
      [Void]$StringBuilder.AppendLine("#$($TempControl).$($Property.Name).AddRange($($CodeValue))")
    }
  }
  if (-not [String]::IsNullOrEmpty($CodeValue))
  {
    [Void]$StringBuilder.AppendLine("#$($TempControl).BeginUpdate()")
    [Void]$StringBuilder.AppendLine("#$($TempControl).EndUpdate()")
    [Void]$StringBuilder.AppendLine("")
  }
  #endregion ******** Add Control Items ********
  
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScriptControl"
}
#endregion function Build-MyScriptControl

#region function Build-MyScript
function Build-MyScript ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Build-MyScript -Value "String"
    .NOTES
      Original Function By 
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$MyScriptName,
    [String]$MyControlName,
    [Object]$Control,
    [Object[]]$ControlEvent
  )
  Write-Verbose -Message "Enter Function Build-MyScript"
  
  $StringBuilder = New-Object -TypeName System.Text.StringBuilder
  
  if ($Control.Name -eq "Form")
  {
    $TempName = "$($MyScriptName)"
    $TempControl = "`$$($MyScriptName)$($Control.Name)"
  }
  else
  {
    $TempName = "$($MyScriptName)$($MyControlName)"
    $TempControl = "`$$($MyScriptName)$($MyControlName)$($Control.Name)"
  }
  
  #region ******** My Code ********
  
  #region ******** Form / ListView Header ********
  Switch ($Control.Name)
  {
    "Form"
    {
      [Void]$StringBuilder.Append((Build-MyScriptHeader -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptConfig -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptColors -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptFonts -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptWindowsAPIs -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptFunctions -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptMultiThread -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptJobsThreads -MyScriptName $MyScriptName))
      [Void]$StringBuilder.Append((Build-MyScriptCustom -MyScriptName $MyScriptName))
      
      [Void]$StringBuilder.AppendLine("#region >>>>>>>>>>>>>>>> Begin **** $($MyScriptName) **** Begin <<<<<<<<<<<<<<<<")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#`$Result = [System.Windows.Forms.MessageBox]::Show($($TempControl), `"Message Text`", `$$($MyScriptName)Config.ScriptName, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)FormComponents = New-Object -TypeName System.ComponentModel.Container")
      [Void]$StringBuilder.AppendLine("")
      
      [Void]$StringBuilder.Append((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.OpenFileDialog])))
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.Append((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.SaveFileDialog])))
      [Void]$StringBuilder.AppendLine("")
      
      [Void]$StringBuilder.Append((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.ToolTip])))
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.Append((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.ImageList])))
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)ImageList.Images.Add(`"$($MyScriptName)FormIcon`", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$$($MyScriptName)FormIcon)))))))")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)ImageList.Images.Add(`"ExitIcon`", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$ExitIcon)))))))")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)ImageList.Images.Add(`"HelpIcon`", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String(`$HelpIcon)))))))")
      [Void]$StringBuilder.AppendLine("")
      Break
    }
    "ListView"
    {
      [Void]$StringBuilder.Append((Build-MyScriptListViewSort))
      Break
    }
  }
  #endregion ******** Form / ListView Header ********
  
  if (($Control.Name -eq "Form") -or (-not ($PSBoundParameters.ContainsKey("MyControlName"))))
  {
    [Void]$StringBuilder.Append((Build-MyScriptControl -MyScriptName $MyScriptName -Control $Control))
    if ($PSBoundParameters.ContainsKey("ControlEvent"))
    {
      [Void]$StringBuilder.Append((Build-MyScriptEvent -MyScriptName $MyScriptName -Control $Control -ControlEvent $ControlEvent))
    }
  }
  else
  {
    [Void]$StringBuilder.Append((Build-MyScriptControl -MyScriptName $MyScriptName -MyControlName $MyControlName -Control $Control))
    if ($PSBoundParameters.ContainsKey("ControlEvent"))
    {
      [Void]$StringBuilder.Append((Build-MyScriptEvent -MyScriptName $MyScriptName -MyControlName $MyControlName -Control $Control -ControlEvent $ControlEvent))
    }
  }
  
  #region ******* Form / Code Footer ********
  Switch ($Control.Name)
  {
    "Form"
    {
      #[Void]$StringBuilder.Append((Build-MyScriptEvent -MyScriptName $MyScriptName -MyControlName $MyControlName -Control $Control -ControlEvent $ControlEvent))
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#region ******** Controls for $($TempName) $($Control.Name) ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.Timer]) -ControlEvent (([System.Windows.Forms.Timer]).GetEvent("Tick"))))
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -Control ([System.Windows.Forms.NotifyIcon]) -ControlEvent (([System.Windows.Forms.NotifyIcon]).GetEvent("MouseClick"))))
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -MyControlName "Main" -Control ([System.Windows.Forms.Panel])))
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -MyControlName "Main" -Control ([System.Windows.Forms.SplitContainer])))
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -MyControlName "Top" -Control ([System.Windows.Forms.MenuStrip])))
      [Void]$StringBuilder.AppendLine((Build-MyScript -MyScriptName $MyScriptName -MyControlName "Btm" -Control ([System.Windows.Forms.StatusStrip])))
      [Void]$StringBuilder.AppendLine("#$($TempControl).ClientSize = New-Object -TypeName System.Drawing.Size(($($TempControl).Controls[$($TempControl).Controls.Count - 1]).Right + `$$($MyScriptName)Config.FormSpacer, ($($TempControl).Controls[$($TempControl).Controls.Count - 1]).Bottom + `$$($MyScriptName)Config.FormSpacer))")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** Controls for $($TempName) $($Control.Name) ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ================ End **** $($MyScriptName) **** End ================")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("[System.Windows.Forms.Application]::Run($("$($TempControl)"))")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)OpenFileDialog.Dispose()")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)SaveFileDialog.Dispose()")
      [Void]$StringBuilder.AppendLine("`$$($MyScriptName)FormComponents.Dispose()")
      [Void]$StringBuilder.AppendLine("$($TempControl).Dispose()")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("if (`$$($MyScriptName)Config.Production)")
      [Void]$StringBuilder.AppendLine("{")
      [Void]$StringBuilder.AppendLine("  [System.Environment]::Exit(0)")
      [Void]$StringBuilder.AppendLine("}")
      Break
    }
    "SplitContainer"
    {
      [Void]$StringBuilder.AppendLine("#region ******** $($TempControl) Panel1 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** $($TempControl) Panel1 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#region ******** $($TempControl) Panel2 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** $($TempControl) Panel2 Controls ********")
      [Void]$StringBuilder.AppendLine("")
      Break
    }
    "TabControl"
    {
      [Void]$StringBuilder.Append((Build-MyScriptEvent -MyScriptName $MyScriptName -MyControlName $MyControlName -Control ([System.Windows.Forms.TabPage]) -ControlEvent (([System.Windows.Forms.TabPage]).GetEvent("Enter"))))
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#region ******** $($TempControl) Tab Pages ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** $($TempControl) Tab Pages ********")
      [Void]$StringBuilder.AppendLine("")
      Break
    }
    "tooltip"
    {
      [Void]$StringBuilder.AppendLine("#$($TempControl).SetToolTip(`$FormControl, `"Form Control Help`")")
      break
    }
    "Label"
    {
      [Void]$StringBuilder.AppendLine("#$($TempControl).Size = New-Object -TypeName System.Drawing.Size(((`$$($MyScriptName)Config.Font.Width) * (`$$($MyScriptName)Config.FontTitle) * ($($TempControl).Text.Length + 4)), $($TempControl).PreferredHeight)")
      [Void]$StringBuilder.AppendLine("#$($TempControl).Size = [System.Windows.Forms.TextRenderer]::MeasureText($($TempControl).Text, $($TempControl).Font, $($TempControl).Size, ([System.Windows.Forms.TextFormatFlags](`"Top`", `"Left`", `"WordBreak`")))")
      [Void]$StringBuilder.AppendLine("#$($TempControl).Size = $($TempControl).PreferredSize")
      break
    }
    "ListView"
    {
      [Void]$StringBuilder.AppendLine("#ForEach (`$Item in `$Objects)")
      [Void]$StringBuilder.AppendLine("#{")
      [Void]$StringBuilder.AppendLine("#  ($($TempControl).Items.Add((`$ListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem(`$Item.Text)))).SubItems.AddRange(@(`"`$(`$Item.Value)`", `"`$(`$Item.Value)`", `"`$(`$Item.Value)`"))")
      [Void]$StringBuilder.AppendLine("#  #($($TempControl).Items.Add((`$ListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem(`$Item.Text, `$Group)))).SubItems.AddRange(@(`"`$(`$Item.Value)`", `"`$(`$Item.Value)`", `"`$(`$Item.Value)`"))")
      [Void]$StringBuilder.AppendLine("#  `$ListViewItem.Font = `$$($MyScriptName)Config.Font.Regular")
      [Void]$StringBuilder.AppendLine("#}")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#`$Objects | ForEach-Object -Process { ($($TempControl).Items.Add((New-Object -TypeName System.Windows.Forms.ListViewItem(`$PSItem.Text)))).SubItems.AddRange(@(`"`$(`$PSItem.Value)`", `"`$(`$PSItem.Value)`", `"`$(`$PSItem.Value)`")) }")
      [Void]$StringBuilder.AppendLine("#`$Objects | ForEach-Object -Process { ($($TempControl).Items.Add((New-Object -TypeName System.Windows.Forms.ListViewItem(`$PSItem.Text, `$Group)))).SubItems.AddRange(@(`"`$(`$PSItem.Value)`", `"`$(`$PSItem.Value)`", `"`$(`$PSItem.Value)`")) }")
      [Void]$StringBuilder.AppendLine("")
      break
    }
    { $PSItem -in @("ContextMenuStrip", "MenuStrip", "ToolStrip") }
    {
      [Void]$StringBuilder.AppendLine("`$$($TempName)ToolStripItem = New-MenuItem -Menu $($TempControl) -Text `"&Help`" -Name `"Help`" -Tag `"Help`" -DisplayStyle `"ImageAndText`" -ImageKey `"HelpIcon`" -PassThru")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.Append((Build-MyScriptEvent -MyScriptName $MyScriptName -MyControlName $MyControlName -Control ([System.Windows.Forms.ToolStripItem]) -ControlEvent (([System.Windows.Forms.ToolStripItem]).GetEvent("Click"))))
      [Void]$StringBuilder.AppendLine("(New-MenuItem -Menu $($TempControl) -Text `"E&xit`" -Name `"Exit`" -Tag `"Exit`" -DisplayStyle `"ImageAndText`" -ImageKey `"ExitIcon`" -PassThru).add_Click({Start-$($TempName)ToolStripItemClick -Sender `$This -EventArg `$PSItem})")
      Break
    }
    "StatusStrip"
    {
      [Void]$StringBuilder.AppendLine("New-MenuLabel -Menu $($TempControl) -Text `"Status`" -Name `"Status`" -Tag `"Status`"")
    }
    { $PSItem -in @("ToolStripPanel", "TabPage") }
    {
      [Void]$StringBuilder.AppendLine("#region ******** $($TempControl) Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** $($TempControl) Controls ********")
      [Void]$StringBuilder.AppendLine("")
      Break
    }
    { $PSItem -in @("GroupBox", "Panel") }
    {
      [Void]$StringBuilder.AppendLine("#region ******** $($TempControl) Controls ********")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#$($TempControl).ClientSize = New-Object -TypeName System.Drawing.Size((`$($($TempControl).Controls[$($TempControl).Controls.Count - 1]).Right + `$$($MyScriptName)Config.FormSpacer), (`$($($TempControl).Controls[$($TempControl).Controls.Count - 1]).Bottom + `$$($MyScriptName)Config.FormSpacer))")
      [Void]$StringBuilder.AppendLine("")
      [Void]$StringBuilder.AppendLine("#endregion ******** $($TempControl) Controls ********")
      [Void]$StringBuilder.AppendLine("")
      Break
    }
  }
  #endregion ******* Form / Code Footer ********
  
  #endregion ******** My Code ********
  
  $StringBuilder.ToString()
  $StringBuilder = $Null
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Build-MyScript"
}
#endregion function Build-MyScript

#endregion ================ Generate Script Code - MyFCG Custom Code ================

# Add Default Events for Controls
#[Void]$MyFCGConfig.DefaultEvents.Add("ControlName", @("EventName", "EventName"))
[Void]$MyFCGConfig.DefaultEvents.Add("Button", @("Click"))
[Void]$MyFCGConfig.DefaultEvents.Add("CheckBox", @("CheckedChanged"))
[Void]$MyFCGConfig.DefaultEvents.Add("CheckedListBox", @("ItemCheck"))
[Void]$MyFCGConfig.DefaultEvents.Add("ComboBox", @("SelectedIndexChanged"))
[Void]$MyFCGConfig.DefaultEvents.Add("Form", @("Closing", "KeyDown", "Load", "Move", "Resize", "Shown"))
[Void]$MyFCGConfig.DefaultEvents.Add("ListBox", @("SelectedIndexChanged"))
[Void]$MyFCGConfig.DefaultEvents.Add("ListView", @("ColumnClick"))
[Void]$MyFCGConfig.DefaultEvents.Add("NotifyIcon", @("MouseClick"))
[Void]$MyFCGConfig.DefaultEvents.Add("RadioButton", @("CheckedChanged"))
[Void]$MyFCGConfig.DefaultEvents.Add("Timer", @("Tick"))
[Void]$MyFCGConfig.DefaultEvents.Add("TreeView", @("AfterSelect", "BeforeExpand"))

#region >>>>>>>>>>>>>>>> Begin **** MyFCG **** Begin <<<<<<<<<<<<<<<<

$MyFCGFormComponents = New-Object -TypeName System.ComponentModel.Container


# ************************************************
# MyFCG ImageList
# ************************************************
#region $MyFCGImageList = New-Object -TypeName System.Windows.Forms.ImageList
$MyFCGImageList = New-Object -TypeName System.Windows.Forms.ImageList($MyFCGFormComponents)
$MyFCGImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit
$MyFCGImageList.ImageSize = New-Object -TypeName System.Drawing.Size(16, 16)
#endregion $MyFCGImageList = New-Object -TypeName System.Windows.Forms.ImageList


$MyFCGImageList.Images.Add("MyFCGFormIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($MyFCGFormIcon)))))))
$MyFCGImageList.Images.Add("ExitIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($ExitIcon)))))))
$MyFCGImageList.Images.Add("HelpIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($HelpIcon)))))))
$MyFCGImageList.Images.Add("GenerateIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($GenerateIcon)))))))
$MyFCGImageList.Images.Add("ControlIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($ControlIcon)))))))
$MyFCGImageList.Images.Add("EventIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList ( ,([System.Convert]::FromBase64String($EventIcon)))))))
$MyFCGImageList.Images.Add("LibraryIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList ( ,([System.Convert]::FromBase64String($LibraryIcon)))))))
$MyFCGImageList.Images.Add("ExtractIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($ExtractIcon)))))))
$MyFCGImageList.Images.Add("ImageIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($ImageIcon)))))))
$MyFCGImageList.Images.Add("DataIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($DataIcon)))))))
$MyFCGImageList.Images.Add("DialogIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($DialogIcon)))))))
$MyFCGImageList.Images.Add("SourceIcon", (New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($SourceIcon)))))))


#region $MyFCGOpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$MyFCGOpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
#endregion $MyFCGOpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog


# ************************************************
# MyFCG Form
# ************************************************
#region $MyFCGForm = New-Object -TypeName System.Windows.Forms.Form
$MyFCGForm = New-Object -TypeName System.Windows.Forms.Form
$MyFCGForm.BackColor = $MyFCGConfig.Colors.Back
$MyFCGForm.Font = $MyFCGConfig.Font.Regular
$MyFCGForm.ForeColor = $MyFCGConfig.Colors.Fore
$MyFCGForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$MyFCGForm.Icon = New-Object -TypeName System.Drawing.Icon((New-Object -TypeName System.IO.MemoryStream -ArgumentList (,([System.Convert]::FromBase64String($MyFCGFormIcon)))))
$MyFCGForm.KeyPreview = $True
$MyFCGForm.MinimumSize = New-Object -TypeName System.Drawing.Size(($MyFCGConfig.Font.Width * $MyFCGConfig.FormMinWidth), ($MyFCGConfig.Font.Height * $MyFCGConfig.FormMinHeight))
$MyFCGForm.Name = "MyFCGForm"
$MyFCGForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MyFCGForm.TabStop = $True
$MyFCGForm.Text = "$($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
#endregion $MyFCGForm = New-Object -TypeName System.Windows.Forms.Form

#region ******** Function Start-MyFCGFormClosing ********
function Start-MyFCGFormClosing
{
  <#
    .SYNOPSIS
      Closing Event for the MyFCG Form Control
    .DESCRIPTION
      Closing Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Closing Event
    .PARAMETER EventArg
       The Event Arguments for the Form Closing Event
    .EXAMPLE
       Start-MyFCGFormClosing -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Closing Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  if ($MyFCGConfig.Production)
  {
    # Show Console Window
    $Script:VerbosePreference = "Continue"
    $Script:DebugPreference = "Continue"
    
    [Void][Console.Window]::Show()
    [System.Console]::Title = "Closing: $($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
    $MyFCGForm.Tag = $True
  }
  
  Write-Verbose -Message "Exit Closing Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormClosing ********
$MyFCGForm.add_Closing({ Start-MyFCGFormClosing -Sender $This -EventArg $PSItem })

#region ******** Function Start-MyFCGFormKeyDown ********
function Start-MyFCGFormKeyDown
{
  <#
    .SYNOPSIS
      KeyDown Event for the MyFCG Form Control
    .DESCRIPTION
      KeyDown Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-MyFCGFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyDown Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  if ($EventArg.Control -and $EventArg.Alt -and $EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F10)
  {
    if ($MyFCGForm.Tag)
    {
      # Hide Console Window
      $Script:VerbosePreference = "SilentlyContinue"
      $Script:DebugPreference = "SilentlyContinue"
      [System.Console]::Title = "RUNNING: $($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
      [Void][Console.Window]::Hide()
      $MyFCGForm.Tag = $False
    }
    else
    {
      # Show Console Window
      $Script:VerbosePreference = "Continue"
      $Script:DebugPreference = "Continue"
      [Void][Console.Window]::Show()
      [System.Console]::Title = "DEBUG: $($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
      $MyFCGForm.Tag = $True
    }
    $MyFCGForm.Activate()
    $MyFCGForm.Select()
  }
  elseif ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F1)
  {
    $MyFCGToolTip.Active = (-not $MyFCGToolTip.Active)
  }
  
  Write-Verbose -Message "Exit KeyDown Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormKeyDown ********
$MyFCGForm.add_KeyDown({ Start-MyFCGFormKeyDown -Sender $This -EventArg $PSItem })

#region ******** Function Start-MyFCGFormLoad ********
function Start-MyFCGFormLoad
{
  <#
    .SYNOPSIS
      Load Event for the MyFCG Form Control
    .DESCRIPTION
      Load Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Load Event
    .PARAMETER EventArg
       The Event Arguments for the Form Load Event
    .EXAMPLE
       Start-MyFCGFormLoad -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Load Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  $Screen = ([System.Windows.Forms.Screen]::FromControl($Sender)).WorkingArea
  $Sender.Left = [Math]::Floor(($Screen.Width - $Sender.Width) / 2)
  $Sender.Top = [Math]::Floor(($Screen.Height - $Sender.Height) / 2)
  
  if ($MyFCGConfig.Production)
  {
    # Enable $MyFCGTimer
    $MyFCGTimer.Enabled = ($MyFCGConfig.AutoExitMax -gt 0)
    
    # Hide Console Window
    $Script:VerbosePreference = "SilentlyContinue"
    $Script:DebugPreference = "SilentlyContinue"
    
    [System.Console]::Title = "RUNNING: $($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
    [Void][Console.Window]::Hide()
    $MyFCGForm.Tag = $False
  }
  else
  {
    [Void][Console.Window]::Show()
    [System.Console]::Title = "DEBUG: $($MyFCGConfig.ScriptName) - $($MyFCGConfig.ScriptVersion)"
    $MyFCGForm.Tag = $True
  }
  
  Write-Verbose -Message "Exit Load Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormLoad ********
$MyFCGForm.add_Load({ Start-MyFCGFormLoad -Sender $This -EventArg $PSItem })

#region ******** Function Start-MyFCGFormMove ********
function Start-MyFCGFormMove
{
  <#
    .SYNOPSIS
      Move Event for the MyFCG Form Control
    .DESCRIPTION
      Move Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Move Event
    .PARAMETER EventArg
       The Event Arguments for the Form Move Event
    .EXAMPLE
       Start-MyFCGFormMove -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Move Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  Write-Verbose -Message "Exit Move Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormMove ********
$MyFCGForm.add_Move({ Start-MyFCGFormMove -Sender $This -EventArg $PSItem })

#region ******** Function Start-MyFCGFormResize ********
function Start-MyFCGFormResize
{
  <#
    .SYNOPSIS
      Resize Event for the MyFCG Form Control
    .DESCRIPTION
      Resize Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Resize Event
    .PARAMETER EventArg
       The Event Arguments for the Form Resize Event
    .EXAMPLE
       Start-MyFCGFormResize -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Resize Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  Write-Verbose -Message "Exit Resize Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormResize ********
$MyFCGForm.add_Resize({ Start-MyFCGFormResize -Sender $This -EventArg $PSItem })

#region ******** Function Start-MyFCGFormShown ********
function Start-MyFCGFormShown
{
  <#
    .SYNOPSIS
      Shown Event for the MyFCG Form Control
    .DESCRIPTION
      Shown Event for the MyFCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Shown Event
    .PARAMETER EventArg
       The Event Arguments for the Form Shown Event
    .EXAMPLE
       Start-MyFCGFormShown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Shown Event for `$MyFCGForm"
  
  $MyFCGConfig.AutoExit = 0
  
  $Sender.Refresh()
  
  $MyFCGScriptNameTextBox.Text = $MyFCGConfig.DefScriptName
  $MyFCGScriptNameTextBox.Select()
  
  $MyFCGControlListListBox.Items.AddRange(@(Get-MyFormControls))
  $MyFCGBtmStatusStrip.Items["Status"].Text = "Found $($MyFCGControlListListBox.Items.Count) .Net Form Controls..."
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Shown Event for `$MyFCGForm"
}
#endregion ******** Function Start-MyFCGFormShown ********
$MyFCGForm.add_Shown({ Start-MyFCGFormShown -Sender $This -EventArg $PSItem })


#region ******** Controls for MyFCG Form ********

#region $MyFCGTimer = New-Object -TypeName System.Windows.Forms.Timer
$MyFCGTimer = New-Object -TypeName System.Windows.Forms.Timer($MyFCGFormComponents)
$MyFCGTimer.Interval = $MyFCGConfig.AutoExitTic
#endregion $MyFCGTimer = New-Object -TypeName System.Windows.Forms.Timer

#region ******** Function Start-MyFCGTimerTick ********
function Start-MyFCGTimerTick
{
  <#
    .SYNOPSIS
      Tick Event for the MyFCG Timer Control
    .DESCRIPTION
      Tick Event for the MyFCG Timer Control
    .PARAMETER Sender
       The Timer Control that fired the Tick Event
    .PARAMETER EventArg
       The Event Arguments for the Timer Tick Event
    .EXAMPLE
       Start-MyFCGTimerTick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Timer]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Tick Event for `$MyFCGTimer"
  
  $MyFCGConfig.AutoExit += 1
  Write-Verbose -Message "Auto Exit in $($MyFCGConfig.AutoExitMax - $MyFCGConfig.AutoExit) Minutes"
  if ($MyFCGConfig.AutoExit -ge $MyFCGConfig.AutoExitMax)
  {
    $MyFCGForm.Close()
  }
  ElseIf (($MyFCGConfig.AutoExitMax - $MyFCGConfig.AutoExit) -le 5)
  {
    $MyFCGBtmStatusStrip.Items["Status"].Text = "Auto Exit in $($MyFCGConfig.AutoExitMax - $MyFCGConfig.AutoExit) Minutes"
  }
  
  Write-Verbose -Message "Exit Tick Event for `$MyFCGTimer"
}
#endregion ******** Function Start-MyFCGTimerTick ********
$MyFCGTimer.add_Tick({ Start-MyFCGTimerTick -Sender $This -EventArg $PSItem })

# ************************************************
# MyFCGMain SplitContainer
# ************************************************
#region $MyFCGMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer
$MyFCGMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer
$MyFCGForm.Controls.Add($MyFCGMainSplitContainer)
$MyFCGMainSplitContainer.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$MyFCGMainSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$MyFCGMainSplitContainer.FixedPanel = [System.Windows.Forms.FixedPanel]::Panel1
$MyFCGMainSplitContainer.Name = "MyFCGMainSplitContainer"
$MyFCGMainSplitContainer.Panel1MinSize = ($MyFCGConfig.Font.Width * $MyFCGConfig.InfoMinWidth)
$MyFCGMainSplitContainer.SplitterDistance = $MyFCGMainSplitContainer.Panel1MinSize
$MyFCGMainSplitContainer.SplitterIncrement = $MyFCGConfig.FormSpacer
$MyFCGMainSplitContainer.SplitterWidth = ($MyFCGConfig.FormSpacer * 2)
$MyFCGMainSplitContainer.TabStop = $False
$MyFCGMainSplitContainer.Text = "MyFCGMainSplitContainer"
#endregion $MyFCGMainSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer

#region ******** Function Start-MyFCGMainSplitContainerSplitterMoved ********
function Start-MyFCGMainSplitContainerSplitterMoved
{
  <#
    .SYNOPSIS
      SplitterMoved Event for the MyFCGMain SplitContainer Control
    .DESCRIPTION
      SplitterMoved Event for the MyFCGMain SplitContainer Control
    .PARAMETER Sender
       The SplitContainer Control that fired the SplitterMoved Event
    .PARAMETER EventArg
       The Event Arguments for the SplitContainer SplitterMoved Event
    .EXAMPLE
       Start-MyFCGMainSplitContainerSplitterMoved -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By MyUserName
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.SplitContainer]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter SplitterMoved Event for `$MyFCGMainSplitContainer"
  
  $MyFCGConfig.AutoExit = 0
  
  Write-Verbose -Message "Exit SplitterMoved Event for `$MyFCGMainSplitContainer"
}
#endregion ******** Function Start-MyFCGMainSplitContainerSplitterMoved ********
$MyFCGMainSplitContainer.add_SplitterMoved({ Start-MyFCGMainSplitContainerSplitterMoved -Sender $This -EventArg $PSItem })


#region ******** $MyFCGMainSplitContainer Panel1 Controls ********


# ************************************************
# MyFCGControl GroupBox
# ************************************************
#region $MyFCGControlGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGControlGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGMainSplitContainer.Panel1.Controls.Add($MyFCGControlGroupBox)
$MyFCGControlGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$MyFCGControlGroupBox.ForeColor = $MyFCGConfig.Colors.GroupFore
$MyFCGControlGroupBox.Name = "MyFCGControlGroupBox"
$MyFCGControlGroupBox.TabStop = $False
$MyFCGControlGroupBox.Text = "Control Information"
#endregion $MyFCGControlGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox

#region ******** $MyFCGControlGroupBox Controls ********

#region $MyFCGControlNameLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlNameLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlGroupBox.Controls.Add($MyFCGControlNameLabel)
$MyFCGControlNameLabel.BackColor = $MyFCGConfig.Colors.TitleBack
$MyFCGControlNameLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MyFCGControlNameLabel.Dock = [System.Windows.Forms.DockStyle]::Top
$MyFCGControlNameLabel.Font = $MyFCGConfig.Font.Bold
$MyFCGControlNameLabel.ForeColor = $MyFCGConfig.Colors.TitleFore
$MyFCGControlNameLabel.Name = "MyFCGControlNameLabel"
$MyFCGControlNameLabel.TabStop = $False
$MyFCGControlNameLabel.Text = "Control Name"
$MyFCGControlNameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion $MyFCGControlNameLabel = New-Object -TypeName System.Windows.Forms.Label

$MyFCGControlNameLabel.Height = $MyFCGControlNameLabel.PreferredSize.Height

#region $MyFCGControlNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGControlNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGControlGroupBox.Controls.Add($MyFCGControlNameTextBox)
$MyFCGControlNameTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
$MyFCGControlNameTextBox.BackColor = $MyFCGConfig.Colors.TextBack
$MyFCGControlNameTextBox.ForeColor = $MyFCGConfig.Colors.TextFore
$MyFCGControlNameTextBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGControlNameLabel.Left, ($MyFCGControlNameLabel.Bottom + $MyFCGConfig.FormSpacer))
$MyFCGControlNameTextBox.Name = "MyFCGControlNameTextBox"
$MyFCGControlNameTextBox.TabIndex = 1
$MyFCGControlNameTextBox.TabStop = $True
$MyFCGControlNameTextBox.Text = ""
$MyFCGControlNameTextBox.Width = $MyFCGControlNameLabel.Width
#endregion $MyFCGControlNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox

#region $MyFCGControlListLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlListLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlGroupBox.Controls.Add($MyFCGControlListLabel)
$MyFCGControlListLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
$MyFCGControlListLabel.BackColor = $MyFCGConfig.Colors.TitleBack
$MyFCGControlListLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MyFCGControlListLabel.Font = $MyFCGConfig.Font.Bold
$MyFCGControlListLabel.ForeColor = $MyFCGConfig.Colors.TitleFore
$MyFCGControlListLabel.Location = New-Object -TypeName System.Drawing.Point($MyFCGControlNameLabel.Left, ($MyFCGControlNameTextBox.Bottom + $MyFCGConfig.FormSpacer))
$MyFCGControlListLabel.Name = "MyFCGControlListLabel"
$MyFCGControlListLabel.Size = $MyFCGControlNameLabel.Size
$MyFCGControlListLabel.TabStop = $False
$MyFCGControlListLabel.Text = "Control List"
$MyFCGControlListLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion $MyFCGControlListLabel = New-Object -TypeName System.Windows.Forms.Label

#region $MyFCGControlEventCheckedListBox = New-Object -TypeName System.Windows.Forms.CheckedListBox
$MyFCGControlEventCheckedListBox = New-Object -TypeName System.Windows.Forms.CheckedListBox
$MyFCGControlGroupBox.Controls.Add($MyFCGControlEventCheckedListBox)
$MyFCGControlEventCheckedListBox.Anchor = [System.Windows.Forms.AnchorStyles]("Bottom, Left, Right")
$MyFCGControlEventCheckedListBox.BackColor = $MyFCGConfig.Colors.TextBack
$MyFCGControlEventCheckedListBox.CheckOnClick = $True
$MyFCGControlEventCheckedListBox.DisplayMember = "Name"
$MyFCGControlEventCheckedListBox.ForeColor = $MyFCGConfig.Colors.TextFore
$MyFCGControlEventCheckedListBox.Height = ($MyFCGConfig.Font.Height * $MyFCGConfig.EventHeight)
$MyFCGControlEventCheckedListBox.IntegralHeight = $False
$MyFCGControlEventCheckedListBox.ItemHeight = $MyFCGConfig.Font.Height
$MyFCGControlEventCheckedListBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGControlNameLabel.Left, ($MyFCGControlGroupBox.ClientSize.Height - (($MyFCGConfig.FormSpacer * 2) + $MyFCGControlEventCheckedListBox.Height)))
$MyFCGControlEventCheckedListBox.Name = "MyFCGControlEventCheckedListBox"
$MyFCGControlEventCheckedListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::One
$MyFCGControlEventCheckedListBox.Sorted = $True
$MyFCGControlEventCheckedListBox.TabIndex = 3
$MyFCGControlEventCheckedListBox.TabStop = $True
$MyFCGControlEventCheckedListBox.Text = "MyFCGControlEventListBox"
$MyFCGControlEventCheckedListBox.ValueMember = "Name"
$MyFCGControlEventCheckedListBox.Width = $MyFCGControlNameLabel.Width
#endregion $MyFCGControlEventCheckedListBox = New-Object -TypeName System.Windows.Forms.CheckedListBox

#region ******** Function Start-MyFCGControlEventCheckedListBoxItemCheck ********
function Start-MyFCGControlEventCheckedListBoxItemCheck
{
  <#
    .SYNOPSIS
      ItemCheck Event for the MyFCGControlEvent CheckedListBox Control
    .DESCRIPTION
      ItemCheck Event for the MyFCGControlEvent CheckedListBox Control
    .PARAMETER Sender
       The CheckedListBox Control that fired the ItemCheck Event
    .PARAMETER EventArg
       The Event Arguments for the CheckedListBox ItemCheck Event
    .EXAMPLE
       Start-MyFCGControlEventCheckedListBoxItemCheck -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter ItemCheck Event for `$MyFCGControlEventCheckedListBox"
  
  $MyFCGConfig.AutoExit = 0
  
  $Contains = $MyFCGControlEventCheckedListBox.CheckedItems.Contains($Sender.SelectedItem)
  $Count = $MyFCGControlEventCheckedListBox.CheckedItems.Count
  
  $MyFCGTopMenuStrip.Items["Event"].Enabled = ((-not $Contains -and $Count -eq 0) -or (-not ($Contains -and $Count -eq 1)) -or ($Count -gt 1))
  
  Write-Verbose -Message "Exit ItemCheck Event for `$MyFCGControlEventCheckedListBox"
}
#endregion ******** Function Start-MyFCGControlEventCheckedListBoxItemCheck ********
$MyFCGControlEventCheckedListBox.add_ItemCheck({ Start-MyFCGControlEventCheckedListBoxItemCheck -Sender $This -EventArg $PSItem })

#region $MyFCGControlEventLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlEventLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGControlGroupBox.Controls.Add($MyFCGControlEventLabel)
$MyFCGControlEventLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Bottom, Left, Right")
$MyFCGControlEventLabel.BackColor = $MyFCGConfig.Colors.TitleBack
$MyFCGControlEventLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MyFCGControlEventLabel.Font = $MyFCGConfig.Font.Bold
$MyFCGControlEventLabel.ForeColor = $MyFCGConfig.Colors.TitleFore
$MyFCGControlEventLabel.Location = New-Object -TypeName System.Drawing.Point($MyFCGControlNameLabel.Left, ($MyFCGControlEventCheckedListBox.Top - ($MyFCGControlNameLabel.Height + $MyFCGConfig.FormSpacer)))
$MyFCGControlEventLabel.Name = "MyFCGControlEventLabel"
$MyFCGControlEventLabel.Size = $MyFCGControlNameLabel.Size
$MyFCGControlEventLabel.TabStop = $False
$MyFCGControlEventLabel.Text = "Control Events"
$MyFCGControlEventLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion $MyFCGControlEventLabel = New-Object -TypeName System.Windows.Forms.Label

#region $MyFCGControlListListBox = New-Object -TypeName System.Windows.Forms.ListBox
$MyFCGControlListListBox = New-Object -TypeName System.Windows.Forms.ListBox
$MyFCGControlGroupBox.Controls.Add($MyFCGControlListListBox)
$MyFCGControlListListBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Bottom, Left, Right")
$MyFCGControlListListBox.BackColor = $MyFCGConfig.Colors.TextBack
$MyFCGControlListListBox.DisplayMember = "Name"
$MyFCGControlListListBox.ForeColor = $MyFCGConfig.Colors.TextFore
$MyFCGControlListListBox.Height = ($MyFCGControlEventLabel.Top - $MyFCGConfig.FormSpacer) - ($MyFCGControlListLabel.Bottom + $MyFCGConfig.FormSpacer)
$MyFCGControlListListBox.IntegralHeight = $False
$MyFCGControlListListBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGControlNameLabel.Left, ($MyFCGControlListLabel.Bottom + $MyFCGConfig.FormSpacer))
$MyFCGControlListListBox.Name = "MyFCGControlListListBox"
$MyFCGControlListListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::One
$MyFCGControlListListBox.Sorted = $True
$MyFCGControlListListBox.TabIndex = 2
$MyFCGControlListListBox.TabStop = $True
$MyFCGControlListListBox.Text = "MyFCGControlListListBox"
$MyFCGControlListListBox.ValueMember = "Name"
$MyFCGControlListListBox.Width = $MyFCGControlNameLabel.Width
#endregion $MyFCGControlListListBox = New-Object -TypeName System.Windows.Forms.ListBox

#region ******** Function Start-MyFCGControlListListBoxSelectedIndexChanged ********
function Start-MyFCGControlListListBoxSelectedIndexChanged
{
  <#
    .SYNOPSIS
      SelectedIndexChanged Event for the MyFCGControlList ListBox Control
    .DESCRIPTION
      SelectedIndexChanged Event for the MyFCGControlList ListBox Control
    .PARAMETER Sender
       The ListBox Control that fired the SelectedIndexChanged Event
    .PARAMETER EventArg
       The Event Arguments for the ListBox SelectedIndexChanged Event
    .EXAMPLE
       Start-MyFCGControlListListBoxSelectedIndexChanged -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter SelectedIndexChanged Event for `$MyFCGControlListListBox"
  
  $MyFCGConfig.AutoExit = 0
  
  $MyFCGControlEventCheckedListBox.Items.Clear()
  if ($MyFCGControlListListBox.SelectedIndex -gt -1)
  {
    $MyFCGControlEventCheckedListBox.Items.AddRange(@(Get-MyFormControlEvents -Control ($MyFCGControlListListBox.SelectedItem)))
    $MyFCGBtmStatusStrip.Items["Status"].Text = "Found $($MyFCGControlEventCheckedListBox.Items.Count) $(($MyFCGControlListListBox.SelectedItem).Name) Control Events..."
  }
  
  if ($MyFCGConfig.DefaultEvents.ContainsKey("$(($MyFCGControlListListBox.SelectedItem).Name)"))
  {
    ($MyFCGControlEventCheckedListBox.Items | Where-Object -FilterScript { $PSItem.Name -in @($MyFCGConfig.DefaultEvents["$(($MyFCGControlListListBox.SelectedItem).Name)"]) }) | ForEach-Object -Process { $MyFCGControlEventCheckedListBox.SetItemChecked($MyFCGControlEventCheckedListBox.Items.IndexOf($PSItem), $True) }
  }
  
  $MyFCGTopMenuStrip.Items["Generate"].Enabled = ($MyFCGControlListListBox.SelectedIndex -gt -1)
  $MyFCGTopMenuStrip.Items["Control"].Enabled = ($MyFCGControlListListBox.SelectedIndex -gt -1)
  $MyFCGTopMenuStrip.Items["Event"].Enabled = ($MyFCGControlEventCheckedListBox.CheckedItems.Count -gt 0)
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit SelectedIndexChanged Event for `$MyFCGControlListListBox"
}
#endregion ******** Function Start-MyFCGControlListListBoxSelectedIndexChanged ********
$MyFCGControlListListBox.add_SelectedIndexChanged({ Start-MyFCGControlListListBoxSelectedIndexChanged -Sender $This -EventArg $PSItem })

#endregion ******** $MyFCGControlGroupBox Controls ********


# ************************************************
# MyFCGScript GroupBox
# ************************************************
#region $MyFCGScriptGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGScriptGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGMainSplitContainer.Panel1.Controls.Add($MyFCGScriptGroupBox)
$MyFCGScriptGroupBox.Dock = [System.Windows.Forms.DockStyle]::Top
$MyFCGScriptGroupBox.ForeColor = $MyFCGConfig.Colors.GroupFore
$MyFCGScriptGroupBox.Name = "MyFCGScriptGroupBox"
$MyFCGScriptGroupBox.TabStop = $False
$MyFCGScriptGroupBox.Text = "Script Information"
#endregion $MyFCGScriptGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox

#region ******** $MyFCGScriptGroupBox Controls ********

#region $MyFCGScriptNameLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGScriptNameLabel = New-Object -TypeName System.Windows.Forms.Label
$MyFCGScriptGroupBox.Controls.Add($MyFCGScriptNameLabel)
$MyFCGScriptNameLabel.BackColor = $MyFCGConfig.Colors.TitleBack
$MyFCGScriptNameLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MyFCGScriptNameLabel.Dock = [System.Windows.Forms.DockStyle]::Top
$MyFCGScriptNameLabel.Font = $MyFCGConfig.Font.Bold
$MyFCGScriptNameLabel.ForeColor = $MyFCGConfig.Colors.TitleFore
$MyFCGScriptNameLabel.Name = "MyFCGScriptNameLabel"
$MyFCGScriptNameLabel.TabStop = $False
$MyFCGScriptNameLabel.Text = "Script Name"
$MyFCGScriptNameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion $MyFCGScriptNameLabel = New-Object -TypeName System.Windows.Forms.Label

$MyFCGScriptNameLabel.Height = $MyFCGScriptNameLabel.PreferredSize.Height

#region $MyFCGScriptNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGScriptNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGScriptGroupBox.Controls.Add($MyFCGScriptNameTextBox)
$MyFCGScriptNameTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
$MyFCGScriptNameTextBox.BackColor = $MyFCGConfig.Colors.TextBack
$MyFCGScriptNameTextBox.ForeColor = $MyFCGConfig.Colors.TextFore
$MyFCGScriptNameTextBox.Location = New-Object -TypeName System.Drawing.Point($MyFCGScriptNameLabel.Left, ($MyFCGScriptNameLabel.Bottom + $MyFCGConfig.FormSpacer))
$MyFCGScriptNameTextBox.Name = "MyFCGScriptNameTextBox"
$MyFCGScriptNameTextBox.TabIndex = 0
$MyFCGScriptNameTextBox.TabStop = $True
$MyFCGScriptNameTextBox.Text = ""
$MyFCGScriptNameTextBox.Width = $MyFCGScriptNameLabel.Width
#endregion $MyFCGScriptNameTextBox = New-Object -TypeName System.Windows.Forms.TextBox

$MyFCGScriptGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($MyFCGScriptNameTextBox.Right + $MyFCGConfig.FormSpacer), ($MyFCGScriptNameTextBox.Bottom + $MyFCGConfig.FormSpacer))

#endregion ******** $MyFCGScriptGroupBox Controls ********


#endregion ******** $MyFCGMainSplitContainer Panel1 Controls ********

#region ******** $MyFCGMainSplitContainer Panel2 Controls ********

# ************************************************
# MyFCGCode GroupBox
# ************************************************
#region $MyFCGCodeGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGCodeGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
$MyFCGMainSplitContainer.Panel2.Controls.Add($MyFCGCodeGroupBox)
$MyFCGCodeGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$MyFCGCodeGroupBox.ForeColor = $MyFCGConfig.Colors.GroupFore
$MyFCGCodeGroupBox.Name = "MyFCGCodeGroupBox"
$MyFCGCodeGroupBox.TabStop = $False
$MyFCGCodeGroupBox.Text = "My Generated Form Code"
#endregion $MyFCGCodeGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox

#region ******** $MyFCGCodeGroupBox Controls ********

#region $MyFCGCodeTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGCodeTextBox = New-Object -TypeName System.Windows.Forms.TextBox
$MyFCGCodeGroupBox.Controls.Add($MyFCGCodeTextBox)
$MyFCGCodeTextBox.BackColor = $MyFCGConfig.Colors.TextBack
$MyFCGCodeTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$MyFCGCodeTextBox.Font = New-Object -TypeName System.Drawing.Font($MyFCGConfig.CodeFont, $MyFCGConfig.FontSize, [System.Drawing.FontStyle]::Regular)
$MyFCGCodeTextBox.ForeColor = $MyFCGConfig.Colors.TextFore
$MyFCGCodeTextBox.MaxLength = [System.Int32]::MaxValue
$MyFCGCodeTextBox.Multiline = $True
$MyFCGCodeTextBox.Name = "MyFCGCodeTextBox"
$MyFCGCodeTextBox.ReadOnly = $True
$MyFCGCodeTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$MyFCGCodeTextBox.TabStop = $False
$MyFCGCodeTextBox.Text = ""
$MyFCGCodeTextBox.WordWrap = $False
#endregion $MyFCGCodeTextBox = New-Object -TypeName System.Windows.Forms.TextBox

#endregion ******** $MyFCGCodeGroupBox Controls ********

#endregion ******** $MyFCGMainSplitContainer Panel2 Controls ********


# ************************************************
# MyFCGTop MenuStrip
# ************************************************
#region $MyFCGTopMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
$MyFCGTopMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
$MyFCGForm.Controls.Add($MyFCGTopMenuStrip)
$MyFCGForm.MainMenuStrip = $MyFCGTopMenuStrip
$MyFCGTopMenuStrip.BackColor = $MyFCGConfig.Colors.Back
$MyFCGTopMenuStrip.Font = $MyFCGConfig.Font.Regular
$MyFCGTopMenuStrip.ForeColor = $MyFCGConfig.Colors.Fore
$MyFCGTopMenuStrip.ImageList = $MyFCGImageList
$MyFCGTopMenuStrip.Name = "MyFCGTopMenuStrip"
$MyFCGTopMenuStrip.TabIndex = 4
$MyFCGTopMenuStrip.TabStop = $False
$MyFCGTopMenuStrip.Text = "MyFCGTopMenuStrip"
#endregion $MyFCGTopMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip

#region ******** Function Start-MyFCGTopToolStripItemClick ********
function Start-MyFCGTopToolStripItemClick
{
  <#
    .SYNOPSIS
      Click Event for the MyFCGTop ToolStripItem Control
    .DESCRIPTION
      Click Event for the MyFCGTop ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-MyFCGTopToolStripItemClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ToolStripItem]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Click Event for `$MyFCGTopToolStripItem"
  $MyFCGForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
  
  $MyFCGConfig.AutoExit = 0
  
  Switch ($Sender.Name)
  {
    "GroupBox"
    {
      #region GroupBox
      if ((-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)) -and (-not [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text)))
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType "GroupBox"
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Form Control Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script and/or Control Names", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion GroupBox
      Break
    }
    "Panel"
    {
      #region Panel
      if ((-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)) -and (-not [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text)))
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType "Panel"
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Form Control Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script and/or Control Names", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion Panel
      Break
    }
    "SplitContainer"
    {
      #region SplitContainer
      if ((-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)) -and (-not [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text)))
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType "SplitContainer"
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Form Control Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script and/or Control Names", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion SplitContainer
      Break
    }
    { $PSItem -in @("TextBoxOne", "TextBoxTwo") }
    {
      #region Display-TextBox
      if ([String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text) -or [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script or Control Name ", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      else
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptStatusDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType "TextBox" -Buttons (1 + [Int]($Sender.Name -eq "TextBoxTwo"))
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Display-TextBox
    }
    { $PSItem -in @("RichTextBoxOne", "RichTextBoxTwo") }
    {
      #region Display-RichTextBox
      if ([String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text) -or [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script or Control Name ", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      else
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptStatusDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType "RichTextBox" -Buttons (1 + [Int]($Sender.Name -eq "RichTextBoxTwo"))
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Display-RichTextBox
    }
    "Get-UserInput"
    {
      #region Get-UserInput
      if ([String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text) -or [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script or Control Name ", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      else
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptUserInputDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Get-UserInput
      Break
    }
    { $PSItem -in @("WebBrowserHTML", "RichTextBoxRTF") }
    {
      #region Show-Info
      if ([String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text) -or [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script or Control Name ", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      else
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptInfoDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -MyControlType ($Sender.Tag)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Show-Info
      Break
    }
    "Select-Icon"
    {
      #region Select-Icon
      if ([String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text) -or [String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script or Control Name ", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      else
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptSelectIconDialog -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Select-Icon
      Break
    }
    "Extract"
    {
      #region Extract
      if (($Result = Show-MySIDialog -DialogTitle "Extract Icon" -Multi).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyFCGCodeTextBox.Clear()
        $TempIconPath = $Result.IconPath
        ForEach ($TempIconIndex in $Result.IconIndex)
        {
          Try
          {
            $MyFCGCodeTextBox.AppendText((Convert-MyImageToBase64 -Icon ([Extract.MyIcon]::IconReturn($TempIconPath, $TempIconIndex)) -Name ("SmallIcon{0:0000}" -f $TempIconIndex)))
            $MyFCGCodeTextBox.AppendText("`r`n")
            $MyFCGCodeTextBox.AppendText((Convert-MyImageToBase64 -Icon ([Extract.MyIcon]::IconReturn($TempIconPath, $TempIconIndex, $True)) -Name ("LargeIcon{0:0000}" -f $TempIconIndex)))
            $MyFCGCodeTextBox.AppendText("`r`n")
          }
          Catch
          {
          }
        }
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Extract
      break
    }
    "Generate"
    {
      #region Generate
      if (($MyFCGControlListListBox.SelectedIndex -gt -1) -and (-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)))
      {
        if ($MyFCGControlEventCheckedListBox.CheckedItems.Count -gt 0)
        {
          if ([String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
          {
            $MyFCGCodeTextBox.Text = Build-MyScript -MyScriptName ($MyFCGScriptNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem) -ControlEvent ($MyFCGControlEventCheckedListBox.CheckedItems)
          }
          else
          {
            $MyFCGCodeTextBox.Text = Build-MyScript -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem) -ControlEvent ($MyFCGControlEventCheckedListBox.CheckedItems)
          }
        }
        else
        {
          if ([String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
          {
            $MyFCGCodeTextBox.Text = Build-MyScript -MyScriptName ($MyFCGScriptNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem)
          }
          else
          {
            $MyFCGCodeTextBox.Text = Build-MyScript -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem)
          }
        }
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script Name or No Control Selected", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion Generate
      Break
    }
    "Control"
    {
      #region Control
      if (($MyFCGControlListListBox.SelectedIndex -gt -1) -and (-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)))
      {
        if (([String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text)) -and (-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)))
        {
          $MyFCGCodeTextBox.Text = Build-MyScriptControl -MyScriptName ($MyFCGScriptNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem)
        }
        else
        {
          $MyFCGCodeTextBox.Text = Build-MyScriptControl -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem)
        }
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Form Control Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script Name or No Control Selected", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion Control
      Break
    }
    "Event"
    {
      #region Event
      if (($MyFCGControlEventCheckedListBox.CheckedItems.Count -gt 0) -and (-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text)))
      {
        if ([String]::IsNullOrEmpty($MyFCGControlNameTextBox.Text))
        {
          $MyFCGCodeTextBox.Text = Build-MyScriptEvent -MyScriptName ($MyFCGScriptNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem) -ControlEvent ($MyFCGControlEventCheckedListBox.CheckedItems)
        }
        else
        {
          $MyFCGCodeTextBox.Text = Build-MyScriptEvent -MyScriptName ($MyFCGScriptNameTextBox.Text) -MyControlName ($MyFCGControlNameTextBox.Text) -Control ($MyFCGControlListListBox.SelectedItem) -ControlEvent ($MyFCGControlEventCheckedListBox.CheckedItems)
        }
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Control Event Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script Name or No Events Selected", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion Event
      Break
    }
    "Library"
    {
      #region Library
      if (-not [String]::IsNullOrEmpty($MyFCGScriptNameTextBox.Text))
      {
        $MyFCGCodeTextBox.Text = Build-MyScriptLibrary -MyScriptName ($MyFCGScriptNameTextBox.Text)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Script Code Generated: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "Missing Script Name or No Control Selected", $MyFCGConfig.ScriptName, "OK", "Warning")
      }
      #endregion Library
      Break
    }
    "Source"
    {
      #region Source
      $CallStack = Get-PSCallStack
      $MyFCGCodeTextBox.Text = ($CallStack[$CallStack.Count - 1].InvocationInfo.MyCommand.ScriptBlock).ToString()
      $CallStack = $Null
      $MyFCGBtmStatusStrip.Items["Status"].Text = "$($MyFCGConfig.ScriptName) Source Code: $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      #endregion Source
      Break
    }
    "Image"
    {
      #region Image
      $MyFCGOpenFileDialog.Title = "Encode Icon / Image"
      $MyFCGOpenFileDialog.Filter = "All Icon and Image Files|*.ico;*.bmp;*.gif;*.jpg;*.jpeg;*.png|Icon Files Only|*.ico|Image Files Only|*.bmp;*.gif;*.jpg;*.jpeg;*.png"
      $MyFCGOpenFileDialog.FilterIndex = 0
      $MyFCGOpenFileDialog.FileName = ""
      If ($MyFCGOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyFCGCodeTextBox.Text = $(Convert-MyImageToBase64 -Path $MyFCGOpenFileDialog.FileName -Name $MyFCGOpenFileDialog.SafeFileName)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "Image Encoded: $([System.IO.Path]::GetFileName($MyFCGOpenFileDialog.FileName)) - $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Image
      Break
    }
    "CData"
    {
      #region Data
      $MyFCGOpenFileDialog.Title = "Compress / Encode File Data"
      $MyFCGOpenFileDialog.Filter = "Text Files|*.txt|XML Files|*.xml|HTM/HTML Files|*.htm;*.html|Rich Text Documents|*.rtf|Microsoft Office Files|*.doc;*.docx;*.xls;*.xlsx|Applications|*.exe|All Files|*.*"
      $MyFCGOpenFileDialog.FilterIndex = 0
      $MyFCGOpenFileDialog.FileName = ""
      If ($MyFCGOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyFCGCodeTextBox.Text = $(Compress-MyDataFile -Path $MyFCGOpenFileDialog.FileName -Name $MyFCGOpenFileDialog.SafeFileName)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "File Encoded: $([System.IO.Path]::GetFileName($MyFCGOpenFileDialog.FileName)) - $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Data
      Break
    }
    "EData"
    {
      #region Data
      $MyFCGOpenFileDialog.Title = "Encode File Data"
      $MyFCGOpenFileDialog.Filter = "Text Files|*.txt|XML Files|*.xml|HTM/HTML Files|*.htm;*.html|Rich Text Documents|*.rtf|Microsoft Office Files|*.doc;*.docx;*.xls;*.xlsx|Applications|*.exe|All Files|*.*"
      $MyFCGOpenFileDialog.FilterIndex = 0
      $MyFCGOpenFileDialog.FileName = ""
      If ($MyFCGOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyFCGCodeTextBox.Text = $(Encode-MyDataFile -Path $MyFCGOpenFileDialog.FileName -Name $MyFCGOpenFileDialog.SafeFileName)
        $MyFCGCodeTextBox.SelectAll()
        $MyFCGCodeTextBox.Copy()
        $MyFCGCodeTextBox.DeselectAll()
        $MyFCGBtmStatusStrip.Items["Status"].Text = "File Encoded: $([System.IO.Path]::GetFileName($MyFCGOpenFileDialog.FileName)) - $($MyFCGCodeTextBox.Lines.Count) Line(s)"
      }
      #endregion Data
      Break
    }
    "Help"
    {
      $MyFCGBtmStatusStrip.Items["Status"].Text = "Help!"
      Show-MyHelpDialog
      #[Void][System.Windows.Forms.MessageBox]::Show($MyFCGForm, "There is no Help!", $MyFCGConfig.ScriptName, "OK", "Information")
      Break
    }
    "Exit"
    {
      $MyFCGForm.Close()
      $MyFCGBtmStatusStrip.Items["Status"].Text = "Exiting..."
      Break
    }
  }
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  $MyFCGForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
  Write-Verbose -Message "Exit Click Event for `$MyFCGTopToolStripItem"
}
#endregion ******** Function Start-MyFCGTopToolStripItemClick ********

#region ******** MyFCG Menu items ********

# Main Menu
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Generate" -Name "Generate" -Tag "Generate" -DisplayStyle "ImageAndText" -ImageKey "GenerateIcon" -Disable -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Control" -Name "Control" -Tag "Control" -DisplayStyle "ImageAndText" -ImageKey "ControlIcon" -Disable -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "E&vent" -Name "Event" -Tag "Event" -DisplayStyle "ImageAndText" -ImageKey "EventIcon" -Disable -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
New-MenuSeparator -Menu $MyFCGTopMenuStrip
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "Li&brary" -Name "Library" -Tag "Library" -DisplayStyle "ImageAndText" -ImageKey "LibraryIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
$NewMenuItem = New-MenuItem -Menu $MyFCGTopMenuStrip -Text "Dia&logs" -Name "Dialogs" -Tag "Dialogs" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru

# Dialogs Sub Menu
$SubMenuItem = New-MenuItem -Menu $NewMenuItem -Text "Dialog &Templates" -Name "Dialog Templates" -Tag "Dialog Templates" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru
(New-MenuItem -Menu $SubMenuItem -Text "&GroupBox" -Name "GroupBox" -Tag "GroupBox" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "&Panel" -Name "Panel" -Tag "Panel" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "&SplitContainer" -Name "SplitContainer" -Tag "SplitContainer" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

New-MenuSeparator -Menu $NewMenuItem

$SubMenuItem = New-MenuItem -Menu $NewMenuItem -Text "Dialog - Display-&Status" -Name "Display-Status" -Tag "Display-Status" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru
(New-MenuItem -Menu $SubMenuItem -Text "TextBox - &One Button" -Name "TextBoxOne" -Tag "TextBoxOne" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "TextBox - &Two Buttons" -Name "TextBoxTwo" -Tag "TextBoxTwo" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
New-MenuSeparator -Menu $SubMenuItem
(New-MenuItem -Menu $SubMenuItem -Text "RichTextBox - O&ne Button" -Name "RichTextBoxOne" -Tag "RichTextBoxOne" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "RichTextBox - T&wo Buttons" -Name "RichTextBoxTwo" -Tag "RichTextBoxTwo" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

$SubMenuItem = New-MenuItem -Menu $NewMenuItem -Text "Dialog - Show-I&nfo" -Name "Show-Info" -Tag "Show-Info" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru
(New-MenuItem -Menu $SubMenuItem -Text "WebBrowser - &HTML" -Name "WebBrowserHTML" -Tag "WebBrowser" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "RichTextBox - &RTF" -Name "RichTextBoxRTF" -Tag "RichTextBox" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

New-MenuSeparator -Menu $NewMenuItem

(New-MenuItem -Menu $NewMenuItem -Text "Dialog - Get-&UserInput" -Name "Get-UserInput" -Tag "Get-UserInput" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $NewMenuItem -Text "Dialog - Select-&Icon" -Name "Select-Icon" -Tag "Select-Icon" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
$NewMenuItem = $Null

# Main Menu
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Source" -Name "Source" -Tag "Source" -DisplayStyle "ImageAndText" -ImageKey "SourceIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

New-MenuSeparator -Menu $MyFCGTopMenuStrip

if ($Host.Version.Major -le 5)
{
  (New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Extract" -Name "Extract" -Tag "Extract" -DisplayStyle "ImageAndText" -ImageKey "ExtractIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
}
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Image" -Name "Image" -Tag "Image" -DisplayStyle "ImageAndText" -ImageKey "ImageIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

$SubMenuItem = New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Data" -Name "Data" -Tag "Data" -DisplayStyle "ImageAndText" -ImageKey "DialogIcon" -PassThru
(New-MenuItem -Menu $SubMenuItem -Text "&Compress Data" -Name "CData" -Tag "CData" -DisplayStyle "ImageAndText" -ImageKey "DataIcon" -Disable -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $SubMenuItem -Text "&Encode &Data" -Name "EData" -Tag "EData" -DisplayStyle "ImageAndText" -ImageKey "DataIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

New-MenuSeparator -Menu $MyFCGTopMenuStrip

(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "&Help" -Name "Help" -Tag "Help" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $MyFCGTopMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({ Start-MyFCGTopToolStripItemClick -Sender $This -EventArg $PSItem })

#endregion ******** MyFCG Menu items ********

# ************************************************
# MyFCGBtm StatusStrip
# ************************************************
#region $MyFCGBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
$MyFCGBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
$MyFCGForm.Controls.Add($MyFCGBtmStatusStrip)
#$MyFCGForm.StatusStrip = $MyFCGBtmStatusStrip
$MyFCGBtmStatusStrip.BackColor = $MyFCGConfig.Colors.Back
$MyFCGBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
$MyFCGBtmStatusStrip.Font = $MyFCGConfig.Font.Regular
$MyFCGBtmStatusStrip.ForeColor = $MyFCGConfig.Colors.Fore
$MyFCGBtmStatusStrip.ImageList = $MyFCGImageList
$MyFCGBtmStatusStrip.Name = "MyFCGBtmStatusStrip"
$MyFCGBtmStatusStrip.TabStop = $False
$MyFCGBtmStatusStrip.Text = "MyFCGBtmStatusStrip"
#endregion $MyFCGBtmStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip

New-MenuLabel -Menu $MyFCGBtmStatusStrip -Text "Status" -Name "Status" -Tag "Status"

#endregion ******** Controls for MyFCG Form ********

#endregion ================ End **** MyFCG **** End ================

[System.Windows.Forms.Application]::Run($MyFCGForm)

$MyFCGOpenFileDialog.Dispose()
$MyFCGFormComponents.Dispose()
$MyFCGForm.Dispose()

if ($MyFCGConfig.Production)
{
  [System.Environment]::Exit(0)
}

