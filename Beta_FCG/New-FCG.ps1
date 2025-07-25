# ----------------------------------------------------------------------------------------------------------------------
#
#  Script: FCG
# Version: 0.0.0.0
#
# ----------------------------------------------------------------------------------------------------------------------
<#
Change Log for FCG
------------------------------------------------------------------------------------------------
0.0.0.0 - Initial Version
------------------------------------------------------------------------------------------------
#>

#requires -version 5.0

using namespace System.Windows.Forms
using namespace System.Drawing
using namespace System.Collections
using namespace System.Collections.Specialized

<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER <Parameter-Name>
  .EXAMPLE
  .NOTES
    My Script FCG Version 1.0 by kensw on 04/04/2025
    Created with "My PS5 Form Code Generator" Version 6.1.4.1
#>
#[CmdletBinding()]
#param (
#)

$ErrorActionPreference = "Stop"

# Set $VerbosePreference to 'SilentlyContinue' for Production Deployment
$VerbosePreference = "Continue"

# Set $DebugPreference for Production Deployment
$DebugPreference = "SilentlyContinue"

# Hide Console Window Progress Bar
$ProgressPreference = "SilentlyContinue"

# Clear Previous Error Messages
$Error.Clear()

# Pre-Load Required Modules
[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Enable Visual Styles
[System.Windows.Forms.Application]::EnableVisualStyles()

# Pre-Load Required Modules
if ([String]::IsNullOrEmpty((Get-Module -Name CimCmdlets -ErrorAction SilentlyContinue -Verbose:$False).Name))
{
  Import-Module -Name CimCmdlets -ErrorAction SilentlyContinue -Verbose:$False
  if ([String]::IsNullOrEmpty((Get-Module -Name CimCmdlets -ErrorAction SilentlyContinue -Verbose:$False).Name))
  {
    throw "ERROR: Unable to Load Module 'CimCmdlets'"
  }
}

# Enable Visual Styles
[System.Windows.Forms.Application]::EnableVisualStyles()

#region >>>>>>>>>>>>>>>> FCG Configuration <<<<<<<<<<<<<<<<
Class MyConfig
{
  # Default Form Run Mode
  static [bool]$Production = $False

  static [String]$ScriptName = "My Script - FCG"
  static [Version]$ScriptVersion = [Version]::New("0.0.0.0")
  static [String]$ScriptAuthor = "kensw"

  # Script Configuration
  static [String]$ScriptRoot = ""
  static [String]$ConfigFile = ""
  static [PSCustomObject]$ConfigData = [PSCustomObject]@{ }

  # Script Runtime Values
  static [Bool]$Is64Bit = ([IntPtr]::Size -eq 8)

  # Default Form Settings
  static [Int]$FormSpacer = 4
  static [int]$FormMinWidth = 60
  static [int]$FormMinHeight = 35

  # Default Font
  static [String]$FontFamily = "Verdana"
  static [Single]$FontSize = 10
  static [Single]$FontTitle = 1.5

  # Azure Module Logon Information
  static [String]$AZModuleName = "Az.Accounts"
  static [String]$AZModuleVersion = "2.19.0"

  Static [OrderedDictionary]$RequiredModules = [Ordered]@{
    "Az.Accounts" = "4.0.2"
    "Az.KeyVault" = "6.3.1"
    "Az.Automation" = "1.11.1"
  }

  # Azure Logon Information
  static [String]$TenantID = ""
  static [String]$SubscriptionID = ""
  static [Object]$AADLogonInfo = $Null
  static [Object]$AccessToken = $Null
  static [HashTable]$AuthToken = @{ }

  # Default Form Color Mode
  static [Bool]$DarkMode = ((Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -ErrorAction "SilentlyContinue").AppsUseLightTheme -eq "0")

  # Form Auto Exit
  static [Int]$AutoExit = 0
  static [Int]$AutoExitMax = 60
  static [Int]$AutoExitTic = 60000

  # Administrative Rights
  static [Bool]$IsLocalAdmin = ([Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  static [Bool]$IsPowerUser = ([Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::PowerUser)

  # KPI Event Logging
  static [Bool]$KPILogExists = $False
  static [String]$KPILogName = "KPI Event Log"

  # Network / Internet
  static [__ComObject]$IsConnected = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))

  # Default Script Credentials
  static [String]$Domain = "Domain"
  static [String]$UserID = "UserID"
  static [String]$Password = "P@ssw0rd"

  # Default SMTP Configuration
  static [String]$SMTPServer = "smtp.mydomain.local"
  static [int]$SMTPPort = 25

  # Default MEMCM Configuration
  static [String]$MEMCMServer = "MyMEMCM.MyDomain.Local"
  static [String]$MEMCMSite = "XYZ"
  static [String]$MEMCMNamespace = "Root\SMS\Site_XYZ"

  # Help / Issues Uri's
  static [String]$HelpURL = "https://www.microsoft.com/"
  static [String]$BugURL = "https://www.amazon.com/"

  # CertKet for Cert Encryption
  static [String]$CertKey = ""

  # Web Browser File Path's
  static [String]$EdgePath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" -ErrorAction "SilentlyContinue")."(default)"
  static [String]$ChromePath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" -ErrorAction "SilentlyContinue")."(default)"

  # Current DateTime Offset
  static [DateTimeOffset]$DateTimeOffset = [System.DateTimeOffset]::Now

  static [HashTable]$Colors = @{}

  static [HashTable]$Font = @{}
}

# Get Script Path
if ([String]::IsNullOrEmpty($HostInvocation))
{
  [MyConfig]::ScriptRoot = [System.IO.Path]::GetDirectoryName($Script:MyInvocation.MyCommand.Path)
}
else
{
  [MyConfig]::ScriptRoot = [System.IO.Path]::GetDirectoryName($HostInvocation.MyCommand.Path)
}

#endregion ================ FCG Configuration  ================

#region >>>>>>>>>>>>>>>> Set FCG Default Colors <<<<<<<<<<<<<<<<

[MyConfig]::Colors.Clear()
if ([MyConfig]::DarkMode)
{
  [MyConfig]::Colors.Add("Back", ([System.Drawing.Color]::FromArgb(40, 40, 40)))
  #[MyConfig]::Colors.Add("Fore", ([System.Drawing.Color]::LightCoral))
  [MyConfig]::Colors.Add("Fore", ([System.Drawing.Color]::DodgerBlue))
  [MyConfig]::Colors.Add("LabelFore", ([System.Drawing.Color]::WhiteSmoke))
  [MyConfig]::Colors.Add("ErrorFore", ([System.Drawing.Color]::Red))
  [MyConfig]::Colors.Add("TitleBack", ([System.Drawing.Color]::DarkGray))
  [MyConfig]::Colors.Add("TitleFore", ([System.Drawing.Color]::Black))
  [MyConfig]::Colors.Add("GroupFore", ([System.Drawing.Color]::WhiteSmoke))
  [MyConfig]::Colors.Add("TextBack", ([System.Drawing.Color]::Gainsboro))
  [MyConfig]::Colors.Add("TextROBack", ([System.Drawing.Color]::DarkGray))
  [MyConfig]::Colors.Add("TextFore", ([System.Drawing.Color]::Black))
  [MyConfig]::Colors.Add("TextTitle", ([System.Drawing.Color]::Navy))
  [MyConfig]::Colors.Add("TextHint", ([System.Drawing.Color]::Gray))
  [MyConfig]::Colors.Add("TextBad", ([System.Drawing.Color]::FireBrick))
  [MyConfig]::Colors.Add("TextWarn", ([System.Drawing.Color]::Sienna))
  [MyConfig]::Colors.Add("TextGood", ([System.Drawing.Color]::ForestGreen))
  [MyConfig]::Colors.Add("TextInfo", ([System.Drawing.Color]::CornflowerBlue))
  [MyConfig]::Colors.Add("ButtonBack", ([System.Drawing.Color]::DarkGray))
  [MyConfig]::Colors.Add("ButtonFore", ([System.Drawing.Color]::Black))
}
else
{
  [MyConfig]::Colors.Add("Back", ([System.Drawing.Color]::WhiteSmoke))
  [MyConfig]::Colors.Add("Fore", ([System.Drawing.Color]::Navy))
  [MyConfig]::Colors.Add("LabelFore", ([System.Drawing.Color]::Black))
  [MyConfig]::Colors.Add("ErrorFore", ([System.Drawing.Color]::Red))
  [MyConfig]::Colors.Add("TitleBack", ([System.Drawing.Color]::LightBlue))
  [MyConfig]::Colors.Add("TitleFore", ([System.Drawing.Color]::Navy))
  [MyConfig]::Colors.Add("GroupFore", ([System.Drawing.Color]::Navy))
  [MyConfig]::Colors.Add("TextBack", ([System.Drawing.Color]::White))
  [MyConfig]::Colors.Add("TextROBack", ([System.Drawing.Color]::Gainsboro))
  [MyConfig]::Colors.Add("TextFore", ([System.Drawing.Color]::Black))
  [MyConfig]::Colors.Add("TextTitle", ([System.Drawing.Color]::Navy))
  [MyConfig]::Colors.Add("TextHint", ([System.Drawing.Color]::Gray))
  [MyConfig]::Colors.Add("TextBad", ([System.Drawing.Color]::FireBrick))
  [MyConfig]::Colors.Add("TextWarn", ([System.Drawing.Color]::Sienna))
  [MyConfig]::Colors.Add("TextGood", ([System.Drawing.Color]::ForestGreen))
  [MyConfig]::Colors.Add("TextInfo", ([System.Drawing.Color]::CornflowerBlue))
  [MyConfig]::Colors.Add("ButtonBack", ([System.Drawing.Color]::Gainsboro))
  [MyConfig]::Colors.Add("ButtonFore", ([System.Drawing.Color]::Navy))
}

#region Default Colors
<#
  [MyConfig]::Colors.Add("Back", ([System.Drawing.SystemColors]::Control))
  [MyConfig]::Colors.Add("Fore", ([System.Drawing.SystemColors]::ControlText))
  [MyConfig]::Colors.Add("LabelFore", ([System.Drawing.SystemColors]::ControlText))
  [MyConfig]::Colors.Add("ErrorFore", ([System.Drawing.SystemColors]::ControlText))
  [MyConfig]::Colors.Add("TitleBack", ([System.Drawing.SystemColors]::ControlText))
  [MyConfig]::Colors.Add("TitleFore", ([System.Drawing.SystemColors]::Control))
  [MyConfig]::Colors.Add("GroupFore", ([System.Drawing.SystemColors]::ControlText))
  [MyConfig]::Colors.Add("TextBack", ([System.Drawing.SystemColors]::Window))
  [MyConfig]::Colors.Add("TextROBack", ([System.Drawing.SystemColors]::Window))
  [MyConfig]::Colors.Add("TextFore", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("TextTitle", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("TextHint", ([System.Drawing.SystemColors]::GrayText))
  [MyConfig]::Colors.Add("TextBad", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("TextWarn", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("TextGood", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("TextInfo", ([System.Drawing.SystemColors]::WindowText))
  [MyConfig]::Colors.Add("ButtonBack", ([System.Drawing.SystemColors]::Control))
  [MyConfig]::Colors.Add("ButtonFore", ([System.Drawing.SystemColors]::ControlText))
#>
#endregion Default Colors

#endregion ================ Set FCG Default Colors ================

#region >>>>>>>>>>>>>>>> Set FCG Default Font Data <<<<<<<<<<<<<<<<

$MonitorSize = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize
$TempMeasureString = @{ "Width" = 1000; "Height" = 1000; "IsEmpty" = $True }
while (($MonitorSize.Width -le ([MyConfig]::FormMinWidth * [Math]::Floor($TempMeasureString.Width))) -or ($MonitorSize.Height -le ([MyConfig]::FormMinHeight * [Math]::Floor($TempMeasureString.Height))))
{
  if (-not $TempMeasureString.IsEmpty)
  {
    [MyConfig]::FontSize = [MyConfig]::FontSize - .1
  }
  $TempBoldFont = [System.Drawing.Font]::New([MyConfig]::FontFamily, [MyConfig]::FontSize, [System.Drawing.FontStyle]::Bold)
  $TempGraphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
  $TempMeasureString = $TempGraphics.MeasureString("X", $TempBoldFont)
}
[MyConfig]::Font.Clear()
[MyConfig]::Font.Add("Regular", ([System.Drawing.Font]::New([MyConfig]::FontFamily, [MyConfig]::FontSize, [System.Drawing.FontStyle]::Regular)))
[MyConfig]::Font.Add("Hint", ([System.Drawing.Font]::New([MyConfig]::FontFamily, [MyConfig]::FontSize, [System.Drawing.FontStyle]::Italic)))
[MyConfig]::Font.Add("Bold", ($TempBoldFont))
[MyConfig]::Font.Add("Title", ([System.Drawing.Font]::New([MyConfig]::FontFamily, ([MyConfig]::FontSize * [MyConfig]::FontTitle), [System.Drawing.FontStyle]::Bold)))
[MyConfig]::Font.Add("Ratio", ($TempGraphics.DpiX / 96))
[MyConfig]::Font.Add("Width", ([Math]::Floor($TempMeasureString.Width)))
[MyConfig]::Font.Add("Height", ([Math]::Ceiling($TempMeasureString.Height)))
$MonitorSize = $Null
$TempBoldFont = $Null
$TempMeasureString = $Null
$TempGraphics.Dispose()
$TempGraphics = $Null

#endregion ================ Set FCG Default Font Data ================

#region >>>>>>>>>>>>>>>> FCG Runtime Values <<<<<<<<<<<<<<<<

Class MyRuntime
{
  Static [HashTable]$Favorites = [HashTable]::New()
}

#endregion ================ FCG Runtime  Values ================

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

[System.Console]::Title = "RUNNING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
If ([MyConfig]::Production)
{
  [Void][Console.Window]::Hide()
}

#endregion ================ Windows APIs ================

#region >>>>>>>>>>>>>>>> My Default Enumerations <<<<<<<<<<<<<<<<

#region ******** enum MyAnswer ********
[Flags()]
enum MyAnswer
{
  Unknown = 0
  No      = 1
  Yes     = 2
  Maybe   = 3
}
#endregion ******** enum MyAnswer ********

#region ******** enum MyDigit ********
enum MyDigit
{
  Zero
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
  Nine
}
#endregion ******** enum MyDigit ********

#region ******** enum MyBits ********
[Flags()]
enum MyBits
{
  Bit01 = 0x00000001
  Bit02 = 0x00000002
  Bit03 = 0x00000004
  Bit04 = 0x00000008
  Bit05 = 0x00000010
  Bit06 = 0x00000020
  Bit07 = 0x00000040
  Bit08 = 0x00000080
  Bit09 = 0x00000100
  Bit10 = 0x00000200
  Bit11 = 0x00000400
  Bit12 = 0x00000800
  Bit13 = 0x00001000
  Bit14 = 0x00002000
  Bit15 = 0x00004000
  Bit16 = 0x00008000
}
#endregion ******** enum MyBits ********

#endregion ================ My Default Enumerations ================

#region >>>>>>>>>>>>>>>> My Custom Class <<<<<<<<<<<<<<<<

#region MyListItem Class
Class MyListItem
{
  [String]$Text
  [Object]$Value
  [Object]$Tag
  [MyBits]$Flags

  MyListItem ([String]$Text, [Object]$Value)
  {
    $This.Text = $Text
    $This.Value = $Value
  }

  MyListItem ([String]$Text, [Object]$Value, [MyBits]$Flags)
  {
    $This.Text = $Text
    $This.Value = $Value
    $This.Flags = $Flags
  }

  MyListItem ([String]$Text, [Object]$Value, [Object]$Tag)
  {
    $This.Text = $Text
    $This.Value = $Value
    $This.Tag = $Tag
  }

  MyListItem ([String]$Text, [Object]$Value, [Object]$Tag, [MyBits]$Flags)
  {
    $This.Text = $Text
    $This.Value = $Value
    $This.Tag = $Tag
    $This.Flags = $Flags
  }
}
#endregion MyListItem Class

#region Class MyFavorite
Class MyFavorite
{
  [String]$Control
  [ArrayList]$Properties = [ArrayList]::New()
  [ArrayList]$Events = [ArrayList]::New()
  
  MyFavorite ([String]$Control, [String[]]$Properties, [String[]]$Events)
  {
    $this.Control = $Control
    $this.Properties.AddRange($Properties)
    $this.Events.AddRange($Events)
  }
}
#endregion Class MyFavorite

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

#endregion ================ My Custom Class ================

#region >>>>>>>>>>>>>>>> My Custom Functions <<<<<<<<<<<<<<<<

#region Function Prompt
Function Prompt
{
  [Console]::Title = $PWD
  "PS$($PSVersionTable.PSVersion.Major)$(">" * ($NestedPromptLevel + 1)) "
}
#endregion Function Prompt

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

#region ******* Microsoft Forms Functions ********

#region function New-MyListItem
function New-MyListItem()
{
  <#
    .SYNOPSIS
      Makes and Adds a New ListItem for a ComboBox or ListBox Control
    .DESCRIPTION
      Makes and Adds a New ListItem for a ComboBox or ListBox Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Value
    .PARAMETER Tag
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MyListItem -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [Object]$Control,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [parameter(Mandatory = $True)]
    [String]$Value,
    [Object]$Tag,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MyListItem"

  If ($PassThru)
  {
    $Control.Items.Add(([PSCustomObject]@{"Text" = $Text; "Value" = $Value; "Tag" = $Tag}))
  }
  Else
  {
    [Void]$Control.Items.Add(([PSCustomObject]@{"Text" = $Text; "Value" = $Value; "Tag" = $Tag}))
  }

  Write-Verbose -Message "Exit Function New-MyListItem"
}
#endregion function New-MyListItem

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
    .PARAMETER TextImageRelation
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
    [parameter(Mandatory = $False, ParameterSetName = "Icon")]
    [parameter(Mandatory = $False, ParameterSetName = "ImageIndex")]
    [parameter(Mandatory = $False, ParameterSetName = "ImageKey")]
    [System.Windows.Forms.TextImageRelation]$TextImageRelation = "ImageBeforeText",
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [Switch]$Check,
    [Switch]$ClickOnCheck,
    [System.Windows.Forms.Keys]$ShortcutKeys = "None",
    [System.Drawing.Font]$Font = [MyConfig]::Font.Regular,
    [System.Drawing.Color]$BackColor = [MyConfig]::Colors.Back,
    [System.Drawing.Color]$ForeColor = [MyConfig]::Colors.Fore,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuItem"

  #region $TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]
  $TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]::New($Text)

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

  $TempMenuItem.BackColor = $BackColor
  $TempMenuItem.ForeColor = $ForeColor
  $TempMenuItem.Font = $Font

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
    $TempMenuItem.TextImageRelation = $TextImageRelation
  }
  #endregion $TempMenuItem = [System.Windows.Forms.ToolStripMenuItem]

  If ($PassThru.IsPresent)
  {
    $TempMenuItem
  }

  $TempMenuItem = $Null

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
    [System.Drawing.ContentAlignment]$Alignment = "MiddleLeft",
    [Object]$Tag,
    [Switch]$Disable,
    [System.Drawing.Font]$Font = [MyConfig]::Font.Regular,
    [System.Drawing.Color]$BackColor = [MyConfig]::Colors.Back,
    [System.Drawing.Color]$ForeColor = [MyConfig]::Colors.Fore,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuLabel"

  #region $TempMenuLabel = [System.Windows.Forms.ToolStripLabel]
  $TempMenuLabel = [System.Windows.Forms.ToolStripLabel]::New($Text)

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

  $TempMenuLabel.BackColor = $BackColor
  $TempMenuLabel.ForeColor = $ForeColor
  $TempMenuLabel.Font = $Font

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
  param(
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [System.Drawing.Color]$BackColor = [MyConfig]::Colors.Back,
    [System.Drawing.Color]$ForeColor = [MyConfig]::Colors.Fore
  )
  Write-Verbose -Message "Enter Function New-MenuSeparator"

  #region $TempSeparator = [System.Windows.Forms.ToolStripSeparator]
  $TempSeparator = [System.Windows.Forms.ToolStripSeparator]::New()

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

  $TempSeparator.BackColor = $BackColor
  $TempSeparator.ForeColor = $ForeColor
  #endregion $TempSeparator = [System.Windows.Forms.ToolStripSeparator]

  $TempSeparator = $Null

  Write-Verbose -Message "Exit Function New-MenuSeparator"
}
#endregion function New-MenuSeparator

#endregion ******* Microsoft Forms Functions ********

#region ******* Encrypt / Encode Data Functions ********

#region function Encode-MyData
function Encode-MyData()
{
  <#
    .SYNOPSIS
      Encode Base64 String Data
    .DESCRIPTION
      Encode Base64 String Data
    .PARAMETER Data
      Data to Compress
    .PARAMETER LineLength
      Max Line Length
    .EXAMPLE
      Encode-MyData -Data "String"
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Int]$LineLength = 160
  )
  Write-Verbose -Message "Enter Function Encode-MyData"

  $MemoryStream = [System.IO.MemoryStream]::New()
  $StreamWriter = [System.IO.StreamWriter]::New($MemoryStream, [System.Text.Encoding]::UTF8)
  $StreamWriter.Write($Data)
  $StreamWriter.Close()

  $Code = [System.Text.StringBuilder]::New()
  ForEach ($Line in @([System.Convert]::ToBase64String($MemoryStream.ToArray()) -split "(?<=\G.{$LineLength})(?=.)"))
  {
    [Void]$Code.AppendLine($Line)
  }

  $Code.ToString()
  $MemoryStream.Close()
  $MemoryStream = $Null
  $StreamWriter = $Null
  $Code = $Null
  $Line = $Null

  Write-Verbose -Message "Exit Function Encode-MyData"
}
#endregion function Encode-MyData

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
  $MemoryStream = [System.IO.MemoryStream]::New()
  $MemoryStream.Write($CompressedData, 0, $CompressedData.Length)
  [Void]$MemoryStream.Seek(0, 0)
  $StreamReader = [System.IO.StreamReader]::New($MemoryStream, [System.Text.Encoding]::UTF8)

  if ($AsString.IsPresent)
  {
    $StreamReader.ReadToEnd()
  }
  else
  {
    $ArrayList = [System.Collections.ArrayList]::New()
    $Buffer = [System.Char[]]::New(4096)
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

  Write-Verbose -Message "Exit Function Decode-MyData"
}
#endregion function Decode-MyData

#region Function Encrypt-MySensitiveData
Function Encrypt-MySensitiveData
{
  <#
    .SYNOPSIS
      Encrypts / Decrypts Text String Data
    .DESCRIPTION
      Encrypts / Decrypts Text String Data
    .PARAMETER String
      Plain Text or Encrypted String
    .PARAMETER PassPhrase
      Pass Phrase to Encrypt / Decrypt Data
    .PARAMETER Salt
      Salt to Encrypt / Decrypt Data
    .PARAMETER HashAlgorithm
      Hash Algorithm to Encrypt / Decrypt Data
    .PARAMETER CipherMode
      Cipher Mode to Encrypt / Decrypt Data
    .PARAMETER PaddingMode
      Padding Mode to Encrypt / Decrypt Data
    .PARAMETER Decrypt
      Switch to Decrypt Data
    .EXAMPLE
      $EncryptedData = Encrypt-PMSensitiveData -String $String -PassPhrase $PassPhrase -Salt $Pepper
    .EXAMPLE
      $DecryptedData = Encrypt-PMSensitiveData -String $String -PassPhrase $PassPhrase -Salt $Pepper -Decrypt
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$String,
    [parameter(Mandatory = $True)]
    [String]$PassPhrase = "PassPhrase",
    [parameter(Mandatory = $False)]
    [String]$Salt = "Pepper",
    [System.Security.Cryptography.HashAlgorithmName]$HashAlgorithm = [System.Security.Cryptography.HashAlgorithmName]::SHA256,
    [System.Security.Cryptography.CipherMode]$CipherMode = [System.Security.Cryptography.CipherMode]::CBC,
    [System.Security.Cryptography.PaddingMode]$PaddingMode = [System.Security.Cryptography.PaddingMode]::PKCS7,
    [Switch]$Decrypt
  )
  Write-Verbose -Message "Enter Function $($MyInvocation.MyCommand)"

  # Create Cryptography AES Object
  $Aes = [System.Security.Cryptography.Aes]::Create()
  $Aes.Mode = $CipherMode
  $Aes.Padding = $PaddingMode
  # Salt Needs to be at least 8 Characters
  $SaltBytes = [System.Text.Encoding]::UTF8.GetBytes($Salt.PadRight(8, "*"))
  $Aes.Key = [System.Security.Cryptography.Rfc2898DeriveBytes]::New($PassPhrase, $SaltBytes, 8, $HashAlgorithm).GetBytes($Aes.Key.Length)

  if ($Decrypt.IsPresent)
  {
    # Decrypt Encrypted Data
    $DecodeBytes = [System.Convert]::FromBase64String($String)
    $Aes.IV = $DecodeBytes[0..15]
    $Decryptor = $Aes.CreateDecryptor()
    [System.Text.Encoding]::UTF8.GetString(($Decryptor.TransformFinalBlock($DecodeBytes, 16, ($DecodeBytes.Length - 16))))
  }
  else
  {
    # Encrypt String Data
    $EncodeBytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    $Encryptor = $Aes.CreateEncryptor()
    $EncryptedBytes = [System.Collections.ArrayList]::New($Aes.IV)
    $EncryptedBytes.AddRange($Encryptor.TransformFinalBlock($EncodeBytes, 0, $EncodeBytes.Length))
    [System.Convert]::ToBase64String($EncryptedBytes)
    $EncryptedBytes.Clear()
  }

  $Aes.Dispose()

  Write-Verbose -Message "Exit Function $($MyInvocation.MyCommand)"
}
#endregion Function Encrypt-MySensitiveData

#region function Encrypt-WithCert
Function Encrypt-WithCert ()
{
  <#
    .SYNOPSIS
      Encrypts Text Data used Info from Cert
    .DESCRIPTION
      Encrypts Text Data used Info from Cert
    .PARAMETER CertKey
    .PARAMETER TextString
    .PARAMETER Salt
    .PARAMETER Universal
    .PARAMETER Decrypt
    .EXAMPLE
      # Encrypt with Local Salt
      $EncryptedText = Encrypt-WithCert -CertKey $CeryKey -Salt $Salt -TextString $TextString
    .EXAMPLE
      # Encrypt with Universal Salt
      $EncryptedText = Encrypt-WithCert -CertKey $CeryKey -Salt $Salt -Universal -TextString $TextString
    .EXAMPLE
      # Encrypt with No Salt
      $EncryptedText = Encrypt-WithCert -CertKey $CeryKey -TextString $TextString
    .NOTES
      Original Function By Ken Sweet

      2024-02-14 - Initial Release
  #>
  [CmdletBinding(DefaultParameterSetName = "NoSalt")]
  Param (
    [parameter(Mandatory = $True)]
    [String]$CertKey,
    [parameter(Mandatory = $True)]
    [String]$TextString,
    [parameter(Mandatory = $True, ParameterSetName = "WithSalt")]
    [ValidateRange(0, 3)]
    [Int]$Salt,
    [parameter(Mandatory = $False, ParameterSetName = "WithSalt")]
    [Switch]$Universal,
    [Switch]$Decrypt
  )
  Write-Verbose -Message "Enter Function Encrypt-WithCert"
  
  $Cert = Get-ChildItem -Path "Cert:\LocalMachine\Root\$($CertKey)"
  If ($PSCmdlet.ParameterSetName -eq "WithSalt")
  {
    If ($Universal.IsPresent)
    {
      $TmpNotBefore = $Cert.NotBefore.ToUniversalTime()
      $TmpNotAfter = $Cert.NotAfter.ToUniversalTime()
    }
    Else
    {
      $TmpNotBefore = $Cert.NotBefore
      $TmpNotAfter = $Cert.NotAfter
    }
    $SaltInit = @($TmpNotBefore.ToString("yyyyMMddhhmmss"), $TmpNotBefore.ToString("hhmmssyyyyMMdd"), $TmpNotAfter.ToString("yyyyMMddhhmmss"), $TmpNotAfter.ToString("hhmmssyyyyMMdd"))[$Salt]
  }
  Else
  {
    $SaltInit = $Cert.Subject
  }
  Encrypt-MySensitiveData -PassPhrase ($Cert.SerialNumber) -Salt $SaltInit -String $TextString -Decrypt:($Decrypt.IsPresent)
  
  Write-Verbose -Message "Exit Function Encrypt-WithCert"
}
#endregion function Encrypt-WithCert

#region function Encrypt-MyTextString
function Encrypt-MyTextString()
{
  <#
    .SYNOPSIS
      Encrypts a Password for use in a Script
    .DESCRIPTION
      Encrypts a Password for use in a Script
    .PARAMETER TextString
      Password to be Encrypted
    .PARAMETER ProtectionScope
      Who can Decrypt
        Currentuser = = Specific User
        LocalMachine = = Any User
    .PARAMETER EncryptKey
      Option Extra Encryption Security
    .PARAMETER Decrypt
    .EXAMPLE
      Encrypt-MyTextString -Password "Password"
    .NOTES
      Original Function By ken.sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$TextString,
    [ValidateSet("LocalMachine", "CurrentUser")]
    [String]$ProtectionScope = "CurrentUser",
    [String]$EncryptKey = $Null,
    [Switch]$Decrypt
  )
  Write-Verbose -Message "Enter Function Encrypt-MyTextString"

  if ([String]::IsNullOrEmpty(([Management.Automation.PSTypeName]::New("System.Security.Cryptography.ProtectedData")).Type))
  {
    [Void][System.Reflection.Assembly]::LoadWithPartialName("System.Security")
  }

  if ($PSBoundParameters.ContainsKey("EncryptKey"))
  {
    $OptionalEntropy = [System.Text.Encoding]::ASCII.GetBytes($EncryptKey)
  }
  else
  {
    $OptionalEntropy = $Null
  }

  if ($Decrypt.IsPresent)
  {
    $EncryptedData = [System.Convert]::FromBase64String($TextString)
    $DecryptedData = [System.Security.Cryptography.ProtectedData]::Unprotect($EncryptedData, $OptionalEntropy, ([System.Security.Cryptography.DataProtectionScope]$ProtectionScope))
    [System.Text.Encoding]::ASCII.GetString($DecryptedData)
  }
  else
  {
    $TempData = [System.Text.Encoding]::ASCII.GetBytes($TextString)
    $EncryptedData = [System.Security.Cryptography.ProtectedData]::Protect($TempData, $OptionalEntropy, ([System.Security.Cryptography.DataProtectionScope]$ProtectionScope))
    [System.Convert]::ToBase64String($EncryptedData)
  }

  Write-Verbose -Message "Exit Function Encrypt-MyTextString"
}
#endregion function Encrypt-MyTextString

#region function Decode-MySecureString
function Decode-MySecureString ()
{
  <#
    .SYNOPSIS
      Decodes a SecureString
    .DESCRIPTION
      Decodes a SecureString
    .PARAMETER SecureString
    .EXAMPLE
      Decode-MySecureString -SecureString [<String>]
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Security.SecureString]$SecureString
  )
  Write-Verbose -Message "Enter Function Get-EnvironmentVariable"

  [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString))

  Write-Verbose -Message "Exit Function Get-EnvironmentVariable"
}
#endregion function Decode-MySecureString

#endregion ******* Encrypt / Encode Data Functions ********

#region ******* Generic / General Functions ********

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

#region function Set-MyClipboard
Function Set-MyClipboard()
{
  <#
    .SYNOPSIS
      Copies Object Data to the ClipBoard
    .DESCRIPTION
      Copies Object Data to the ClipBoard
    .PARAMETER Items
    .PARAMETER Title
    .PARAMETER TitleFore
    .PARAMETER TitleBack
    .PARAMETER Property
    .PARAMETER PropertyFore
    .PARAMETER PropertyBack
    .PARAMETER RowFore
    .PARAMETER RowEvenBack
    .PARAMETER RowOddBack
    .EXAMPLE
      Set-MyClipBoard -Items $Items -Title "This is My Title" -Property "Property1", "Property2", "Property3"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Office")]
  Param (
    [parameter(Mandatory = $True, ValueFromPipeline = $True)]
    [Object[]]$Items,
    [String]$Title = "My Copied Data from PowerShell",
    [String]$TitleFore = "Black",
    [String]$TitleBack = "LightSteelBlue",
    [parameter(Mandatory = $True)]
    [String[]]$Properties,
    [String]$PropertyFore = "Black",
    [String]$PropertyBack = "PowderBlue",
    [String]$RowFore = "Black",
    [String]$RowEvenBack = "White",
    [String]$RowOddBack = "Gainsboro"
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Begin Block"
    
    # Init StringBuilding
    $HTMLStringBuilder = [System.Text.StringBuilder]::New()
    
    # Start HTML ClipBaord Data
    [Void]$HTMLStringBuilder.Append("Version:1.0`r`nStartHTML:000START`r`nEndHTML:00000END`r`nStartFragment:00FSTART`r`nEndFragment:0000FEND`r`n")
    [Void]$HTMLStringBuilder.Replace("000START", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<html><head><title>My Copied Data</title></head><body><!--StartFragment-->")
    [Void]$HTMLStringBuilder.Replace("00FSTART", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    # Table Style
    [Void]$HTMLStringBuilder.Append("<style>`r`n.Title{border: 1px solid black; border-collapse: collapse; font-weight: bold; text-align: center; color: $($TitleFore); background: $($TitleBack);}`r`n.Property{border: 1px solid black; border-collapse: collapse; font-weight: bold; text-align: center; color: $($PropertyFore); background: $($PropertyBack);}`r`n.Row0 {border: 1px solid black; border-collapse: collapse;color: $($RowFore); background: $($RowEvenBack);}`r`n.Row1 {border: 1px solid black; border-collapse: collapse; color: $($RowFore); background: $($RowOddBack);}`r`n</style>")
    
    # Start Build Table / Set Title
    [Void]$HTMLStringBuilder.Append("<table><tr><th class=Title aligh=center colspan=$($Properties.Count)>&nbsp;$($Title)&nbsp;</th></tr>")
    
    # Add Table Column / Property Names
    [Void]$HTMLStringBuilder.Append("<tr>$(($Properties | ForEach-Object -Process { "<td class=Property aligh=center>&nbsp;$($PSItem)&nbsp;</td>" }) -join '')</tr>")
    
    # Start Row Count
    $TmpRowCount = 0
    
    $TmpItemList = [System.Collections.ArrayList]::New()
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Begin Block"
  }
  Process
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Process Block"
    
    ForEach ($Item In $Items)
    {
      [Void]$HTMLStringBuilder.Append("<tr>$(((($Properties | ForEach-Object -Process { $Item.($PSItem) }) | ForEach-Object -Process { "<td class=Row$($TmpRowCount)>&nbsp;$($PSItem)&nbsp;</td>" }) -join ''))</tr>")
      [Void]$TmpItemList.Add(($Item | Select-Object -Property $Properties))
      $TmpRowCount = ($TmpRowCount + 1) % 2
    }
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Process Block"
  }
  End
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard End Block"
    
    # Close HTML Table
    [Void]$HTMLStringBuilder.Append("</table><br><br>")
    
    # Set End Clipboard Values
    [Void]$HTMLStringBuilder.Replace("0000FEND", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<!--EndFragment--></body></html>")
    [Void]$HTMLStringBuilder.Replace("00000END", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    [System.Windows.Forms.Clipboard]::Clear()
    $DataObject = [System.Windows.Forms.DataObject]::New("Text", ($TmpItemList | Select-Object -Property $Properties | ConvertTo-Csv -NoTypeInformation | Out-String))
    $DataObject.SetData("HTML Format", $HTMLStringBuilder.ToString())
    [System.Windows.Forms.Clipboard]::SetDataObject($DataObject)
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Function Set-MyClipboard End Block"
  }
}
#endregion function Set-MyClipboard

#region function Send-MyEMail
function Send-MyEMail()
{
  <#
    .SYNOPSIS
      Sends an E-mail
    .DESCRIPTION
      Sends an E-mail
    .PARAMETER SMTPServer
    .PARAMETER SMTPPort
    .PARAMETER To
    .PARAMETER From
    .PARAMETER Subject
    .PARAMETER Body
    .PARAMETER MsgFile
    .PARAMETER IsHTML
    .PARAMETER CC
    .PARAMETER BCC
    .PARAMETER Attachments
    .PARAMETER Priority
    .EXAMPLE
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$SMTPServer = [MyConfig]::SMTPServer,
    [Int]$SMTPPort = [MyConfig]::SMTPPort,
    [parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Enter To")]
    [System.Net.Mail.MailAddress[]]$To,
    [parameter(Mandatory = $True, HelpMessage = "Enter From")]
    [System.Net.Mail.MailAddress]$From,
    [parameter(Mandatory = $True, HelpMessage = "Enter Subject")]
    [String]$Subject,
    [parameter(Mandatory = $True, HelpMessage = "Enter Message Text")]
    [String]$Body,
    [Switch]$IsHTML,
    [System.Net.Mail.MailAddress[]]$CC,
    [System.Net.Mail.MailAddress[]]$BCC,
    [System.Net.Mail.Attachment[]]$Attachment,
    [ValidateSet("Low", "Normal", "High")]
    [System.Net.Mail.MailPriority]$Priority = "Normal"
  )
  Begin 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail Begin"

    $MyMessage = [System.Net.Mail.MailMessage]::New()
    $MyMessage.From = $From
    $MyMessage.Subject = $Subject
    $MyMessage.IsBodyHtml = $IsHTML
    $MyMessage.Priority = $Priority

    if ($PSBoundParameters.ContainsKey("CC"))
    {
      foreach ($SendCC in $CC) 
      {
        $MyMessage.CC.Add($SendCC)
      }
    }

    if ($PSBoundParameters.ContainsKey("BCC"))
    {
      foreach ($SendBCC in $BCC) 
      {
        $MyMessage.BCC.Add($SendBCC)
      }
    }

    if ([System.IO.File]::Exists($Body)) 
    {
      $MyMessage.Body = $([System.IO.File]::ReadAllText($Body))
    }
    else
    {
      $MyMessage.Body = $Body
    }

    if ($PSBoundParameters.ContainsKey("Attachment"))
    {
      foreach ($AttachedFile in $Attachment) 
      {
        $MyMessage.Attachments.Add($AttachedFile)
      }
    }

    Write-Verbose -Message "Exit Function Send-MyEMail Begin"
  }
  Process 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail Process"

    $MyMessage.To.Clear()
    foreach ($SendTo in $To) 
    {
      $MyMessage.To.Add($SendTo)
    }

    $SMTPClient = [System.Net.Mail.SmtpClient]::New($SMTPServer, $SMTPPort)
    $SMTPClient.Send($MyMessage)

    Write-Verbose -Message "Exit Function Send-MyEMail Process"
  }
  End 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail End"
    Write-Verbose -Message "Exit Function Send-MyEMail End"
  }
}
#endregion function Send-MyEMail

#region function Show-MyWebReport
function Show-MyWebReport
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Show-MyWebReport -Value "String"
    .NOTES
      Original Function By Ken Sweet

      10/5/2021 - Initial Release
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$ReportURL
  )
  Write-Verbose -Message "Enter Function Show-MyWebReport"

  if ([String]::IsNullOrEmpty(([MyConfig]::EdgePath)))
  {
    if (-not [String]::IsNullOrEmpty(([MyConfig]::ChromePath)))
    {
      Start-Process -FilePath ([MyConfig]::ChromePath) -ArgumentList "--app=`"$($ReportURL)`""
    }
  }
  else
  {
    Start-Process -FilePath ([MyConfig]::EdgePath) -ArgumentList "--app=`"$($ReportURL)`""
  }

  Write-Verbose -Message "Exit Function Show-MyWebReport"
}
#endregion function Show-MyWebReport

#region class MyConCommand
class MyConCommand
{
  [Int]$ExitCode
  [String]$OutputTxt
  [String]$ErrorMsg
  
  MyConCommand ([Int]$ExitCode, [String]$OutputTxt, [String]$ErrorMsg)
  {
    $This.ExitCode = $ExitCode
    $This.OutputTxt = $OutputTxt
    $This.ErrorMsg = $ErrorMsg
  }
}
#endregion class MyConCommand

#region function Invoke-MyConCommand
function Invoke-MyConCommand ()
{
  <#
    .SYNOPSIS
      Invokes a Console Command and Returns the Exit Code
    .DESCRIPTION
      Invokes a Console Command and Returns the Exit Code
    .PARAMETER Command
      Command to be Executed
    .PARAMETER Parameters
      Command line Parameters
    .EXAMPLE
      Invoke-MyConCommand -Command "C:\Windows\System32\cmd.exe" -Parameters "/c Exit 1"
    .NOTES
      Original Function By Ken Sweet
      
      09/19/2023 - Initial Release
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Command,
    [String]$Parameters = $Null
  )
  Write-Verbose -Message "Enter Function Invoke-MyConCommand"
  
  if ([System.IO.File]::Exists($Command))
  {
    $PSI = [System.Diagnostics.ProcessStartInfo]::New($Command, $Parameters)
    $PSI.UseShellExecute = $False
    $PSI.RedirectStandardError = $True
    $PSI.RedirectStandardOutput = $True
    Try
    {
      $Out = [System.Diagnostics.Process]::Start($PSI)
      $Out.WaitForExit()
      [MyConCommand]::New($Out.ExitCode, $Out.StandardOutput.ReadToEnd(), $Out.StandardError.ReadToEnd())
    }
    Catch
    {
      [MyConCommand]::New(-2, $Null, $Error[0].Message)
    }
  }
  else
  {
    [MyConCommand]::New(-1, $Null, "Command was not Found")
  }
  
  Write-Verbose -Message "Exit Function Invoke-MyConCommand"
}
#endregion function Invoke-MyConCommand

#region function Test-MyClassLoaded
function Test-MyClassLoaded()
{
  <#
    .SYNOPSIS
      Test if Custom Class is Loaded
    .DESCRIPTION
      Test if Custom Class is Loaded
    .PARAMETER Name
      Name of Custom Class
    .EXAMPLE
      $IsLoaded = Test-MyClassLoaded -Name "CustomClass"
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "Default")]
    [String]$Name
  )
  Write-Verbose -Message "Enter Function Test-MyClassLoaded"

  (-not [String]::IsNullOrEmpty(([Management.Automation.PSTypeName]::New($Name)).Type))

  Write-Verbose -Message "Exit Function Test-MyClassLoaded"
}
#endregion function Test-MyClassLoaded

#region function New-MyComObject
function New-MyComObject()
{
  <#
    .SYNOPSIS
      Creates Local and Remote COMObjects
    .DESCRIPTION
      Creates Local and Remote COMObjects
    .PARAMETER ComputerName
    .PARAMETER ComObject
    .EXAMPLE
      New-MyComObject -ComObject <String>
    .EXAMPLE
      New-MyComObject -ComputerName <String> -ComObject <String>
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$ComputerName = [System.Environment]::MachineName,
    [parameter(Mandatory = $True)]
    [String]$COMObject
  )
  Write-Verbose -Message "Enter Function New-MyComObject"

  [Activator]::CreateInstance([Type]::GetTypeFromProgID($COMObject, $ComputerName))

  Write-Verbose -Message "Exit Function New-MyComObject"
}
#endregion function New-MyComObject

#region function ConvertTo-MyIconImage
function ConvertTo-MyIconImage()
{
  <#
    .SYNOPSIS
      Convert Base 64 Encoded Imagesback to Icon / Image
    .DESCRIPTION
      Convert Base 64 Encoded Imagesback to Icon / Image
    .PARAMETER EncodedImage
    .PARAMETER Image
    .EXAMPLE
      $NewItem = ConvertTo-MyIconImage -EncodedImage $EncodedImage
    .EXAMPLE
      $NewItem = ConvertTo-MyIconImage -EncodedImage $EncodedImage -Image
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$EncodedImage,
    [Switch]$Image
  )
  Write-Verbose -Message "Enter Function ConvertTo-MyIconImage"

  if ($Image.IsPresent)
  {
    [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($EncodedImage)))
  }
  else
  {
    [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($EncodedImage)))
  }

  Write-Verbose -Message "Exit Function ConvertTo-MyIconImage"
}
#endregion function ConvertTo-MyIconImage

#region function Send-MyTextMessage
function Send-MyTextMessage ()
{
  <#
    .SYNOPSIS
      Send Text Message to Remote or Local Computer or IP Address
    .DESCRIPTION
      Send Text Message to Remote or Local Computer or IP Address
    .PARAMETER ComputerName
    .PARAMETER IPAddress
      255.255.255.255 = Broadcast
    .PARAMETER Message
    .PARAMETER Port
    .EXAMPLE
      Send-MyTextMessage -Mesage [<String>]
    .NOTES
      Original function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "IPAddress")]
  param (
    [parameter(Mandatory = $False, ParameterSetName = "ComputerName")]
    [String]$ComputerName = [System.Environment]::MachineName,
    [parameter(Mandatory = $False, ParameterSetName = "IPAddress")]
    [System.Net.IPAddress]$IPAddress = "127.0.0.1",
    [parameter(Mandatory = $False)]
    [String]$Message = "This is My Message",
    [int]$Port = 2500
  )
  Write-Verbose -Message "Enter function Send-MyTextMessage"

  if ($PSCmdlet.ParameterSetName -eq "IPAddress")
  {
    $RemoteClient = [System.Net.IPEndPoint]::New($IPAddress, $Port)
  }
  else
  {
    $RemoteClient = [System.Net.IPEndPoint]::New((([System.Net.Dns]::GetHostByName($ComputerName)).AddressList[0]), $Port)
  }
  $MessageBytes = [Text.Encoding]::ASCII.GetBytes("$($Message)")
  $UDPClient = [System.Net.Sockets.UdpClient]::New()
  $UDPClient.Send($MessageBytes, $MessageBytes.Length, $RemoteClient)
  $UDPClient.Close()
  $UDPClient.Dispose()

  Write-Verbose -Message "Exit function Send-MyTextMessage"
}
#endregion function Send-MyTextMessage

#region function Listen-MyTextMessage
function Listen-MyTextMessage ()
{
  <#
    .SYNOPSIS
      Listen for Text Message from Remote or Local Computer
    .DESCRIPTION
      Listen for Text Message from Remote or Local Computer
    .PARAMETER ComputerName
    .PARAMETER IPAddress
      0.0.0.0 = Any
    .PARAMETER Port
    .EXAMPLE
      Listen-MyTextMessage
    .NOTES
      Original function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "IPAddress")]
  param (
    [parameter(Mandatory = $False, ParameterSetName = "ComputerName")]
    [String]$ComputerName = [System.Environment]::MachineName,
    [parameter(Mandatory = $False, ParameterSetName = "IPAddress")]
    [System.Net.IPAddress]$IPAddress = "127.0.0.1",
    [int]$Port = 2500
  )
  Write-Verbose -Message "Enter function Listen-MyTextMessage"

  if ($PSCmdlet.ParameterSetName -eq "IPAddress")
  {
    $RemoteClient = [System.Net.IPEndPoint]::New($IPAddress, $Port)
  }
  else
  {
    $RemoteClient = [System.Net.IPEndPoint]::New((([System.Net.Dns]::GetHostByName($ComputerName)).AddressList[0]), $Port)
  }
  $UDPClient = [System.Net.Sockets.UdpClient]::New($Port)
  Do
  {
    $TempRemoteClient = $RemoteClient
    $Message = $UDPClient.Receive([ref]$TempRemoteClient)
    $DecodedMessage = [Text.Encoding]::ASCII.GetString($Message)
    Write-Host -Object  "Message From: $($TempRemoteClient.Address) - $($DecodedMessage)"
  } While ($True -and ($DecodedMessage -ne "Exit"))

  Write-Verbose -Message "Exit function Listen-MyTextMessage"
}
#endregion function Listen-MyTextMessage

#region ******** class TestMyWorkstation ********
class TestMyWorkstation
{
  [String]$ComputerName = [Environment]::MachineName
  [String]$FQDN = [Environment]::MachineName
  [Bool]$Found = $False
  [String]$UserName = ""
  [String]$Domain = ""
  [Bool]$DomainMember = $False
  [int]$ProductType = 0
  [String]$Manufacturer = ""
  [String]$Model = ""
  [Bool]$IsMobile = $False
  [String]$SerialNumber = ""
  [Long]$Memory = 0
  [String]$OperatingSystem = ""
  [String]$BuildNumber = ""
  [String]$Version = ""
  [String]$ServicePack = ""
  [String]$Architecture = ""
  [Bool]$Is64Bit = $False;
  [DateTime]$LocalDateTime = [DateTime]::MinValue
  [DateTime]$InstallDate = [DateTime]::MinValue
  [DateTime]$LastBootUpTime = [DateTime]::MinValue
  [String]$IPAddress = ""
  [String]$Status = "Off-Line"
  [DateTime]$StartTime = [DateTime]::Now
  [DateTime]$EndTime = [DateTime]::Now

  TestMyWorkstation ([String]$IPAddress)
  {
    $This.IPAddress = $IPAddress
    $This.Status = "On-Line"
  }

  [Void] AddComputerSystem ([String]$TestName, [String]$ComputerName, [Bool]$DomainMember, [String]$Domain, [String]$Manufacturer, [String]$Model, [String]$UserName, [Long]$Memory)
  {
    $This.ComputerName = "$($ComputerName)".ToLower()
    $This.DomainMember = $DomainMember
    $This.Domain = "$($Domain)".ToLower()
    if ($DomainMember)
    {
      $This.FQDN = "$($ComputerName).$($Domain)".ToLower()
    }
    $This.Manufacturer = $Manufacturer
    $This.Model = $Model
    $This.UserName = $UserName
    $This.Memory = $Memory
    $This.Found = ($ComputerName -eq @($TestName.Split("."))[0])
  }

  [Void] AddOperatingSystem ([int]$ProductType, [String]$OperatingSystem, [String]$ServicePack, [String]$BuildNumber, [String]$Version, [String]$Architecture, [DateTime]$LocalDateTime, [DateTime]$InstallDate, [DateTime]$LastBootUpTime)
  {
    $This.ProductType = $ProductType
    $This.OperatingSystem = $OperatingSystem
    $This.ServicePack = $ServicePack
    $This.BuildNumber = $BuildNumber
    $This.Version = $Version
    $This.Architecture = $Architecture
    $This.Is64Bit = ($Architecture -eq "64-bit")
    $This.LocalDateTime = $LocalDateTime
    $This.InstallDate = $InstallDate
    $This.LastBootUpTime = $LastBootUpTime
  }

  [Void] AddSerialNumber ([String]$SerialNumber)
  {
    $This.SerialNumber = $SerialNumber
  }

  [Void] AddIsMobile ([Long[]]$ChassisTypes)
  {
    $This.IsMobile = (@(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) -contains $ChassisTypes[0])
  }

  [Void] UpdateStatus ([String]$Status)
  {
    $This.Status = $Status
  }

  [TestMyWorkstation] SetEndTime ()
  {
    $This.EndTime = [DateTime]::Now
    return $This
  }

  [TimeSpan] GetRunTime ()
  {
    return ($This.EndTime - $This.StartTime)
  }
}
#endregion ******** class TestMyWorkstation ********

#region function Test-MyWorkstation
function Test-MyWorkstation()
{
  <#
    .SYNOPSIS
      Verify Remote Workstation is the Correct One
    .DESCRIPTION
      Verify Remote Workstation is the Correct One
    .PARAMETER ComputerName
      Name of the Computer to Verify
    .PARAMETER Credential
      Credentials to use when connecting to the Remote Computer
    .PARAMETER Serial
      Return Serial Number
    .PARAMETER Mobile
      Check if System is Desktop / Laptop
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Test-MyWorkstation -ComputerName "MyWorkstation"
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
    [String[]]$ComputerName = [System.Environment]::MachineName,
    [PSCredential]$Credential,
    [Switch]$Serial,
    [Switch]$Mobile
  )
  begin
  {
    Write-Verbose -Message "Enter Function Test-MyWorkstation"

    # Default Common Get-WmiObject Options
    if ($PSBoundParameters.ContainsKey("Credential"))
    {
      $Params = @{
        "ComputerName" = $Null;
        "Credential"   = $Credential
      }
    }
    else
    {
      $Params = @{
        "ComputerName" = $Null
      }
    }
  }
  process
  {
    Write-Verbose -Message "Enter Function Test-MyWorkstation - Process"

    foreach ($Computer in $ComputerName)
    {
      if ($Computer -match "^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$")
      {
        try
        {
          # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not
          $IPAddresses = @([System.Net.Dns]::GetHostAddresses($Computer) | Where-Object -FilterScript { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)
          :FoundMyWork foreach ($IPAddress in $IPAddresses)
          {
            if ([System.Net.NetworkInformation.Ping]::New().Send($IPAddress).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)
            {
              $Params.ComputerName = $IPAddress
              
              # Start Setting Return Values as they are Found
              $VerifyObject = [TestMyWorkstation]::New($IPAddress)
              
              # Get ComputerSystem
              [Void]($MyCompData = Get-WmiObject @Params -Class Win32_ComputerSystem)
              $VerifyObject.AddComputerSystem($Computer, ($MyCompData.Name), ($MyCompData.PartOfDomain), ($MyCompData.Domain), ($MyCompData.Manufacturer), ($MyCompData.Model), ($MyCompData.UserName), ($MyCompData.TotalPhysicalMemory))
              $MyCompData.Dispose()
              
              # Verify Remote Computer is the Connect Computer, No need to get any more information
              if ($VerifyObject.Found)
              {
                # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                [Void]($MyOSData = Get-WmiObject @Params -ClassName Win32_OperatingSystem)
                $VerifyObject.AddOperatingSystem(($MyOSData.ProductType), ($MyOSData.Caption), ($MyOSData.CSDVersion), ($MyOSData.BuildNumber), ($MyOSData.Version), ($MyOSData.OSArchitecture), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LocalDateTime)), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.InstallDate)), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LastBootUpTime)))
                $MyOSData.Dispose()
                
                # Optional SerialNumber Job
                if ($Serial.IsPresent)
                {
                  # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                  [Void]($MyBIOSData = Get-WmiObject @Params -ClassName Win32_Bios)
                  $VerifyObject.AddSerialNumber($MyBIOSData.SerialNumber)
                  $MyBIOSData.Dispose()
                }
                
                # Optional Mobile / ChassisType Job
                if ($Mobile.IsPresent)
                {
                  # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                  [Void]($MyChassisData = Get-WmiObject @Params -ClassName Win32_SystemEnclosure)
                  $VerifyObject.AddIsMobile($MyChassisData.ChassisTypes)
                  $MyChassisData.Dispose()
                }
              }
              else
              {
                $VerifyObject.UpdateStatus("Wrong Workstation Name")
              }
              # Beak out of Loop, Verify was a Success no need to try other IP Address if any
              break FoundMyWork
            }
          }
        }
        catch
        {
          # Workstation Not in DNS
          $VerifyObject.UpdateStatus("Workstation Not in DNS")
        }
      }
      else
      {
        $VerifyObject.UpdateStatus("Invalid Computer Name")
      }

      # Set End Time and Return Results
      $VerifyObject.SetEndTime()
    }
    Write-Verbose -Message "Exit Function Test-MyWorkstation - Process"
  }
  end
  {
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Verbose -Message "Exit Function Test-MyWorkstation"
  }
}
#endregion function Test-MyWorkstation

#region class MyWorkstationInfo
Class MyWorkstationInfo
{
  [String]$ComputerName = [Environment]::MachineName
  [String]$FQDN = [Environment]::MachineName
  [Bool]$Found = $False
  [String]$UserName = ""
  [String]$Domain = ""
  [Bool]$DomainMember = $False
  [int]$ProductType = 0
  [String]$Manufacturer = ""
  [String]$Model = ""
  [Bool]$IsMobile = $False
  [String]$SerialNumber = ""
  [Long]$Memory = 0
  [String]$OperatingSystem = ""
  [String]$BuildNumber = ""
  [String]$Version = ""
  [String]$ServicePack = ""
  [String]$Architecture = ""
  [Bool]$Is64Bit = $False;
  [DateTime]$LocalDateTime = [DateTime]::MinValue
  [DateTime]$InstallDate = [DateTime]::MinValue
  [DateTime]$LastBootUpTime = [DateTime]::MinValue
  [String]$IPAddress = ""
  [String]$Status = "Off-Line"
  [DateTime]$StartTime = [DateTime]::Now
  [DateTime]$EndTime = [DateTime]::Now
  
  MyWorkstationInfo ([String]$ComputerName)
  {
    $This.ComputerName = $ComputerName.ToUpper()
    $This.FQDN = $ComputerName.ToUpper()
    $This.Status = "On-Line"
  }
  
  [Void] AddComputerSystem ([String]$TestName, [String]$IPAddress, [String]$ComputerName, [Bool]$DomainMember, [String]$Domain, [String]$Manufacturer, [String]$Model, [String]$UserName, [Long]$Memory)
  {
    $This.IPAddress = $IPAddress
    $This.ComputerName = "$($ComputerName)".ToUpper()
    $This.DomainMember = $DomainMember
    $This.Domain = "$($Domain)".ToUpper()
    If ($DomainMember)
    {
      $This.FQDN = "$($ComputerName).$($Domain)".ToUpper()
    }
    $This.Manufacturer = $Manufacturer
    $This.Model = $Model
    $This.UserName = $UserName
    $This.Memory = $Memory
    $This.Found = ($ComputerName -eq @($TestName.Split("."))[0])
  }
  
  [Void] AddOperatingSystem ([int]$ProductType, [String]$OperatingSystem, [String]$ServicePack, [String]$BuildNumber, [String]$Version, [String]$Architecture, [DateTime]$LocalDateTime, [DateTime]$InstallDate, [DateTime]$LastBootUpTime)
  {
    $This.ProductType = $ProductType
    $This.OperatingSystem = $OperatingSystem
    $This.ServicePack = $ServicePack
    $This.BuildNumber = $BuildNumber
    $This.Version = $Version
    $This.Architecture = $Architecture
    $This.Is64Bit = ($Architecture -eq "64-bit")
    $This.LocalDateTime = $LocalDateTime
    $This.InstallDate = $InstallDate
    $This.LastBootUpTime = $LastBootUpTime
  }
  
  [Void] AddSerialNumber ([String]$SerialNumber)
  {
    $This.SerialNumber = $SerialNumber
  }
  
  [Void] AddIsMobile ([Long[]]$ChassisTypes)
  {
    $This.IsMobile = (@(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) -contains $ChassisTypes[0])
  }
  
  [Void] UpdateStatus ([String]$Status)
  {
    $This.Status = $Status
  }
  
  [MyWorkstationInfo] SetEndTime ()
  {
    $This.EndTime = [DateTime]::Now
    Return $This
  }
  
  [TimeSpan] GetRunTime ()
  {
    Return ($This.EndTime - $This.StartTime)
  }
}
#endregion class MyWorkstationInfo

#region function Get-MyWorkstationInfo
Function Get-MyWorkstationInfo()
{
  <#
    .SYNOPSIS
      Verify Remote Workstation is the Correct One
    .DESCRIPTION
      Verify Remote Workstation is the Correct One
    .PARAMETER ComputerName
      Name of the Computer to Verify
    .PARAMETER Credential
      Credentials to use when connecting to the Remote Computer
    .PARAMETER Serial
      Return Serial Number
    .PARAMETER Mobile
      Check if System is Desktop / Laptop
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Get-MyWorkstationInfo -ComputerName "MyWorkstation"
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  Param (
    [parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
    [String[]]$ComputerName = [System.Environment]::MachineName,
    [PSCredential]$Credential,
    [Switch]$Serial,
    [Switch]$Mobile
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Get-MyWorkstationInfo"
    
    # Default Common Get-WmiObject Options
    If ($PSBoundParameters.ContainsKey("Credential"))
    {
      $Params = @{
        "ComputerName" = $Null;
        "Credential"   = $Credential
      }
    }
    Else
    {
      $Params = @{
        "ComputerName" = $Null
      }
    }
  }
  Process
  {
    Write-Verbose -Message "Enter Function Get-MyWorkstationInfo - Process"
    
    ForEach ($Computer In $ComputerName)
    {
      # Start Setting Return Values as they are Found
      $VerifyObject = [MyWorkstationInfo]::New($Computer)
      
      # Validate ComputerName
      If ($Computer -match "^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$")
      {
        Try
        {
          # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not
          $IPAddresses = @([System.Net.Dns]::GetHostAddresses($Computer) | Where-Object -FilterScript { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)
          :FoundMyWork ForEach ($IPAddress In $IPAddresses)
          {
            If ([System.Net.NetworkInformation.Ping]::New().Send($IPAddress).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)
            {
              # Set Default Parms
              $Params.ComputerName = $IPAddress
              
              # Get ComputerSystem
              [Void]($MyCompData = Get-WmiObject @Params -Class Win32_ComputerSystem)
              $VerifyObject.AddComputerSystem($Computer, $IPAddress, ($MyCompData.Name), ($MyCompData.PartOfDomain), ($MyCompData.Domain), ($MyCompData.Manufacturer), ($MyCompData.Model), ($MyCompData.UserName), ($MyCompData.TotalPhysicalMemory))
              $MyCompData.Dispose()
              
              # Verify Remote Computer is the Connect Computer, No need to get any more information
              If ($VerifyObject.Found)
              {
                # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                [Void]($MyOSData = Get-WmiObject @Params -Class Win32_OperatingSystem)
                $VerifyObject.AddOperatingSystem(($MyOSData.ProductType), ($MyOSData.Caption), ($MyOSData.CSDVersion), ($MyOSData.BuildNumber), ($MyOSData.Version), ($MyOSData.OSArchitecture), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LocalDateTime)), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.InstallDate)), ([System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LastBootUpTime)))
                $MyOSData.Dispose()
                
                # Optional SerialNumber Job
                If ($Serial.IsPresent)
                {
                  # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                  [Void]($MyBIOSData = Get-WmiObject @Params -Class Win32_Bios)
                  $VerifyObject.AddSerialNumber($MyBIOSData.SerialNumber)
                  $MyBIOSData.Dispose()
                }
                
                # Optional Mobile / ChassisType Job
                If ($Mobile.IsPresent)
                {
                  # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                  [Void]($MyChassisData = Get-WmiObject @Params -Class Win32_SystemEnclosure)
                  $VerifyObject.AddIsMobile($MyChassisData.ChassisTypes)
                  $MyChassisData.Dispose()
                }
              }
              Else
              {
                $VerifyObject.UpdateStatus("Wrong Workstation Name")
              }
              # Beak out of Loop, Verify was a Success no need to try other IP Address if any
              Break FoundMyWork
            }
          }
        }
        Catch
        {
          # Workstation Not in DNS
          $VerifyObject.UpdateStatus("Workstation Not in DNS")
        }
      }
      Else
      {
        $VerifyObject.UpdateStatus("Invalid Computer Name")
      }
      
      # Set End Time and Return Results
      $VerifyObject.SetEndTime()
    }
    Write-Verbose -Message "Exit Function Get-MyWorkstationInfo - Process"
  }
  End
  {
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Verbose -Message "Exit Function Get-MyWorkstationInfo"
  }
}
#endregion function Get-MyWorkstationInfo

#region function Get-MyNetAdapterConStatus
function Get-MyNetAdapterConStatus ()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .EXAMPLE
      Get-MyNetAdapterConStatus -Value "String"
    .NOTES
      Original Function By Ken Sweet

      2022/07/05 - Initial Release
  #>
  [CmdletBinding()]
  param (
    [String]$ComputerName = [System.Environment]::MachineName,
    [PSCredential]$Credential = [PSCredential]::Empty
  )
  Write-Verbose -Message "Enter Function Get-MyNetAdapterConStatus"

  $PhysicalMediumTypeList = @(Get-WmiObject -ComputerName $ComputerName -Credential $Credential -Namespace "Root\WMI" -Query "Select InstanceName, NdisPhysicalMediumType From MSNdis_PhysicalMediumType Where Active = 1" | Select-Object -Property InstanceName, NdisPhysicalMediumType)
  $NetworkAdapters = @(Get-WmiObject -ComputerName $ComputerName -Credential $Credential -Namespace "Root\CimV2" -Query "Select Name from Win32_NetworkAdapter Where NetConnectionStatus = 2" | Select-Object -ExpandProperty Name)
  [PSCustomObject][ordered]@{
    "Wired" = (@($PhysicalMediumTypeList | Where-Object -FilterScript { ($PSItem.NdisPhysicalMediumType -eq 0) -and ($PSItem.InstanceName -in $NetworkAdapters) }).Count -gt 0)
    "Wireless" = (@($PhysicalMediumTypeList | Where-Object -FilterScript { ($PSItem.NdisPhysicalMediumType -eq 9) -and ($PSItem.InstanceName -in $NetworkAdapters) }).Count -gt 0)
  }

  Write-Verbose -Message "Exit Function Get-MyNetAdapterConStatus"
}
#endregion function Get-MyNetAdapterConStatus

#endregion ******* Generic / General Functions ********

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

#endregion ================ My Custom Functions ================

#region >>>>>>>>>>>>>>>> FCG Common Dialogs <<<<<<<<<<<<<<<<

#region function Show-UserAlertDialog
Function Show-UserAlertDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-UserAlertDialog
    .DESCRIPTION
      Shows Show-UserAlertDialog
    .PARAMETER DialogTitle
    .PARAMETER Title
    .PARAMETER Message
    .PARAMETER Width
    .PARAMETER MsgType
    .EXAMPLE
      $Return = Show-UserAlertDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [parameter(Mandatory = $True)]
    [String]$Title,
    [parameter(Mandatory = $True)]
    [String]$Message,
    [Int]$Width = 25,
    [ValidateSet("Good", "Warn", "Error", "Info")]
    [String]$MsgType = "Info"
  )
  Write-Verbose -Message "Enter Function Show-UserAlertDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** $UserAlertDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # $UserAlertDialog Form
  # ************************************************
  #region $UserAlertDialogForm = [System.Windows.Forms.Form]::New()
  $UserAlertDialogForm = [System.Windows.Forms.Form]::New()
  $UserAlertDialogForm.BackColor = [MyConfig]::Colors.TextBack
  $UserAlertDialogForm.Font = [MyConfig]::Font.Regular
  $UserAlertDialogForm.ForeColor = [MyConfig]::Colors.TextFore
  $UserAlertDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $UserAlertDialogForm.Icon = $FCGForm.Icon
  $UserAlertDialogForm.KeyPreview = $True
  $UserAlertDialogForm.MaximizeBox = $False
  $UserAlertDialogForm.MinimizeBox = $False
  $UserAlertDialogForm.Name = "UserAlertDialogForm"
  $UserAlertDialogForm.Owner = $FCGForm
  $UserAlertDialogForm.ShowInTaskbar = $False
  $UserAlertDialogForm.Size = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * 25))
  $UserAlertDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $UserAlertDialogForm.Tag = @{ "Cancel" = $False; "Pause" = $False }
  $UserAlertDialogForm.Text = $DialogTitle
  #endregion $UserAlertDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-UserAlertDialogFormKeyDown ********
  Function Start-UserAlertDialogFormKeyDown
  {
  <#
    .SYNOPSIS
      KeyDown Event for the UserAlertDialog Form Control
    .DESCRIPTION
      KeyDown Event for the UserAlertDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-UserAlertDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$UserAlertDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $UserAlertDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$UserAlertDialogForm"
  }
  #endregion ******** Function Start-UserAlertDialogFormKeyDown ********
  $UserAlertDialogForm.add_KeyDown({ Start-UserAlertDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-UserAlertDialogFormShown ********
  Function Start-UserAlertDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the $UserAlertDialog Form Control
      .DESCRIPTION
        Shown Event for the $UserAlertDialog Form Control
      .PARAMETER Sender
         The Form Control that fired the Shown Event
      .PARAMETER EventArg
         The Event Arguments for the Form Shown Event
      .EXAMPLE
         Start-UserAlertDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$UserAlertDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$UserAlertDialogForm"
  }
  #endregion ******** Function Start-UserAlertDialogFormShown ********
  $UserAlertDialogForm.add_Shown({ Start-UserAlertDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for $UserAlertDialog Form ********
  
  # ************************************************
  # $UserAlertDialogMain Panel
  # ************************************************
  #region $UserAlertDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $UserAlertDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $UserAlertDialogForm.Controls.Add($UserAlertDialogMainPanel)
  $UserAlertDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $UserAlertDialogMainPanel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $UserAlertDialogMainPanel.Name = "UserAlertDialogMainPanel"
  $UserAlertDialogMainPanel.Size = [System.Drawing.Size]::New(($UserAlertDialogForm.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($UserAlertDialogForm.ClientSize.Height - ([MyConfig]::FormSpacer * 2)))
  #endregion $UserAlertDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $UserAlertDialogMainPanel Controls ********
    
  #region $UserAlertDialogMainTitleLabel = [System.Windows.Forms.Label]::New()
  $UserAlertDialogMainTitleLabel = [System.Windows.Forms.Label]::New()
  $UserAlertDialogMainPanel.Controls.Add($UserAlertDialogMainTitleLabel)
  $UserAlertDialogMainTitleLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  
  Switch ($MsgType)
  {
    "Info"
    {
      $UserAlertDialogMainTitleLabel.BackColor = [MyConfig]::Colors.TextInfo
      Break
    }
    "Good"
    {
      $UserAlertDialogMainTitleLabel.BackColor = [MyConfig]::Colors.TextGood
      Break
    }
    "Warn"
    {
      $UserAlertDialogMainTitleLabel.BackColor = [MyConfig]::Colors.TextWarn
      Break
    }
    "Error"
    {
      $UserAlertDialogMainTitleLabel.BackColor = [MyConfig]::Colors.TextBad
      Break
    }
  }
  $UserAlertDialogMainTitleLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $UserAlertDialogMainTitleLabel.Font = [MyConfig]::Font.Title
  $UserAlertDialogMainTitleLabel.ForeColor = [MyConfig]::Colors.TextBack
  $UserAlertDialogMainTitleLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $UserAlertDialogMainTitleLabel.Name = "UserAlertDialogMainTitleLabel"
  $UserAlertDialogMainTitleLabel.Size = [System.Drawing.Size]::New(($UserAlertDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), $UserAlertDialogMainTitleLabel.PreferredHeight)
  $UserAlertDialogMainTitleLabel.Text = $Title
  $UserAlertDialogMainTitleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  #endregion $UserAlertDialogMainTitleLabel = [System.Windows.Forms.Label]::New()
  
  #region $UserAlertDialogMainMessageLabel = [System.Windows.Forms.Label]::New()
  $UserAlertDialogMainMessageLabel = [System.Windows.Forms.Label]::New()
  $UserAlertDialogMainPanel.Controls.Add($UserAlertDialogMainMessageLabel)
  $UserAlertDialogMainMessageLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $UserAlertDialogMainMessageLabel.BackColor = [MyConfig]::Colors.TextBack
  $UserAlertDialogMainMessageLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $UserAlertDialogMainMessageLabel.Font = [MyConfig]::Font.Bold
  $UserAlertDialogMainMessageLabel.ForeColor = [MyConfig]::Colors.TextFore
  $UserAlertDialogMainMessageLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($UserAlertDialogMainTitleLabel.Bottom + [MyConfig]::FormSpacer))
  $UserAlertDialogMainMessageLabel.Name = "UserAlertDialogMainMessageLabel"
  $UserAlertDialogMainMessageLabel.Size = [System.Drawing.Size]::New($UserAlertDialogMainTitleLabel.Width, ($UserAlertDialogMainTitleLabel.Width - ($UserAlertDialogMainMessageLabel.Top * 3)))
  $UserAlertDialogMainMessageLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $UserAlertDialogMainMessageLabel.Text = $Message
  #endregion $UserAlertDialogMainMessageLabel = [System.Windows.Forms.Label]::New()
  
  $UserAlertDialogMainPanel.ClientSize = [System.Drawing.Size]::New($UserAlertDialogMainPanel.ClientSize.Width, ($UserAlertDialogMainMessageLabel.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $UserAlertDialogMainPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  # ************************************************
  # $UserAlertDialogBtm Panel
  # ************************************************
  #region $UserAlertDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $UserAlertDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $UserAlertDialogForm.Controls.Add($UserAlertDialogBtmPanel)
  $UserAlertDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $UserAlertDialogBtmPanel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, $UserAlertDialogMainPanel.Bottom)
  $UserAlertDialogBtmPanel.Name = "UserAlertDialogBtmPanel"
  $UserAlertDialogBtmPanel.Text = "$UserAlertDialogBtmPanel"
  #endregion $UserAlertDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $UserAlertDialogBtmPanel Controls ********
  
  $NumButtons = 3
  $TempSpace = [Math]::Floor($UserAlertDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $UserAlertDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $UserAlertDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $UserAlertDialogBtmPanel.Controls.Add($UserAlertDialogBtmMidButton)
  $UserAlertDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $UserAlertDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $UserAlertDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $UserAlertDialogBtmMidButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $UserAlertDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $UserAlertDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $UserAlertDialogBtmMidButton.Location = [System.Drawing.Point]::New(($TempWidth + ([MyConfig]::FormSpacer * 2)), [MyConfig]::FormSpacer)
  $UserAlertDialogBtmMidButton.Name = "UserAlertDialogBtmMidButton"
  $UserAlertDialogBtmMidButton.TabStop = $True
  $UserAlertDialogBtmMidButton.Text = "OK"
  $UserAlertDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $UserAlertDialogBtmMidButton.PreferredSize.Height)
  #endregion $UserAlertDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  $UserAlertDialogBtmPanel.ClientSize = [System.Drawing.Size]::New($UserAlertDialogMainPanel.ClientSize.Width, (($UserAlertDialogBtmPanel.Controls[$UserAlertDialogBtmPanel.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $UserAlertDialogBtmPanel Controls ********
  
  #$UserAlertDialogForm.ClientSize = [System.Drawing.Size]::New($UserAlertDialogForm.ClientSize.Width, ($UserAlertDialogForm.ClientSize.Height - ($UserAlertDialogMainPanel.ClientSize.Height - ($UserAlertDialogMainMessageLabel.Bottom + ([MyConfig]::FormSpacer * 2)))))
  
  $UserAlertDialogForm.ClientSize = [System.Drawing.Size]::New($UserAlertDialogForm.ClientSize.Width, $UserAlertDialogBtmPanel.Bottom)
  
  #endregion ******** Controls for $UserAlertDialog Form ********
  
  #endregion ================ End **** $UserAlertDialog **** End ================
  
  $DialogResult = $UserAlertDialogForm.ShowDialog($FCGForm)
  
  $UserAlertDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-UserAlertDialog"
}
#endregion function Show-UserAlertDialog

#region GetUserResponseDialog Result Class
Class GetUserResponseDialog
{
  [Bool]$Success
  [Object]$DialogResult
  
  GetUserResponseDialog ([Bool]$Success, [Object]$DialogResult)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
  }
}
#endregion GetUserResponseDialog Result Class

#region function Show-GetUserResponseDialog
Function Show-GetUserResponseDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetUserResponseDialog
    .DESCRIPTION
      Shows Show-GetUserResponseDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER Width
    .PARAMETER Icon
    .PARAMETER ButtonDefault
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetUserResponseDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "One")]
  Param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [parameter(Mandatory = $True)]
    [String]$MessageText,
    [Int]$Width = 25,
    [System.Drawing.Icon]$Icon = [System.Drawing.SystemIcons]::Information,
    [System.Windows.Forms.DialogResult]$ButtonDefault = "OK",
    [parameter(Mandatory = $True, ParameterSetName = "Two")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonLeft,
    [parameter(Mandatory = $False, ParameterSetName = "One")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonMid = "OK",
    [parameter(Mandatory = $True, ParameterSetName = "Two")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonRight
  )
  Write-Verbose -Message "Enter Function Show-GetUserResponseDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** $GetUserResponseDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # $GetUserResponseDialog Form
  # ************************************************
  #region $GetUserResponseDialogForm = [System.Windows.Forms.Form]::New()
  $GetUserResponseDialogForm = [System.Windows.Forms.Form]::New()
  $GetUserResponseDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetUserResponseDialogForm.Font = [MyConfig]::Font.Regular
  $GetUserResponseDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetUserResponseDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetUserResponseDialogForm.Icon = $FCGForm.Icon
  $GetUserResponseDialogForm.KeyPreview = $AllowControl.IsPresent
  $GetUserResponseDialogForm.MaximizeBox = $False
  $GetUserResponseDialogForm.MinimizeBox = $False
  $GetUserResponseDialogForm.Name = "GetUserResponseDialogForm"
  $GetUserResponseDialogForm.Owner = $FCGForm
  $GetUserResponseDialogForm.ShowInTaskbar = $False
  $GetUserResponseDialogForm.Size = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * 25))
  $GetUserResponseDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetUserResponseDialogForm.Tag = @{ "Cancel" = $False; "Pause" = $False }
  $GetUserResponseDialogForm.Text = $DialogTitle
  #endregion $GetUserResponseDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-GetUserResponseDialogFormKeyDown ********
  Function Start-GetUserResponseDialogFormKeyDown
  {
  <#
    .SYNOPSIS
      KeyDown Event for the GetUserResponseDialog Form Control
    .DESCRIPTION
      KeyDown Event for the GetUserResponseDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-GetUserResponseDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetUserResponseDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetUserResponseDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetUserResponseDialogForm"
  }
  #endregion ******** Function Start-GetUserResponseDialogFormKeyDown ********
  $GetUserResponseDialogForm.add_KeyDown({ Start-GetUserResponseDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetUserResponseDialogFormShown ********
  Function Start-GetUserResponseDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the $GetUserResponseDialog Form Control
      .DESCRIPTION
        Shown Event for the $GetUserResponseDialog Form Control
      .PARAMETER Sender
         The Form Control that fired the Shown Event
      .PARAMETER EventArg
         The Event Arguments for the Form Shown Event
      .EXAMPLE
         Start-GetUserResponseDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$GetUserResponseDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$GetUserResponseDialogForm"
  }
  #endregion ******** Function Start-GetUserResponseDialogFormShown ********
  $GetUserResponseDialogForm.add_Shown({ Start-GetUserResponseDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for $GetUserResponseDialog Form ********
  
  # ************************************************
  # $GetUserResponseDialogMain Panel
  # ************************************************
  #region $GetUserResponseDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetUserResponseDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetUserResponseDialogForm.Controls.Add($GetUserResponseDialogMainPanel)
  $GetUserResponseDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserResponseDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetUserResponseDialogMainPanel.Name = "GetUserResponseDialogMainPanel"
  $GetUserResponseDialogMainPanel.Text = "$GetUserResponseDialogMainPanel"
  #endregion $GetUserResponseDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetUserResponseDialogMainPanel Controls ********
  
  #region $GetUserResponseDialogMainPictureBox = [System.Windows.Forms.PictureBox]::New()
  $GetUserResponseDialogMainPictureBox = [System.Windows.Forms.PictureBox]::New()
  $GetUserResponseDialogMainPanel.Controls.Add($GetUserResponseDialogMainPictureBox)
  $GetUserResponseDialogMainPictureBox.AutoSize = $False
  $GetUserResponseDialogMainPictureBox.BackColor = [MyConfig]::Colors.Back
  $GetUserResponseDialogMainPictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserResponseDialogMainPictureBox.Image = $Icon
  $GetUserResponseDialogMainPictureBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
  $GetUserResponseDialogMainPictureBox.Name = "GetUserResponseDialogMainPictureBox"
  $GetUserResponseDialogMainPictureBox.Size = [System.Drawing.Size]::New(32, 32)
  $GetUserResponseDialogMainPictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::CenterImage
  #endregion $GetUserResponseDialogMainPictureBox = [System.Windows.Forms.PictureBox]::New()
  
  #region $GetUserResponseDialogMainLabel = [System.Windows.Forms.Label]::New()
  $GetUserResponseDialogMainLabel = [System.Windows.Forms.Label]::New()
  $GetUserResponseDialogMainPanel.Controls.Add($GetUserResponseDialogMainLabel)
  $GetUserResponseDialogMainLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserResponseDialogMainLabel.Font = [MyConfig]::Font.Regular
  $GetUserResponseDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
  $GetUserResponseDialogMainLabel.Location = [System.Drawing.Point]::New(($GetUserResponseDialogMainPictureBox.Right + [MyConfig]::FormSpacer), $GetUserResponseDialogMainPictureBox.Top)
  $GetUserResponseDialogMainLabel.Name = "GetUserResponseDialogMainLabel"
  $GetUserResponseDialogMainLabel.Size = [System.Drawing.Size]::New(($GetUserResponseDialogMainPanel.ClientSize.Width - ($GetUserResponseDialogMainPictureBox.Width + ([MyConfig]::FormSpacer * 3))), $GetUserResponseDialogMainPanel.ClientSize.Width)
  $GetUserResponseDialogMainLabel.Text = $MessageText
  #endregion $GetUserResponseDialogMainLabel = [System.Windows.Forms.Label]::New()
  
  # Returns the minimum size required to display the text
  $GetUserResponseDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetUserResponseDialogMainLabel.Text, $GetUserResponseDialogMainLabel.Font, $GetUserResponseDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))
  
  #endregion ******** $GetUserResponseDialogMainPanel Controls ********
  
  Switch ($PSCmdlet.ParameterSetName)
  {
    "One"
    {
      $GetUserResponseDialogButtons = 1
      Break
    }
    "Two"
    {
      $GetUserResponseDialogButtons = 2
      Break
    }
    "Three"
    {
      $GetUserResponseDialogButtons = 3
      Break
    }
  }
  
  # Evenly Space Buttons - Move Size to after Text
  # ************************************************
  # $GetUserResponseDialogBtm Panel
  # ************************************************
  #region $GetUserResponseDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetUserResponseDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetUserResponseDialogForm.Controls.Add($GetUserResponseDialogBtmPanel)
  $GetUserResponseDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserResponseDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetUserResponseDialogBtmPanel.Name = "GetUserResponseDialogBtmPanel"
  $GetUserResponseDialogBtmPanel.Text = "$GetUserResponseDialogBtmPanel"
  #endregion $GetUserResponseDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetUserResponseDialogBtmPanel Controls ********
  
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetUserResponseDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $GetUserResponseDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  If (($GetUserResponseDialogButtons -eq 2) -or ($GetUserResponseDialogButtons -eq 3))
  {
    $GetUserResponseDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
    $GetUserResponseDialogBtmPanel.Controls.Add($GetUserResponseDialogBtmLeftButton)
    $GetUserResponseDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
    $GetUserResponseDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    $GetUserResponseDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
    $GetUserResponseDialogBtmLeftButton.DialogResult = $ButtonLeft
    $GetUserResponseDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
    $GetUserResponseDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
    $GetUserResponseDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
    $GetUserResponseDialogBtmLeftButton.Name = "GetUserResponseDialogBtmLeftButton"
    $GetUserResponseDialogBtmLeftButton.TabIndex = 0
    $GetUserResponseDialogBtmLeftButton.TabStop = $True
    $GetUserResponseDialogBtmLeftButton.Text = "&$($ButtonLeft.ToString())"
    $GetUserResponseDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetUserResponseDialogBtmLeftButton.PreferredSize.Height)
  }
  #endregion $GetUserResponseDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  
  #region $GetUserResponseDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  If (($GetUserResponseDialogButtons -eq 1) -or ($GetUserResponseDialogButtons -eq 3))
  {
    $GetUserResponseDialogBtmMidButton = [System.Windows.Forms.Button]::New()
    $GetUserResponseDialogBtmPanel.Controls.Add($GetUserResponseDialogBtmMidButton)
    $GetUserResponseDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
    $GetUserResponseDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    $GetUserResponseDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
    $GetUserResponseDialogBtmMidButton.DialogResult = $ButtonMid
    $GetUserResponseDialogBtmMidButton.Font = [MyConfig]::Font.Bold
    $GetUserResponseDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
    $GetUserResponseDialogBtmMidButton.Location = [System.Drawing.Point]::New(($TempWidth + ([MyConfig]::FormSpacer * 2)), [MyConfig]::FormSpacer)
    $GetUserResponseDialogBtmMidButton.Name = "GetUserResponseDialogBtmMidButton"
    $GetUserResponseDialogBtmMidButton.TabStop = $True
    $GetUserResponseDialogBtmMidButton.Text = "&$($ButtonMid.ToString())"
    $GetUserResponseDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetUserResponseDialogBtmMidButton.PreferredSize.Height)
  }
  #endregion $GetUserResponseDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  #region $GetUserResponseDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  If (($GetUserResponseDialogButtons -eq 2) -or ($GetUserResponseDialogButtons -eq 3))
  {
    $GetUserResponseDialogBtmRightButton = [System.Windows.Forms.Button]::New()
    $GetUserResponseDialogBtmPanel.Controls.Add($GetUserResponseDialogBtmRightButton)
    $GetUserResponseDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
    $GetUserResponseDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    $GetUserResponseDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
    $GetUserResponseDialogBtmRightButton.DialogResult = $ButtonRight
    $GetUserResponseDialogBtmRightButton.Font = [MyConfig]::Font.Bold
    $GetUserResponseDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
    $GetUserResponseDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetUserResponseDialogBtmLeftButton.Right + $TempWidth + $TempMod + ([MyConfig]::FormSpacer * 2)), [MyConfig]::FormSpacer)
    $GetUserResponseDialogBtmRightButton.Name = "GetUserResponseDialogBtmRightButton"
    $GetUserResponseDialogBtmRightButton.TabIndex = 1
    $GetUserResponseDialogBtmRightButton.TabStop = $True
    $GetUserResponseDialogBtmRightButton.Text = "&$($ButtonRight.ToString())"
    $GetUserResponseDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetUserResponseDialogBtmRightButton.PreferredSize.Height)
  }
  #endregion $GetUserResponseDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  
  $GetUserResponseDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetUserResponseDialogMainTextBox.Right + [MyConfig]::FormSpacer), (($GetUserResponseDialogBtmPanel.Controls[$GetUserResponseDialogBtmPanel.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetUserResponseDialogBtmPanel Controls ********
  
  $GetUserResponseDialogForm.ClientSize = [System.Drawing.Size]::New($GetUserResponseDialogForm.ClientSize.Width, ($GetUserResponseDialogForm.ClientSize.Height - ($GetUserResponseDialogMainPanel.ClientSize.Height - ([Math]::Max($GetUserResponseDialogMainPictureBox.Bottom, $GetUserResponseDialogMainLabel.Bottom) + ([MyConfig]::FormSpacer * 2)))))
  
  #endregion ******** Controls for $GetUserResponseDialog Form ********
  
  #endregion ================ End **** $GetUserResponseDialog **** End ================
  
  $DialogResult = $GetUserResponseDialogForm.ShowDialog($FCGForm)
  [GetUserResponseDialog]::New(($DialogResult -eq $ButtonDefault), $DialogResult)
  
  $GetUserResponseDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-GetUserResponseDialog"
}
#endregion function Show-GetUserResponseDialog

#region GetUserTextDialog Result Class
Class GetUserTextDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [String[]]$Items

  GetUserTextDialog ([Bool]$Success, [Object]$DialogResult, [String[]]$Items)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.Items = $Items
  }
}
#endregion GetUserTextDialog Result Class

#region function Show-GetUserTextDialog
function Show-GetUserTextDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetUserTextDialog
    .DESCRIPTION
      Shows Show-GetUserTextDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER HintText
    .PARAMETER ValidChars
    .PARAMETER ValidOutput
    .PARAMETER Items
    .PARAMETER MaxLength
    .PARAMETER Width
    .PARAMETER Multi
    .PARAMETER Height
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetUserTextDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "Single")]
  param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText = "Status Message",
    [String]$HintText = "Enter Value Here",
    [String]$ValidChars = "[\s\w\d\.\-_,;]",
    [String]$ValidOutput = ".+",
    [String[]]$Items = @(),
    [Int]$MaxLength = [Int]::MaxValue,
    [Int]$Width = 35,
    [parameter(Mandatory = $True, ParameterSetName = "Multi")]
    [Switch]$Multi,
    [parameter(Mandatory = $False, ParameterSetName = "Multi")]
    [Int]$Height = 18,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-GetUserTextDialog"

  #region >>>>>>>>>>>>>>>> Begin **** GetUserTextDialog **** Begin <<<<<<<<<<<<<<<<

  # ************************************************
  # GetUserTextDialog Form
  # ************************************************
  #region $GetUserTextDialogForm = [System.Windows.Forms.Form]::New()
  $GetUserTextDialogForm = [System.Windows.Forms.Form]::New()
  $GetUserTextDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetUserTextDialogForm.Font = [MyConfig]::Font.Regular
  $GetUserTextDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetUserTextDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetUserTextDialogForm.Icon = $FCGForm.Icon
  $GetUserTextDialogForm.KeyPreview = $True
  $GetUserTextDialogForm.MaximizeBox = $False
  $GetUserTextDialogForm.MinimizeBox = $False
  if ($Multi.IsPresent)
  {
    $GetUserTextDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * $Height))
  }
  else
  {
    $GetUserTextDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), 0)
  }
  $GetUserTextDialogForm.Name = "GetUserTextDialogForm"
  $GetUserTextDialogForm.Owner = $FCGForm
  $GetUserTextDialogForm.ShowInTaskbar = $False
  $GetUserTextDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetUserTextDialogForm.Text = $DialogTitle
  #endregion $GetUserTextDialogForm = [System.Windows.Forms.Form]::New()

  #region ******** Function Start-GetUserTextDialogFormKeyDown ********
  function Start-GetUserTextDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetUserTextDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetUserTextDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetUserTextDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetUserTextDialogForm"

    [MyConfig]::AutoExit = 0
    if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetUserTextDialogForm.Close()
    }

    Write-Verbose -Message "Exit KeyDown Event for `$GetUserTextDialogForm"
  }
  #endregion ******** Function Start-GetUserTextDialogFormKeyDown ********
  $GetUserTextDialogForm.add_KeyDown({ Start-GetUserTextDialogFormKeyDown -Sender $This -EventArg $PSItem })

  #region ******** Function Start-GetUserTextDialogFormShown ********
  function Start-GetUserTextDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetUserTextDialog Form Control
      .DESCRIPTION
        Shown Event for the GetUserTextDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetUserTextDialogFormShown -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Shown Event for `$GetUserTextDialogForm"

    [MyConfig]::AutoExit = 0

    $GetUserTextDialogMainTextBox.DeselectAll()

    $Sender.Refresh()

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Verbose -Message "Exit Shown Event for `$GetUserTextDialogForm"
  }
  #endregion ******** Function Start-GetUserTextDialogFormShown ********
  $GetUserTextDialogForm.add_Shown({ Start-GetUserTextDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for GetUserTextDialog Form ********

  # ************************************************
  # GetUserTextDialogMain Panel
  # ************************************************
  #region $GetUserTextDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetUserTextDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetUserTextDialogForm.Controls.Add($GetUserTextDialogMainPanel)
  $GetUserTextDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserTextDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetUserTextDialogMainPanel.Name = "GetUserTextDialogMainPanel"
  $GetUserTextDialogMainPanel.Text = "GetUserTextDialogMainPanel"
  #endregion $GetUserTextDialogMainPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetUserTextDialogMainPanel Controls ********

  if ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $GetUserTextDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetUserTextDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetUserTextDialogMainPanel.Controls.Add($GetUserTextDialogMainLabel)
    $GetUserTextDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $GetUserTextDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $GetUserTextDialogMainLabel.Name = "GetUserTextDialogMainLabel"
    $GetUserTextDialogMainLabel.Size = [System.Drawing.Size]::New(($GetUserTextDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $GetUserTextDialogMainLabel.Text = $MessageText
    #endregion $GetUserTextDialogMainLabel = [System.Windows.Forms.Label]::New()

    # Returns the minimum size required to display the text
    $GetUserTextDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetUserTextDialogMainLabel.Text, $GetUserTextDialogMainLabel.Font, $GetUserTextDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))

    $TmpBottom = $GetUserTextDialogMainLabel.Bottom + [MyConfig]::FormSpacer
  }
  else
  {
    $TmpBottom = 0
  }
  
  # ************************************************
  # GetUserTextDialogMain GroupBox
  # ************************************************
  #region $GetUserTextDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  $GetUserTextDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  # Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetUserTextDialogMainPanel.Controls.Add($GetUserTextDialogMainGroupBox)
  $GetUserTextDialogMainGroupBox.BackColor = [MyConfig]::Colors.Back
  $GetUserTextDialogMainGroupBox.Font = [MyConfig]::Font.Regular
  $GetUserTextDialogMainGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
  $GetUserTextDialogMainGroupBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TmpBottom + [MyConfig]::FormSpacer))
  $GetUserTextDialogMainGroupBox.Name = "GetUserTextDialogMainGroupBox"
  $GetUserTextDialogMainGroupBox.Size = [System.Drawing.Size]::New(($GetUserTextDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($GetUserTextDialogMainPanel.ClientSize.Height - ($GetUserTextDialogMainGroupBox.Top + [MyConfig]::FormSpacer)))
  $GetUserTextDialogMainGroupBox.Text = $Null
  #endregion $GetUserTextDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  
  #region ******** $GetUserTextDialogMainGroupBox Controls ********
  
  #region $GetUserTextDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  $GetUserTextDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  $GetUserTextDialogMainGroupBox.Controls.Add($GetUserTextDialogMainTextBox)
  $GetUserTextDialogMainTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom")
  $GetUserTextDialogMainTextBox.AutoSize = $True
  $GetUserTextDialogMainTextBox.BackColor = [MyConfig]::Colors.TextBack
  $GetUserTextDialogMainTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $GetUserTextDialogMainTextBox.Font = [MyConfig]::Font.Regular
  $GetUserTextDialogMainTextBox.ForeColor = [MyConfig]::Colors.TextFore
  $GetUserTextDialogMainTextBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetUserTextDialogMainTextBox.MaxLength = $MaxLength
  $GetUserTextDialogMainTextBox.Multiline = $Multi.IsPresent
  $GetUserTextDialogMainTextBox.Name = "GetUserTextDialogMainTextBox"
  if ($Multi.IsPresent)
  {
    $GetUserTextDialogMainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
    If ($Items.Count)
    {
      $GetUserTextDialogMainTextBox.Lines = $Items
      $GetUserTextDialogMainTextBox.Tag = @{ "HintText" = $HintText; "HintEnabled" = $False; "Items" = $Items }
    }
    Else
    {
      $GetUserTextDialogMainTextBox.Lines = ""
      $GetUserTextDialogMainTextBox.Tag = @{ "HintText" = $HintText; "HintEnabled" = $True; "Items" = $Items }
    }
    $GetUserTextDialogMainTextBox.Size = [System.Drawing.Size]::New(($GetUserTextDialogMainGroupBox.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($GetUserTextDialogMainGroupBox.ClientSize.Height - ($GetUserTextDialogMainTextBox.Top + [MyConfig]::FormSpacer)))
  }
  else
  {
    $GetUserTextDialogMainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::None
    if ($Items.Count)
    {
      $GetUserTextDialogMainTextBox.Text = $Items[0]
      $GetUserTextDialogMainTextBox.Tag = @{ "HintText" = $HintText; "HintEnabled" = $False; "Items" = $Items[0] } 
    }
    else
    {
      $GetUserTextDialogMainTextBox.Text = ""
      $GetUserTextDialogMainTextBox.Tag = @{ "HintText" = $HintText; "HintEnabled" = $True; "Items" = "" }
    }
    $GetUserTextDialogMainTextBox.Size = [System.Drawing.Size]::New(($GetUserTextDialogMainGroupBox.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), $GetUserTextDialogMainTextBox.PreferredHeight)
  }
  $GetUserTextDialogMainTextBox.TabIndex = 0
  $GetUserTextDialogMainTextBox.TabStop = $True
  $GetUserTextDialogMainTextBox.WordWrap = $False
  #endregion $GetUserTextDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxGotFocus ********
  Function Start-GetUserTextDialogMainTextBoxGotFocus
  {
  <#
    .SYNOPSIS
      GotFocus Event for the GetUserTextDialogMain TextBox Control
    .DESCRIPTION
      GotFocus Event for the GetUserTextDialogMain TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the GotFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox GotFocus Event
    .EXAMPLE
       Start-GetUserTextDialogMainTextBoxGotFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter GotFocus Event for `$GetUserTextDialogMainTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    If ($Sender.Tag.HintEnabled)
    {
      $Sender.Text = ""
      $Sender.Font = [MyConfig]::Font.Regular
      $Sender.ForeColor = [MyConfig]::Colors.TextFore
    }
    
    Write-Verbose -Message "Exit GotFocus Event for `$GetUserTextDialogMainTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxGotFocus ********
  $GetUserTextDialogMainTextBox.add_GotFocus({ Start-GetUserTextDialogMainTextBoxGotFocus -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxKeyDown ********
  function Start-GetUserTextDialogMainTextBoxKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetUserTextDialogMain TextBox Control
      .DESCRIPTION
        KeyDown Event for the GetUserTextDialogMain TextBox Control
      .PARAMETER Sender
        The TextBox Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the TextBox KeyDown Event
      .EXAMPLE
        Start-GetUserTextDialogMainTextBoxKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By ken.sweet
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetUserTextDialogMainTextBox"

    [MyConfig]::AutoExit = 0
    
    if ((-not $Sender.Multiline) -and ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Return))
    {
      $GetUserTextDialogBtmLeftButton.PerformClick()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetUserTextDialogMainTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxKeyDown ********
  $GetUserTextDialogMainTextBox.add_KeyDown({ Start-GetUserTextDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxKeyPress ********
  Function Start-GetUserTextDialogMainTextBoxKeyPress
  {
    <#
      .SYNOPSIS
        KeyPress Event for the GetUserTextDialogMain TextBox Control
      .DESCRIPTION
        KeyPress Event for the GetUserTextDialogMain TextBox Control
      .PARAMETER Sender
         The TextBox Control that fired the KeyPress Event
      .PARAMETER EventArg
         The Event Arguments for the TextBox KeyPress Event
      .EXAMPLE
         Start-GetUserTextDialogMainTextBoxKeyPress -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By ken.sweet
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyPress Event for `$GetUserTextDialogMainTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # 3 = Ctrl-C, 8 = Backspace, 22 = Ctrl-V, 24 = Ctrl-X
    $EventArg.Handled = (($EventArg.KeyChar -notmatch $ValidChars) -and ([Int]($EventArg.KeyChar) -notin (3, 8, 22, 24)))
    
    Write-Verbose -Message "Exit KeyPress Event for `$GetUserTextDialogMainTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxKeyPress ********
  $GetUserTextDialogMainTextBox.add_KeyPress({Start-GetUserTextDialogMainTextBoxKeyPress -Sender $This -EventArg $PSItem})
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxKeyUp ********
  Function Start-GetUserTextDialogMainTextBoxKeyUp
  {
  <#
    .SYNOPSIS
      KeyUp Event for the GetUserTextDialogMain TextBox Control
    .DESCRIPTION
      KeyUp Event for the GetUserTextDialogMain TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyUp Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyUp Event
    .EXAMPLE
       Start-GetUserTextDialogMainTextBoxKeyUp -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyUp Event for `$GetUserTextDialogMainTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    $Sender.Tag.HintEnabled = ($Sender.Text.Trim().Length -eq 0)
    
    Write-Verbose -Message "Exit KeyUp Event for `$GetUserTextDialogMainTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxKeyUp ********
  $GetUserTextDialogMainTextBox.add_KeyUp({ Start-GetUserTextDialogMainTextBoxKeyUp -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxLostFocus ********
  Function Start-GetUserTextDialogMainTextBoxLostFocus
  {
  <#
    .SYNOPSIS
      LostFocus Event for the GetUserTextDialogMain TextBox Control
    .DESCRIPTION
      LostFocus Event for the GetUserTextDialogMain TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the LostFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox LostFocus Event
    .EXAMPLE
       Start-GetUserTextDialogMainTextBoxLostFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter LostFocus Event for `$GetUserTextDialogMainTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    If ([String]::IsNullOrEmpty(($Sender.Text.Trim())))
    {
      $Sender.Text = $Sender.Tag.HintText
      $Sender.Tag.HintEnabled = $True
      $Sender.Font = [MyConfig]::Font.Hint
      $Sender.ForeColor = [MyConfig]::Colors.TextHint
    }
    Else
    {
      $Sender.Tag.HintEnabled = $False
      $Sender.Font = [MyConfig]::Font.Regular
      $Sender.ForeColor = [MyConfig]::Colors.TextFore
    }
    
    Write-Verbose -Message "Exit LostFocus Event for `$GetUserTextDialogMainTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxLostFocus ********
  $GetUserTextDialogMainTextBox.add_LostFocus({ Start-GetUserTextDialogMainTextBoxLostFocus -Sender $This -EventArg $PSItem })
  
  $GetUserTextDialogMainGroupBox.ClientSize = [System.Drawing.Size]::New($GetUserTextDialogMainGroupBox.ClientSize.Width, ($GetUserTextDialogMainTextBox.Bottom + ([MyConfig]::FormSpacer * 2)))
  
  #endregion ******** $GetUserTextDialogMainGroupBox Controls ********
  
  $TempClientSize = [System.Drawing.Size]::New(($GetUserTextDialogMainGroupBox.Right + [MyConfig]::FormSpacer), ($GetUserTextDialogMainGroupBox.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $GetUserTextDialogMainPanel Controls ********

  # ************************************************
  # GetUserTextDialogBtm Panel
  # ************************************************
  #region $GetUserTextDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetUserTextDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetUserTextDialogForm.Controls.Add($GetUserTextDialogBtmPanel)
  $GetUserTextDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetUserTextDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetUserTextDialogBtmPanel.Name = "GetUserTextDialogBtmPanel"
  $GetUserTextDialogBtmPanel.Text = "GetUserTextDialogBtmPanel"
  #endregion $GetUserTextDialogBtmPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetUserTextDialogBtmPanel Controls ********

  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetUserTextDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons

  #region $GetUserTextDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmPanel.Controls.Add($GetUserTextDialogBtmLeftButton)
  $GetUserTextDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetUserTextDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetUserTextDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetUserTextDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetUserTextDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetUserTextDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetUserTextDialogBtmLeftButton.Name = "GetUserTextDialogBtmLeftButton"
  $GetUserTextDialogBtmLeftButton.TabIndex = 1
  $GetUserTextDialogBtmLeftButton.TabStop = $True
  $GetUserTextDialogBtmLeftButton.Text = $ButtonLeft
  $GetUserTextDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetUserTextDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetUserTextDialogBtmLeftButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetUserTextDialogBtmLeftButtonClick ********
  function Start-GetUserTextDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetUserTextDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetUserTextDialogBtmLeft Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetUserTextDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetUserTextDialogBtmLeftButton"

    [MyConfig]::AutoExit = 0

    If ((-not $GetUserTextDialogMainTextBox.Tag.HintEnabled) -and ("$($GetUserTextDialogMainTextBox.Text.Trim())".Length -gt 0))
    {
      $ChkOutput = $True
      ($GetUserTextDialogMainTextBox.Text -replace "\s*[\n,;]+\s*", ",").Split(",", [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object -Process { $ChkOutput = ($ChkOutput -and $PSItem -match $ValidOutput) }
      If ($ChkOutput)
      {
        $GetUserTextDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
      }
      Else
      {
        [Void][System.Windows.Forms.MessageBox]::Show($GetUserTextDialogForm, "Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
      }
    }
    Else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetUserTextDialogForm, "Missing Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }

    Write-Verbose -Message "Exit Click Event for `$GetUserTextDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetUserTextDialogBtmLeftButtonClick ********
  $GetUserTextDialogBtmLeftButton.add_Click({ Start-GetUserTextDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })

  #region $GetUserTextDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmPanel.Controls.Add($GetUserTextDialogBtmMidButton)
  $GetUserTextDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetUserTextDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetUserTextDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetUserTextDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetUserTextDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetUserTextDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetUserTextDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetUserTextDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetUserTextDialogBtmMidButton.Name = "GetUserTextDialogBtmMidButton"
  $GetUserTextDialogBtmMidButton.TabIndex = 2
  $GetUserTextDialogBtmMidButton.TabStop = $True
  $GetUserTextDialogBtmMidButton.Text = $ButtonMid
  $GetUserTextDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetUserTextDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetUserTextDialogBtmMidButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetUserTextDialogBtmMidButtonClick ********
  function Start-GetUserTextDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetUserTextDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetUserTextDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetUserTextDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetUserTextDialogBtmMidButton"

    [MyConfig]::AutoExit = 0

    if ($Multi.IsPresent)
    {
      $GetUserTextDialogMainTextBox.Lines = $GetUserTextDialogMainTextBox.Tag.Items
    }
    else
    {
      $GetUserTextDialogMainTextBox.Text = $GetUserTextDialogMainTextBox.Tag.Items
    }
    
    $GetUserTextDialogMainTextBox.Tag.HintEnabled = ($GetUserTextDialogMainTextBox.TextLength -gt 0)
    Start-GetUserTextDialogMainTextBoxLostFocus -Sender $GetUserTextDialogMainTextBox -EventArg "LostFocus"
    
    Write-Verbose -Message "Exit Click Event for `$GetUserTextDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetUserTextDialogBtmMidButtonClick ********
  $GetUserTextDialogBtmMidButton.add_Click({ Start-GetUserTextDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })

  #region $GetUserTextDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetUserTextDialogBtmPanel.Controls.Add($GetUserTextDialogBtmRightButton)
  $GetUserTextDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetUserTextDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetUserTextDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetUserTextDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetUserTextDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetUserTextDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetUserTextDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetUserTextDialogBtmRightButton.Name = "GetUserTextDialogBtmRightButton"
  $GetUserTextDialogBtmRightButton.TabIndex = 3
  $GetUserTextDialogBtmRightButton.TabStop = $True
  $GetUserTextDialogBtmRightButton.Text = $ButtonRight
  $GetUserTextDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetUserTextDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetUserTextDialogBtmRightButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetUserTextDialogBtmRightButtonClick ********
  function Start-GetUserTextDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetUserTextDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetUserTextDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetUserTextDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetUserTextDialogBtmRightButton"

    [MyConfig]::AutoExit = 0

    # Cancel Code Goes here
    
    $GetUserTextDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    Write-Verbose -Message "Exit Click Event for `$GetUserTextDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetUserTextDialogBtmRightButtonClick ********
  $GetUserTextDialogBtmRightButton.add_Click({ Start-GetUserTextDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })

  $GetUserTextDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetUserTextDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetUserTextDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $GetUserTextDialogBtmPanel Controls ********

  $GetUserTextDialogForm.ClientSize = [System.Drawing.Size]::New($GetUserTextDialogForm.ClientSize.Width, ($TempClientSize.Height + $GetUserTextDialogBtmPanel.Height))

  #endregion ******** Controls for GetUserTextDialog Form ********

  #endregion ================ End **** GetUserTextDialog **** End ================

  $DialogResult = $GetUserTextDialogForm.ShowDialog($FCGForm)
  If ($Multi.IsPresent)
  {
    [GetUserTextDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, (($GetUserTextDialogMainTextBox.Text -replace "\s*[\n,;]+\s*", ",").Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)))
  }
  Else
  {
    [GetUserTextDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, $GetUserTextDialogMainTextBox.Text)
  }
  
  $GetUserTextDialogForm.Dispose()

  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()

  Write-Verbose -Message "Exit Function Show-GetUserTextDialog"
}
#endregion function Show-GetUserTextDialog

#region GetMultiValueDialog Result Class
Class GetMultiValueDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [System.Collections.Specialized.OrderedDictionary]$OrderedItems
  
  GetMultiValueDialog ([Bool]$Success, [Object]$DialogResult, [System.Collections.Specialized.OrderedDictionary]$OrderedItems)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.OrderedItems = $OrderedItems
  }
}
#endregion GetMultiValueDialog Result Class

#region function Show-GetMultiValueDialog
Function Show-GetMultiValueDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetMultiValueDialog
    .DESCRIPTION
      Shows Show-GetMultiValueDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER ReturnTitle
    .PARAMETER OrderedItems
    .PARAMETER ValidCars
    .PARAMETER Width
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .PARAMETER AllRequired
    .EXAMPLE
      $Return = Show-GetMultiValueDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText,
    [String]$ReturnTitle,
    [parameter(Mandatory = $True)]
    [System.Collections.Specialized.OrderedDictionary]$OrderedItems,
    [String]$ValidChars = "[\s\w\d\.\-_]",
    [Int]$Width = 35,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel",
    [Switch]$AllRequired
  )
  Write-Verbose -Message "Enter Function Show-GetMultiValueDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** GetMultiValueDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # GetMultiValueDialog Form
  # ************************************************
  #region $GetMultiValueDialogForm = [System.Windows.Forms.Form]::New()
  $GetMultiValueDialogForm = [System.Windows.Forms.Form]::New()
  $GetMultiValueDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetMultiValueDialogForm.Font = [MyConfig]::Font.Regular
  $GetMultiValueDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetMultiValueDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetMultiValueDialogForm.Icon = $FCGForm.Icon
  $GetMultiValueDialogForm.KeyPreview = $True
  $GetMultiValueDialogForm.MaximizeBox = $False
  $GetMultiValueDialogForm.MinimizeBox = $False
  $GetMultiValueDialogForm.Name = "GetMultiValueDialogForm"
  $GetMultiValueDialogForm.Owner = $FCGForm
  $GetMultiValueDialogForm.ShowInTaskbar = $False
  $GetMultiValueDialogForm.Size = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * 25))
  $GetMultiValueDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetMultiValueDialogForm.Tag = $AllRequired.IsPresent
  $GetMultiValueDialogForm.Text = $DialogTitle
  #endregion $GetMultiValueDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-GetMultiValueDialogFormKeyDown ********
  Function Start-GetMultiValueDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetMultiValueDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetMultiValueDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetMultiValueDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetMultiValueDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetMultiValueDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetMultiValueDialogForm"
  }
  #endregion ******** Function Start-GetMultiValueDialogFormKeyDown ********
  $GetMultiValueDialogForm.add_KeyDown({ Start-GetMultiValueDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetMultiValueDialogFormShown ********
  Function Start-GetMultiValueDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetMultiValueDialog Form Control
      .DESCRIPTION
        Shown Event for the GetMultiValueDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetMultiValueDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$GetMultiValueDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$GetMultiValueDialogForm"
  }
  #endregion ******** Function Start-GetMultiValueDialogFormShown ********
  $GetMultiValueDialogForm.add_Shown({ Start-GetMultiValueDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for GetMultiValueDialog Form ********
  
  # ************************************************
  # GetMultiValueDialogMain Panel
  # ************************************************
  #region $GetMultiValueDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetMultiValueDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetMultiValueDialogForm.Controls.Add($GetMultiValueDialogMainPanel)
  $GetMultiValueDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetMultiValueDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetMultiValueDialogMainPanel.Name = "GetMultiValueDialogMainPanel"
  $GetMultiValueDialogMainPanel.Text = "GetMultiValueDialogMainPanel"
  #endregion $GetMultiValueDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetMultiValueDialogMainPanel Controls ********
  
  If ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $GetMultiValueDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetMultiValueDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetMultiValueDialogMainPanel.Controls.Add($GetMultiValueDialogMainLabel)
    $GetMultiValueDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $GetMultiValueDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $GetMultiValueDialogMainLabel.Name = "SearchTextMainLabel"
    $GetMultiValueDialogMainLabel.Size = [System.Drawing.Size]::New(($GetMultiValueDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $GetMultiValueDialogMainLabel.Text = $MessageText
    $GetMultiValueDialogMainLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    #endregion $GetMultiValueDialogMainLabel = [System.Windows.Forms.Label]::New()
    
    # Returns the minimum size required to display the text
    $GetMultiValueDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetMultiValueDialogMainLabel.Text, $GetMultiValueDialogMainLabel.Font, $GetMultiValueDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))
    
    $TempBottom = $GetMultiValueDialogMainLabel.Bottom
  }
  Else
  {
    $TempBottom = 0
  }
  
  # ************************************************
  # GetMultiValueDialog GroupBox
  # ************************************************
  #region $GetMultiValueDialogGroupBox = [System.Windows.Forms.GroupBox]::New()
  $GetMultiValueDialogGroupBox = [System.Windows.Forms.GroupBox]::New()
  # Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetMultiValueDialogMainPanel.Controls.Add($GetMultiValueDialogGroupBox)
  $GetMultiValueDialogGroupBox.BackColor = [MyConfig]::Colors.Back
  $GetMultiValueDialogGroupBox.Font = [MyConfig]::Font.Bold
  $GetMultiValueDialogGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
  $GetMultiValueDialogGroupBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TempBottom + [MyConfig]::FormSpacer))
  $GetMultiValueDialogGroupBox.Name = "GetMultiValueDialogGroupBox"
  $GetMultiValueDialogGroupBox.Text = $ReturnTitle
  $GetMultiValueDialogGroupBox.Width = ($GetMultiValueDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2))
  #endregion $GetMultiValueDialogGroupBox = [System.Windows.Forms.GroupBox]::New()
  
  $TmpLabelWidth = 0
  $Count = 0
  ForEach ($Key In $OrderedItems.Keys)
  {
    #region $GetMultiValueDialogLabel = [System.Windows.Forms.Label]::New()
    $GetMultiValueDialogLabel = [System.Windows.Forms.Label]::New()
    $GetMultiValueDialogGroupBox.Controls.Add($GetMultiValueDialogLabel)
    $GetMultiValueDialogLabel.AutoSize = $True
    $GetMultiValueDialogLabel.BackColor = [MyConfig]::Colors.Back
    $GetMultiValueDialogLabel.Font = [MyConfig]::Font.Regular
    $GetMultiValueDialogLabel.ForeColor = [MyConfig]::Colors.Fore
    $GetMultiValueDialogLabel.Location = [System.Drawing.Size]::New([MyConfig]::FormSpacer, ([MyConfig]::Font.Height + (($GetMultiValueDialogLabel.PreferredHeight + [MyConfig]::FormSpacer) * $Count)))
    $GetMultiValueDialogLabel.Name = "$($Key)Label"
    $GetMultiValueDialogLabel.Tag = $Null
    $GetMultiValueDialogLabel.Text = "$($Key):"
    $GetMultiValueDialogLabel.TextAlign = [System.Drawing.ContentAlignment]::BottomRight
    #endregion $GetMultiValueDialogLabel = [System.Windows.Forms.Label]::New()
    
    $TmpLabelWidth = [Math]::Max($TmpLabelWidth, $GetMultiValueDialogLabel.Width)
    $Count += 1
  }
  
  #region ******** Function Start-GetMultiValueDialogTextBoxGotFocus ********
  Function Start-GetMultiValueDialogTextBoxGotFocus
  {
  <#
    .SYNOPSIS
      GotFocus Event for the GetMultiValueDialog TextBox Control
    .DESCRIPTION
      GotFocus Event for the GetMultiValueDialog TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the GotFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox GotFocus Event
    .EXAMPLE
       Start-GetMultiValueDialogTextBoxGotFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter GotFocus Event for `$GetMultiValueDialogTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    If ($Sender.Tag.HintEnabled)
    {
      $Sender.Text = ""
      $Sender.Font = [MyConfig]::Font.Regular
      $Sender.ForeColor = [MyConfig]::Colors.TextFore
    }
    
    Write-Verbose -Message "Exit GotFocus Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetMultiValueDialogTextBoxGotFocus ********
  #$GetMultiValueDialogTextBox.add_GotFocus({ Start-GetMultiValueDialogTextBoxGotFocus -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetMultiValueDialogMainTextBoxKeyDown ********
  function Start-GetMultiValueDialogMainTextBoxKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetMultiValueMain TextBox Control
      .DESCRIPTION
        KeyDown Event for the GetMultiValueMain TextBox Control
      .PARAMETER Sender
        The TextBox Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the TextBox KeyDown Event
      .EXAMPLE
        Start-GetMultiValueDialogMainTextBoxKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By ken.sweet
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetMultiValueDialogTextBox"

    [MyConfig]::AutoExit = 0
    
    if ((-not $Sender.Multiline) -and ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Return))
    {
      $GetMultiValueDialogBtmLeftButton.PerformClick()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetMultiValueDialogMainTextBoxKeyDown ********
  #$GetMultiValueDialogTextBox.add_KeyDown({ Start-GetMultiValueDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetMultiValueDialogTextBoxKeyPress ********
  Function Start-GetMultiValueDialogTextBoxKeyPress
  {
    <#
      .SYNOPSIS
        KeyPress Event for the GetMultiValueDialog TextBox Control
      .DESCRIPTION
        KeyPress Event for the GetMultiValueDialog TextBox Control
      .PARAMETER Sender
         The TextBox Control that fired the KeyPress Event
      .PARAMETER EventArg
         The Event Arguments for the TextBox KeyPress Event
      .EXAMPLE
         Start-GetMultiValueDialogTextBoxKeyPress -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By ken.sweet
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyPress Event for `$GetMultiValueDialogTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # 3 = Ctrl-C, 8 = Backspace, 22 = Ctrl-V, 24 = Ctrl-X
    $EventArg.Handled = (($EventArg.KeyChar -notmatch $ValidChars) -and ([Int]($EventArg.KeyChar) -notin (3, 8, 22, 24)))
    
    Write-Verbose -Message "Exit KeyPress Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetMultiValueDialogTextBoxKeyPress ********
  #$GetMultiValueDialogTextBox.add_KeyPress({ Start-GetMultiValueDialogTextBoxKeyPress -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetMultiValueDialogTextBoxKeyUp ********
  Function Start-GetMultiValueDialogTextBoxKeyUp
  {
  <#
    .SYNOPSIS
      KeyUp Event for the GetMultiValueDialog TextBox Control
    .DESCRIPTION
      KeyUp Event for the GetMultiValueDialog TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyUp Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyUp Event
    .EXAMPLE
       Start-GetMultiValueDialogTextBoxKeyUp -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyUp Event for `$GetMultiValueDialogTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    $Sender.Tag.HintEnabled = ($Sender.Text.Trim().Length -eq 0)
    
    Write-Verbose -Message "Exit KeyUp Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetMultiValueDialogTextBoxKeyUp ********
  #$GetMultiValueDialogTextBox.add_KeyUp({ Start-GetMultiValueDialogTextBoxKeyUp -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetMultiValueDialogTextBoxLostFocus ********
  Function Start-GetMultiValueDialogTextBoxLostFocus
  {
  <#
    .SYNOPSIS
      LostFocus Event for the GetMultiValueDialog TextBox Control
    .DESCRIPTION
      LostFocus Event for the GetMultiValueDialog TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the LostFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox LostFocus Event
    .EXAMPLE
       Start-GetMultiValueDialogTextBoxLostFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.TextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter LostFocus Event for `$GetMultiValueDialogTextBox"
    
    [MyConfig]::AutoExit = 0
    
    # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
    If ([String]::IsNullOrEmpty(($Sender.Text.Trim())))
    {
      $Sender.Text = $Sender.Tag.HintText
      $Sender.Tag.HintEnabled = $True
      $Sender.Font = [MyConfig]::Font.Hint
      $Sender.ForeColor = [MyConfig]::Colors.TextHint
    }
    Else
    {
      $Sender.Tag.HintEnabled = $False
      $Sender.Font = [MyConfig]::Font.Regular
      $Sender.ForeColor = [MyConfig]::Colors.TextFore
    }
    
    Write-Verbose -Message "Exit LostFocus Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetMultiValueDialogTextBoxLostFocus ********
  #$GetMultiValueDialogTextBox.add_LostFocus({ Start-GetMultiValueDialogTextBoxLostFocus -Sender $This -EventArg $PSItem })

  ForEach ($Key In $OrderedItems.Keys)
  {
    $TmpLabel = $GetMultiValueDialogGroupBox.Controls["$($Key)Label"]
    $TmpLabel.AutoSize = $False
    $TmpLabel.Size = [System.Drawing.Size]::New($TmpLabelWidth, $TmpLabel.PreferredHeight)
    
    #region $GetMultiValueDialogTextBox = [System.Windows.Forms.TextBox]::New()
    $GetMultiValueDialogTextBox = [System.Windows.Forms.TextBox]::New()
    $GetMultiValueDialogGroupBox.Controls.Add($GetMultiValueDialogTextBox)
    $GetMultiValueDialogTextBox.AutoSize = $False
    $GetMultiValueDialogTextBox.BackColor = [MyConfig]::Colors.TextBack
    $GetMultiValueDialogTextBox.Font = [MyConfig]::Font.Regular
    $GetMultiValueDialogTextBox.ForeColor = [MyConfig]::Colors.TextFore
    $GetMultiValueDialogTextBox.Location = [System.Drawing.Size]::New(($TmpLabel.Right + [MyConfig]::FormSpacer), $TmpLabel.Top)
    $GetMultiValueDialogTextBox.MaxLength = 25
    $GetMultiValueDialogTextBox.Name = "$($Key)"
    $GetMultiValueDialogTextBox.TabStop = $True
    $GetMultiValueDialogTextBox.Text = $OrderedItems[$Key]
    $GetMultiValueDialogTextBox.Tag = @{ "HintText" = "Enter Value for '$($Key)'"; "HintEnabled" = ($GetMultiValueDialogTextBox.TextLength -eq 0); "Value" = $OrderedItems[$Key] }
    $GetMultiValueDialogTextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
    $GetMultiValueDialogTextBox.Size = [System.Drawing.Size]::New(($GetMultiValueDialogGroupBox.ClientSize.Width - ($TmpLabel.Right + ([MyConfig]::FormSpacer) * 2)), $TmpLabel.Height)
    #endregion $GetMultiValueDialogTextBox = [System.Windows.Forms.TextBox]::New()
    
    $GetMultiValueDialogTextBox.add_GotFocus({ Start-GetMultiValueDialogTextBoxGotFocus -Sender $This -EventArg $PSItem})
    $GetMultiValueDialogTextBox.add_KeyDown({ Start-GetMultiValueDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem})
    $GetMultiValueDialogTextBox.add_KeyPress({Start-GetMultiValueDialogTextBoxKeyPress -Sender $This -EventArg $PSItem})
    $GetMultiValueDialogTextBox.add_KeyUp({ Start-GetMultiValueDialogTextBoxKeyUp -Sender $This -EventArg $PSItem})
    $GetMultiValueDialogTextBox.add_LostFocus({ Start-GetMultiValueDialogTextBoxLostFocus -Sender $This -EventArg $PSItem})
    Start-GetMultiValueDialogTextBoxLostFocus -Sender $GetMultiValueDialogTextBox -EventArg $EventArg
}
  
  $GetMultiValueDialogGroupBox.ClientSize = [System.Drawing.Size]::New($GetMultiValueDialogGroupBox.ClientSize.Width, (($GetMultiValueDialogGroupBox.Controls[$GetMultiValueDialogGroupBox.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))
  
  $TempClientSize = [System.Drawing.Size]::New(($GetMultiValueDialogMainTextBox.Right + [MyConfig]::FormSpacer), ($GetMultiValueDialogGroupBox.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetMultiValueDialogMainPanel Controls ********
  
  # ************************************************
  # GetMultiValueDialogBtm Panel
  # ************************************************
  #region $GetMultiValueDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetMultiValueDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetMultiValueDialogForm.Controls.Add($GetMultiValueDialogBtmPanel)
  $GetMultiValueDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetMultiValueDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetMultiValueDialogBtmPanel.Name = "GetMultiValueDialogBtmPanel"
  $GetMultiValueDialogBtmPanel.Text = "GetMultiValueDialogBtmPanel"
  #endregion $GetMultiValueDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetMultiValueDialogBtmPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetMultiValueDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $GetMultiValueDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmPanel.Controls.Add($GetMultiValueDialogBtmLeftButton)
  $GetMultiValueDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetMultiValueDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetMultiValueDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetMultiValueDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetMultiValueDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetMultiValueDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetMultiValueDialogBtmLeftButton.Name = "GetMultiValueDialogBtmLeftButton"
  $GetMultiValueDialogBtmLeftButton.TabIndex = 1
  $GetMultiValueDialogBtmLeftButton.TabStop = $True
  $GetMultiValueDialogBtmLeftButton.Text = $ButtonLeft
  $GetMultiValueDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetMultiValueDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetMultiValueDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetMultiValueDialogBtmLeftButtonClick ********
  Function Start-GetMultiValueDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetMultiValueDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetMultiValueDialogBtmLeft Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetMultiValueDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetMultiValueDialogBtmLeftButton"
    
    [MyConfig]::AutoExit = 0
    
    $TmpValidCheck = $GetMultiValueDialogForm.Tag
    ForEach ($Key In @($OrderedItems.Keys))
    {
      $TmpItemValue = "$($GetMultiValueDialogGroupBox.Controls[$Key].Text)".Trim()
      $ChkItemValue = (-not (([String]::IsNullOrEmpty($TmpItemValue) -or $GetMultiValueDialogGroupBox.Controls[$Key].Tag.HintEnabled)))
      if ($ChkItemValue)
      {
        $OrderedItems[$Key] = $TmpItemValue
      }
      else
      {
        $OrderedItems[$Key] = $Null
      }
      
      if ($GetMultiValueDialogForm.Tag)
      {
        $TmpValidCheck = $ChkItemValue -and $TmpValidCheck
      }
      else
      {
        $TmpValidCheck = $ChkItemValue -or $TmpValidCheck
      }
    }
    
    If ($TmpValidCheck)
    {
      $GetMultiValueDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    Else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetMultiValueDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetMultiValueDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetMultiValueDialogBtmLeftButtonClick ********
  $GetMultiValueDialogBtmLeftButton.add_Click({ Start-GetMultiValueDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetMultiValueDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmPanel.Controls.Add($GetMultiValueDialogBtmMidButton)
  $GetMultiValueDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetMultiValueDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetMultiValueDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetMultiValueDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetMultiValueDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetMultiValueDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetMultiValueDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetMultiValueDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetMultiValueDialogBtmMidButton.Name = "GetMultiValueDialogBtmMidButton"
  $GetMultiValueDialogBtmMidButton.TabIndex = 2
  $GetMultiValueDialogBtmMidButton.TabStop = $True
  $GetMultiValueDialogBtmMidButton.Text = $ButtonMid
  $GetMultiValueDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetMultiValueDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetMultiValueDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetMultiValueDialogBtmMidButtonClick ********
  Function Start-GetMultiValueDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetMultiValueDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetMultiValueDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetMultiValueDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetMultiValueDialogBtmMidButton"
    
    [MyConfig]::AutoExit = 0
    
    ForEach ($Key In @($OrderedItems.Keys))
    {
      $GetMultiValueDialogGroupBox.Controls[$Key].Text = $GetMultiValueDialogGroupBox.Controls[$Key].Tag.Value
      $GetMultiValueDialogGroupBox.Controls[$Key].Tag.HintEnabled = ($GetMultiValueDialogGroupBox.TextLength -eq 0)
      Start-GetMultiValueDialogTextBoxLostFocus -Sender $GetMultiValueDialogGroupBox.Controls[$Key] -EventArg $EventArg
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetMultiValueDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetMultiValueDialogBtmMidButtonClick ********
  $GetMultiValueDialogBtmMidButton.add_Click({ Start-GetMultiValueDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetMultiValueDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetMultiValueDialogBtmPanel.Controls.Add($GetMultiValueDialogBtmRightButton)
  $GetMultiValueDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetMultiValueDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetMultiValueDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetMultiValueDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetMultiValueDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetMultiValueDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetMultiValueDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetMultiValueDialogBtmRightButton.Name = "GetMultiValueDialogBtmRightButton"
  $GetMultiValueDialogBtmRightButton.TabIndex = 3
  $GetMultiValueDialogBtmRightButton.TabStop = $True
  $GetMultiValueDialogBtmRightButton.Text = $ButtonRight
  $GetMultiValueDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetMultiValueDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetMultiValueDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetMultiValueDialogBtmRightButtonClick ********
  Function Start-GetMultiValueDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetMultiValueDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetMultiValueDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetMultiValueDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetMultiValueDialogBtmRightButton"
    
    [MyConfig]::AutoExit = 0
    
    # Cancel Code Goes here
    
    $GetMultiValueDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    
    Write-Verbose -Message "Exit Click Event for `$GetMultiValueDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetMultiValueDialogBtmRightButtonClick ********
  $GetMultiValueDialogBtmRightButton.add_Click({ Start-GetMultiValueDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })
  
  $GetMultiValueDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetMultiValueDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetMultiValueDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetMultiValueDialogBtmPanel Controls ********
  
  $GetMultiValueDialogForm.ClientSize = [System.Drawing.Size]::New($GetMultiValueDialogForm.ClientSize.Width, ($TempClientSize.Height + $GetMultiValueDialogBtmPanel.Height))
  
  #endregion ******** Controls for GetMultiValueDialog Form ********
  
  #endregion ================ End **** GetMultiValueDialog **** End ================
  
  $DialogResult = $GetMultiValueDialogForm.ShowDialog($FCGForm)
  [GetMultiValueDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, $OrderedItems)
  
  $GetMultiValueDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-GetMultiValueDialog"
}
#endregion function Show-GetMultiValueDialog

#region GetRadioChoiceDialog Result Class
Class GetRadioChoiceDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [String]$Item = $Null
  [Object]$Object = $Null

  GetRadioChoiceDialog ([Bool]$Success, [Object]$DialogResult)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
  }

  GetRadioChoiceDialog ([Bool]$Success, [Object]$DialogResult, [String]$Item, [Object]$Object)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.Item = $Item
    $This.Object = $Object
  }
}
#endregion GetRadioChoiceDialog Result Class

#region function Show-GetRadioChoiceDialog
Function Show-GetRadioChoiceDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetRadioChoiceDialog
    .DESCRIPTION
      Shows Show-GetRadioChoiceDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER Selected
    .PARAMETER OrderedItems
    .PARAMETER Width
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetRadioChoiceDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText = "Status Message",
    [Object]$Selected = "",
    [parameter(Mandatory = $True)]
    [System.Collections.Specialized.OrderedDictionary]$OrderedItems,
    [Int]$Width = 35,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-GetRadioChoiceDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** GetRadioChoiceDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # GetRadioChoiceDialog Form
  # ************************************************
  #region $GetRadioChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetRadioChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetRadioChoiceDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetRadioChoiceDialogForm.Font = [MyConfig]::Font.Regular
  $GetRadioChoiceDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetRadioChoiceDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetRadioChoiceDialogForm.Icon = $FCGForm.Icon
  $GetRadioChoiceDialogForm.KeyPreview = $True
  $GetRadioChoiceDialogForm.MaximizeBox = $False
  $GetRadioChoiceDialogForm.MinimizeBox = $False
  $GetRadioChoiceDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), 0)
  $GetRadioChoiceDialogForm.Name = "GetRadioChoiceDialogForm"
  $GetRadioChoiceDialogForm.Owner = $FCGForm
  $GetRadioChoiceDialogForm.ShowInTaskbar = $False
  $GetRadioChoiceDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetRadioChoiceDialogForm.Text = $DialogTitle
  #endregion $GetRadioChoiceDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-GetRadioChoiceDialogFormKeyDown ********
  Function Start-GetRadioChoiceDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetRadioChoiceDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetRadioChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetRadioChoiceDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By CDUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetRadioChoiceDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetRadioChoiceDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetRadioChoiceDialogForm"
  }
  #endregion ******** Function Start-GetRadioChoiceDialogFormKeyDown ********
  $GetRadioChoiceDialogForm.add_KeyDown({ Start-GetRadioChoiceDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetRadioChoiceDialogFormShown ********
  Function Start-GetRadioChoiceDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetRadioChoiceDialog Form Control
      .DESCRIPTION
        Shown Event for the GetRadioChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetRadioChoiceDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$GetRadioChoiceDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$GetRadioChoiceDialogForm"
  }
  #endregion ******** Function Start-GetRadioChoiceDialogFormShown ********
  $GetRadioChoiceDialogForm.add_Shown({ Start-GetRadioChoiceDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for GetRadioChoiceDialog Form ********
  
  # ************************************************
  # GetRadioChoiceDialogMain Panel
  # ************************************************
  #region $GetRadioChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetRadioChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetRadioChoiceDialogForm.Controls.Add($GetRadioChoiceDialogMainPanel)
  $GetRadioChoiceDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetRadioChoiceDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetRadioChoiceDialogMainPanel.Name = "GetRadioChoiceDialogMainPanel"
  #$GetRadioChoiceDialogMainPanel.Padding = [System.Windows.Forms.Padding]::New(([MyConfig]::FormSpacer * [MyConfig]::FormSpacer), 0, ([MyConfig]::FormSpacer * [MyConfig]::FormSpacer), 0)
  $GetRadioChoiceDialogMainPanel.Text = "GetRadioChoiceDialogMainPanel"
  #endregion $GetRadioChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetRadioChoiceDialogMainPanel Controls ********
  
  If ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $GetRadioChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetRadioChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetRadioChoiceDialogMainPanel.Controls.Add($GetRadioChoiceDialogMainLabel)
    $GetRadioChoiceDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $GetRadioChoiceDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $GetRadioChoiceDialogMainLabel.Name = "GetRadioChoiceDialogMainLabel"
    $GetRadioChoiceDialogMainLabel.Size = [System.Drawing.Size]::New(($GetRadioChoiceDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $GetRadioChoiceDialogMainLabel.Text = $MessageText
    #endregion $GetRadioChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    
    # Returns the minimum size required to display the text
    $GetRadioChoiceDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetRadioChoiceDialogMainLabel.Text, $GetRadioChoiceDialogMainLabel.Font, $GetRadioChoiceDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))
    
    $TempBottom = $GetRadioChoiceDialogMainLabel.Bottom + [MyConfig]::FormSpacer
  }
  Else
  {
    $TempBottom = [MyConfig]::FormSpacer
  }
  
  # ************************************************
  # GetRadioChoiceDialogMain GroupBox
  # ************************************************
  #region $GetRadioChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  $GetRadioChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  # Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetRadioChoiceDialogMainPanel.Controls.Add($GetRadioChoiceDialogMainGroupBox)
  $GetRadioChoiceDialogMainGroupBox.BackColor = [MyConfig]::Colors.Back
  $GetRadioChoiceDialogMainGroupBox.Font = [MyConfig]::Font.Regular
  $GetRadioChoiceDialogMainGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
  $GetRadioChoiceDialogMainGroupBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TempBottom + [MyConfig]::FormSpacer))
  $GetRadioChoiceDialogMainGroupBox.Name = "GetRadioChoiceDialogMainGroupBox"
  $GetRadioChoiceDialogMainGroupBox.Size = [System.Drawing.Size]::New(($GetRadioChoiceDialogMainPanel.Width - ([MyConfig]::FormSpacer * 2)), 23)
  $GetRadioChoiceDialogMainGroupBox.Text = $Null
  #endregion $GetRadioChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  
  #region ******** $GetRadioChoiceDialogMainGroupBox Controls ********
  
  $GetRadioChoiceNumber = 0
  $GroupBottom = [MyConfig]::Font.Height
  ForEach ($Key In $OrderedItems.Keys)
  {
    #region $GetRadioChoiceDialogMainRadioButton = [System.Windows.Forms.RadioButton]::New()
    $GetRadioChoiceDialogMainRadioButton = [System.Windows.Forms.RadioButton]::New()
    $GetRadioChoiceDialogMainGroupBox.Controls.Add($GetRadioChoiceDialogMainRadioButton)
    #$GetRadioChoiceDialogMainRadioButton.AutoCheck = $True
    $GetRadioChoiceDialogMainRadioButton.AutoSize = $True
    $GetRadioChoiceDialogMainRadioButton.BackColor = [MyConfig]::Colors.Back
    $GetRadioChoiceDialogMainRadioButton.Checked = ($OrderedItems[$Key] -eq $Selected)
    $GetRadioChoiceDialogMainRadioButton.Font = [MyConfig]::Font.Regular
    $GetRadioChoiceDialogMainRadioButton.ForeColor = [MyConfig]::Colors.LabelFore
    $GetRadioChoiceDialogMainRadioButton.Location = [System.Drawing.Point]::New(([MyConfig]::FormSpacer * [MyConfig]::FormSpacer), $GroupBottom)
    $GetRadioChoiceDialogMainRadioButton.Name = "RadioChoice$($GetRadioChoiceNumber)"
    $GetRadioChoiceDialogMainRadioButton.Tag = $OrderedItems[$Key]
    $GetRadioChoiceDialogMainRadioButton.Text = $Key
    #endregion $GetRadioChoiceDialogMainRadioButton = [System.Windows.Forms.RadioButton]::New()
    
    $GroupBottom = ($GetRadioChoiceDialogMainRadioButton.Bottom + [MyConfig]::FormSpacer)
    $GetRadioChoiceNumber += 1
  }
  
  $GetRadioChoiceDialogMainGroupBox.ClientSize = [System.Drawing.Size]::New($GetRadioChoiceDialogMainGroupBox.ClientSize.Width, ($GroupBottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetRadioChoiceDialogMainGroupBox Controls ********
  
  #endregion ******** $GetRadioChoiceDialogMainPanel Controls ********
  
  # ************************************************
  # GetRadioChoiceDialogBtm Panel
  # ************************************************
  #region $GetRadioChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetRadioChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetRadioChoiceDialogForm.Controls.Add($GetRadioChoiceDialogBtmPanel)
  $GetRadioChoiceDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetRadioChoiceDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetRadioChoiceDialogBtmPanel.Name = "GetRadioChoiceDialogBtmPanel"
  $GetRadioChoiceDialogBtmPanel.Text = "GetRadioChoiceDialogBtmPanel"
  #endregion $GetRadioChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetRadioChoiceDialogBtmPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetRadioChoiceDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $GetRadioChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmPanel.Controls.Add($GetRadioChoiceDialogBtmLeftButton)
  $GetRadioChoiceDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetRadioChoiceDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetRadioChoiceDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetRadioChoiceDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetRadioChoiceDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetRadioChoiceDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetRadioChoiceDialogBtmLeftButton.Name = "GetRadioChoiceDialogBtmLeftButton"
  $GetRadioChoiceDialogBtmLeftButton.TabIndex = 1
  $GetRadioChoiceDialogBtmLeftButton.TabStop = $True
  $GetRadioChoiceDialogBtmLeftButton.Text = $ButtonLeft
  $GetRadioChoiceDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetRadioChoiceDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetRadioChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetRadioChoiceDialogBtmLeftButtonClick ********
  Function Start-GetRadioChoiceDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetRadioChoiceDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetRadioChoiceDialogBtmLeft Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetRadioChoiceDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By CDUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetRadioChoiceDialogBtmLeftButton"
    
    [MyConfig]::AutoExit = 0
    
    If (@($GetRadioChoiceDialogMainGroupBox.Controls | Where-Object -FilterScript { ($PSItem.GetType().Name -eq "RadioButton") -and $PSItem.Checked }).Count)
    {
      $GetRadioChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    Else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetRadioChoiceDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetRadioChoiceDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetRadioChoiceDialogBtmLeftButtonClick ********
  $GetRadioChoiceDialogBtmLeftButton.add_Click({ Start-GetRadioChoiceDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetRadioChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmPanel.Controls.Add($GetRadioChoiceDialogBtmMidButton)
  $GetRadioChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetRadioChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetRadioChoiceDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetRadioChoiceDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetRadioChoiceDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetRadioChoiceDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetRadioChoiceDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetRadioChoiceDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetRadioChoiceDialogBtmMidButton.Name = "GetRadioChoiceDialogBtmMidButton"
  $GetRadioChoiceDialogBtmMidButton.TabIndex = 2
  $GetRadioChoiceDialogBtmMidButton.TabStop = $True
  $GetRadioChoiceDialogBtmMidButton.Text = $ButtonMid
  $GetRadioChoiceDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetRadioChoiceDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetRadioChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetRadioChoiceDialogBtmMidButtonClick ********
  Function Start-GetRadioChoiceDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetRadioChoiceDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetRadioChoiceDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetRadioChoiceDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By CDUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetRadioChoiceDialogBtmMidButton"
    
    [MyConfig]::AutoExit = 0
    
    ForEach ($RadioButton In @($GetRadioChoiceDialogMainGroupBox.Controls | Where-Object -FilterScript { $PSItem.Name -Like "RadioChoice*" }))
    {
      $RadioButton.Checked = ($RadioButton.Tag -eq $Selected)
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetRadioChoiceDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetRadioChoiceDialogBtmMidButtonClick ********
  $GetRadioChoiceDialogBtmMidButton.add_Click({ Start-GetRadioChoiceDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetRadioChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetRadioChoiceDialogBtmPanel.Controls.Add($GetRadioChoiceDialogBtmRightButton)
  $GetRadioChoiceDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetRadioChoiceDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetRadioChoiceDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetRadioChoiceDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetRadioChoiceDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetRadioChoiceDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetRadioChoiceDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetRadioChoiceDialogBtmRightButton.Name = "GetRadioChoiceDialogBtmRightButton"
  $GetRadioChoiceDialogBtmRightButton.TabIndex = 3
  $GetRadioChoiceDialogBtmRightButton.TabStop = $True
  $GetRadioChoiceDialogBtmRightButton.Text = $ButtonRight
  $GetRadioChoiceDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetRadioChoiceDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetRadioChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetRadioChoiceDialogBtmRightButtonClick ********
  Function Start-GetRadioChoiceDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetRadioChoiceDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetRadioChoiceDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetRadioChoiceDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By CDUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetRadioChoiceDialogBtmRightButton"
    
    [MyConfig]::AutoExit = 0
    
    # Cancel Code Goes here
    
    $GetRadioChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    
    Write-Verbose -Message "Exit Click Event for `$GetRadioChoiceDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetRadioChoiceDialogBtmRightButtonClick ********
  $GetRadioChoiceDialogBtmRightButton.add_Click({ Start-GetRadioChoiceDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })
  
  $GetRadioChoiceDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetRadioChoiceDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetRadioChoiceDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetRadioChoiceDialogBtmPanel Controls ********
  
  $GetRadioChoiceDialogForm.ClientSize = [System.Drawing.Size]::New($GetRadioChoiceDialogForm.ClientSize.Width, ($GetRadioChoiceDialogMainGroupBox.Bottom + [MyConfig]::FormSpacer + $GetRadioChoiceDialogBtmPanel.Height))
  
  #endregion ******** Controls for GetRadioChoiceDialog Form ********
  
  #endregion ================ End **** GetRadioChoiceDialog **** End ================
  
  $DialogResult = $GetRadioChoiceDialogForm.ShowDialog($TESTForm)
  If ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
  {
    $TempItem = $GetRadioChoiceDialogMainGroupBox.Controls | Where-Object -FilterScript { $PSItem.Name -Like "RadioChoice*" -and $PSItem.Checked } | Select-Object -Property Text, Tag
    [GetRadioChoiceDialog]::New($True, $DialogResult, ($TempItem.Text), ($TempItem.Tag))
  }
  Else
  {
    [GetRadioChoiceDialog]::New($False, $DialogResult)
  }
  
  $GetRadioChoiceDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-GetRadioChoiceDialog"
}
#endregion function Show-GetRadioChoiceDialog

#region GetListViewChoiceDialog Result Class
Class GetListViewChoiceDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [Object]$Item

  GetListViewChoiceDialog ([Bool]$Success, [Object]$DialogResult, [Object]$Item)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.Item = $Item
  }
}
#endregion GetListViewChoiceDialog Result Class

#region function Show-GetListViewChoiceDialog
function Show-GetListViewChoiceDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetListViewChoiceDialog
    .DESCRIPTION
      Shows Show-GetListViewChoiceDialog
    .PARAMETER DialogTitle
    .PARAMETER SelectText
    .PARAMETER MessageText
    .PARAMETER List
    .PARAMETER Property
    .PARAMETER Tooltip
    .PARAMETER Selected
    .PARAMETER Multi
    .PARAMETER Width
    .PARAMETER Height
    .PARAMETER Filter
    .PARAMETER Resize
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetListViewChoiceDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText = "Status Message",
    [parameter(Mandatory = $True)]
    [Object[]]$List = @(),
    [parameter(Mandatory = $True)]
    [String[]]$Property,
    [String]$Tooltip,
    [Object[]]$Selected = "xX NONE Xx",
    [Switch]$Multi,
    [Int]$Width = 50,
    [Int]$Height = 12,
    [Switch]$Filter,
    [Switch]$Resize,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-GetListViewChoiceDialog"

  #region >>>>>>>>>>>>>>>> Begin **** GetListViewChoiceDialog **** Begin <<<<<<<<<<<<<<<<

  # ************************************************
  # GetListViewChoiceDialog Form
  # ************************************************
  #region $GetListViewChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetListViewChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetListViewChoiceDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetListViewChoiceDialogForm.Font = [MyConfig]::Font.Regular
  $GetListViewChoiceDialogForm.ForeColor = [MyConfig]::Colors.Fore
  if ($Resize.IsPresent)
  {
    $GetListViewChoiceDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  }
  else
  {
    $GetListViewChoiceDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  }
  $GetListViewChoiceDialogForm.Icon = $FCGForm.Icon
  $GetListViewChoiceDialogForm.KeyPreview = $True
  $GetListViewChoiceDialogForm.MaximizeBox = $False
  $GetListViewChoiceDialogForm.MinimizeBox = $False
  $GetListViewChoiceDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), 0)
  $GetListViewChoiceDialogForm.Name = "GetListViewChoiceDialogForm"
  $GetListViewChoiceDialogForm.Owner = $FCGForm
  $GetListViewChoiceDialogForm.ShowInTaskbar = $False
  $GetListViewChoiceDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetListViewChoiceDialogForm.Text = $DialogTitle
  #endregion $GetListViewChoiceDialogForm = [System.Windows.Forms.Form]::New()

  #region ******** Function Start-GetListViewChoiceDialogFormKeyDown ********
  function Start-GetListViewChoiceDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetListViewChoiceDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetListViewChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetListViewChoiceDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetListViewChoiceDialogForm"

    [MyConfig]::AutoExit = 0

    if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetListViewChoiceDialogForm.Close()
    }

    Write-Verbose -Message "Exit KeyDown Event for `$GetListViewChoiceDialogForm"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogFormKeyDown ********
  $GetListViewChoiceDialogForm.add_KeyDown({ Start-GetListViewChoiceDialogFormKeyDown -Sender $This -EventArg $PSItem })

  #region ******** Function Start-GetListViewChoiceDialogFormShown ********
  function Start-GetListViewChoiceDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetListViewChoiceDialog Form Control
      .DESCRIPTION
        Shown Event for the GetListViewChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetListViewChoiceDialogFormShown -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Shown Event for `$GetListViewChoiceDialogForm"

    [MyConfig]::AutoExit = 0

    $Sender.Refresh()

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Verbose -Message "Exit Shown Event for `$GetListViewChoiceDialogForm"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogFormShown ********
  $GetListViewChoiceDialogForm.add_Shown({ Start-GetListViewChoiceDialogFormShown -Sender $This -EventArg $PSItem })

  #region ******** Controls for GetListViewChoiceDialog Form ********

  # ************************************************
  # GetListViewChoiceDialogMain Panel
  # ************************************************
  #region $GetListViewChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetListViewChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetListViewChoiceDialogForm.Controls.Add($GetListViewChoiceDialogMainPanel)
  $GetListViewChoiceDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetListViewChoiceDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetListViewChoiceDialogMainPanel.Name = "GetListViewChoiceDialogMainPanel"
  $GetListViewChoiceDialogMainPanel.Text = "GetListViewChoiceDialogMainPanel"
  #endregion $GetListViewChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetListViewChoiceDialogMainPanel Controls ********

  if ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $GetListViewChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetListViewChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetListViewChoiceDialogMainPanel.Controls.Add($GetListViewChoiceDialogMainLabel)
    $GetListViewChoiceDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $GetListViewChoiceDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $GetListViewChoiceDialogMainLabel.Name = "GetListViewChoiceDialogMainLabel"
    $GetListViewChoiceDialogMainLabel.Size = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $GetListViewChoiceDialogMainLabel.Text = $MessageText
    #endregion $GetListViewChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()

    # Returns the minimum size required to display the text
    $GetListViewChoiceDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetListViewChoiceDialogMainLabel.Text, $GetListViewChoiceDialogMainLabel.Font, $GetListViewChoiceDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))

    $TempBottom = $GetListViewChoiceDialogMainLabel.Bottom + [MyConfig]::FormSpacer
  }
  else
  {
    $TempBottom = 0
  }

  #region $GetListViewChoiceDialogMainListView = [System.Windows.Forms.ListView]::New()
  $GetListViewChoiceDialogMainListView = [System.Windows.Forms.ListView]::New()
  $GetListViewChoiceDialogMainPanel.Controls.Add($GetListViewChoiceDialogMainListView)
  $GetListViewChoiceDialogMainListView.BackColor = [MyConfig]::Colors.TextBack
  $GetListViewChoiceDialogMainListView.CheckBoxes = $Multi.IsPresent
  $GetListViewChoiceDialogMainListView.Font = [MyConfig]::Font.Bold
  $GetListViewChoiceDialogMainListView.ForeColor = [MyConfig]::Colors.TextFore
  $GetListViewChoiceDialogMainListView.FullRowSelect = $True
  $GetListViewChoiceDialogMainListView.GridLines = $True
  $GetListViewChoiceDialogMainListView.HeaderStyle = [System.Windows.Forms.ColumnHeaderStyle]::Nonclickable
  $GetListViewChoiceDialogMainListView.HideSelection = $False
  $GetListViewChoiceDialogMainListView.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TempBottom + [MyConfig]::FormSpacer))
  $GetListViewChoiceDialogMainListView.MultiSelect = $Multi.IsPresent
  $GetListViewChoiceDialogMainListView.Name = "LAUGetListViewChoiceDialogMainListView"
  $GetListViewChoiceDialogMainListView.ShowGroups = $False
  $GetListViewChoiceDialogMainListView.ShowItemToolTips = $PSBoundParameters.ContainsKey("ToolTip")
  $GetListViewChoiceDialogMainListView.Size = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ([MyConfig]::Font.Height * $Height))
  $GetListViewChoiceDialogMainListView.Text = "LAUGetListViewChoiceDialogMainListView"
  $GetListViewChoiceDialogMainListView.View = [System.Windows.Forms.View]::Details
  #endregion $GetListViewChoiceDialogMainListView = [System.Windows.Forms.ListView]::New()

  foreach ($PropName in $Property)
  {
    [Void]$GetListViewChoiceDialogMainListView.Columns.Add($PropName, -2)
  }

  ForEach ($Item in $List)
  {
    ($GetListViewChoiceDialogMainListView.Items.Add(($ListViewItem = [System.Windows.Forms.ListViewItem]::New("$($Item.($Property[0]))")))).SubItems.AddRange(@($Property[1..99] | ForEach-Object -Process { "$($Item.($PSItem))" }))
    $ListViewItem.Name = "$($Item.($Property[0]))"
    $ListViewItem.Tag = $Item
    $ListViewItem.Tooltiptext = "$($Item.($Tooltip))"
    $ListViewItem.Selected = ($Item -in $Selected)
    $ListViewItem.Checked = ($Multi.IsPresent -and $ListViewItem.Selected)
    $ListViewItem.Font = [MyConfig]::Font.Regular
  }
  $GetListViewChoiceDialogMainListView.Tag = @($GetListViewChoiceDialogMainListView.Items)
  
  If ($Filter.IsPresent)
  {
    #region $GetListViewChoiceDialogFilterLabel = [System.Windows.Forms.Label]::New()
    $GetListViewChoiceDialogFilterLabel = [System.Windows.Forms.Label]::New()
    $GetListViewChoiceDialogMainPanel.Controls.Add($GetListViewChoiceDialogFilterLabel)
    $GetListViewChoiceDialogFilterLabel.AutoSize = $True
    $GetListViewChoiceDialogFilterLabel.BackColor = [MyConfig]::Colors.Back
    $GetListViewChoiceDialogFilterLabel.Font = [MyConfig]::Font.Regular
    $GetListViewChoiceDialogFilterLabel.ForeColor = [MyConfig]::Colors.Fore
    $GetListViewChoiceDialogFilterLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($GetListViewChoiceDialogMainListView.Bottom + [MyConfig]::FormSpacer))
    $GetListViewChoiceDialogFilterLabel.Name = "GetListViewChoiceDialogFilterLabel"
    $GetListViewChoiceDialogFilterLabel.Size = [System.Drawing.Size]::New(([MyConfig]::Font.Width * [MyConfig]::LabelWidth), $GetListViewChoiceDialogFilterLabel.PreferredHeight)
    $GetListViewChoiceDialogFilterLabel.Text = "Filter List:"
    $GetListViewChoiceDialogFilterLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    #endregion $GetListViewChoiceDialogFilterLabel = [System.Windows.Forms.Label]::New()
    
    #region $GetListViewChoiceDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
    $GetListViewChoiceDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
    $GetListViewChoiceDialogMainPanel.Controls.Add($GetListViewChoiceDialogMainTextBox)
    $GetListViewChoiceDialogMainTextBox.AutoSize = $False
    $GetListViewChoiceDialogMainTextBox.BackColor = [MyConfig]::Colors.TextBack
    $GetListViewChoiceDialogMainTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $GetListViewChoiceDialogMainTextBox.Font = [MyConfig]::Font.Regular
    $GetListViewChoiceDialogMainTextBox.ForeColor = [MyConfig]::Colors.TextFore
    $GetListViewChoiceDialogMainTextBox.Location = [System.Drawing.Point]::New(($GetListViewChoiceDialogFilterLabel.Right + [MyConfig]::FormSpacer), $GetListViewChoiceDialogFilterLabel.Top)
    $GetListViewChoiceDialogMainTextBox.MaxLength = 100
    $GetListViewChoiceDialogMainTextBox.Name = "GetListViewChoiceDialogMainTextBox"
    $GetListViewChoiceDialogMainTextBox.Size = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainListView.Right - $GetListViewChoiceDialogMainTextBox.Left), $GetListViewChoiceDialogFilterLabel.Height)
    #$GetListViewChoiceDialogMainTextBox.TabIndex = 0
    $GetListViewChoiceDialogMainTextBox.TabStop = $False
    $GetListViewChoiceDialogMainTextBox.Tag = @{ "HintText" = "Enter Text and Press [Enter] to Filter List Items."; "HintEnabled" = $True }
    $GetListViewChoiceDialogMainTextBox.Text = ""
    $GetListViewChoiceDialogMainTextBox.WordWrap = $False
    #endregion $GetListViewChoiceDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
    
    #region ******** Function Start-GetListViewChoiceDialogMainTextBoxGotFocus ********
    Function Start-GetListViewChoiceDialogMainTextBoxGotFocus
    {
      <#
        .SYNOPSIS
          GotFocus Event for the GetListViewChoiceDialogMain TextBox Control
        .DESCRIPTION
          GotFocus Event for the GetListViewChoiceDialogMain TextBox Control
        .PARAMETER Sender
           The TextBox Control that fired the GotFocus Event
        .PARAMETER EventArg
           The Event Arguments for the TextBox GotFocus Event
        .EXAMPLE
           Start-GetListViewChoiceDialogMainTextBoxGotFocus -Sender $Sender -EventArg $EventArg
        .NOTES
          Original Function By ken.sweet
      #>
      [CmdletBinding()]
      Param (
        [parameter(Mandatory = $True)]
        [System.Windows.Forms.TextBox]$Sender,
        [parameter(Mandatory = $True)]
        [Object]$EventArg
      )
      Write-Verbose -Message "Enter GotFocus Event for `$GetListViewChoiceDialogMainTextBox"
      
      [MyConfig]::AutoExit = 0
      
      # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
      If ($Sender.Tag.HintEnabled)
      {
        $Sender.Text = ""
        $Sender.Font = [MyConfig]::Font.Regular
        $Sender.ForeColor = [MyConfig]::Colors.TextFore
      }
      
      Write-Verbose -Message "Exit GotFocus Event for `$GetListViewChoiceDialogMainTextBox"
    }
    #endregion ******** Function Start-GetListViewChoiceDialogMainTextBoxGotFocus ********
    $GetListViewChoiceDialogMainTextBox.add_GotFocus({ Start-GetListViewChoiceDialogMainTextBoxGotFocus -Sender $This -EventArg $PSItem })
    
    #region ******** Function Start-GetListViewChoiceDialogMainTextBoxKeyDown ********
    Function Start-GetListViewChoiceDialogMainTextBoxKeyDown
    {
      <#
        .SYNOPSIS
          KeyDown Event for the GetListViewChoiceDialogMain TextBox Control
        .DESCRIPTION
          KeyDown Event for the GetListViewChoiceDialogMain TextBox Control
        .PARAMETER Sender
           The TextBox Control that fired the KeyDown Event
        .PARAMETER EventArg
           The Event Arguments for the TextBox KeyDown Event
        .EXAMPLE
           Start-GetListViewChoiceDialogMainTextBoxKeyDown -Sender $Sender -EventArg $EventArg
        .NOTES
          Original Function By ken.sweet
      #>
      [CmdletBinding()]
      Param (
        [parameter(Mandatory = $True)]
        [System.Windows.Forms.TextBox]$Sender,
        [parameter(Mandatory = $True)]
        [Object]$EventArg
      )
      Write-Verbose -Message "Enter KeyDown Event for `$GetListViewChoiceDialogMainTextBox"
      
      [MyConfig]::AutoExit = 0
      
      If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Enter)
      {
        # Suppress KeyPress
        $EventArg.SuppressKeyPress = $True
        
        If ([String]::IsNullOrEmpty($Sender.Text.Trim()))
        {
          $GetListViewChoiceDialogMainListView.Items.Clear()
          $GetListViewChoiceDialogMainListView.Items.AddRange($GetListViewChoiceDialogMainListView.Tag)
        }
        else
        {
          $TmpNewList = @($GetListViewChoiceDialogMainListView.Tag | Where-Object -FilterScript { ($PSItem.Text -Match $Sender.Text) -or ($PSItem.SubItems[1].Text -Match $Sender.Text) })
          $GetListViewChoiceDialogMainListView.Items.Clear()
          $GetListViewChoiceDialogMainListView.Items.AddRange($TmpNewList)
        }
      }
      
      Write-Verbose -Message "Exit KeyDown Event for `$GetListViewChoiceDialogMainTextBox"
    }
    #endregion ******** Function Start-GetListViewChoiceDialogMainTextBoxKeyDown ********
    $GetListViewChoiceDialogMainTextBox.add_KeyDown({ Start-GetListViewChoiceDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem })
    
    #region ******** Function Start-GetListViewChoiceDialogMainTextBoxLostFocus ********
    Function Start-GetListViewChoiceDialogMainTextBoxLostFocus
    {
      <#
        .SYNOPSIS
          LostFocus Event for the GetListViewChoiceDialogMain TextBox Control
        .DESCRIPTION
          LostFocus Event for the GetListViewChoiceDialogMain TextBox Control
        .PARAMETER Sender
           The TextBox Control that fired the LostFocus Event
        .PARAMETER EventArg
           The Event Arguments for the TextBox LostFocus Event
        .EXAMPLE
           Start-GetListViewChoiceDialogMainTextBoxLostFocus -Sender $Sender -EventArg $EventArg
        .NOTES
          Original Function By ken.sweet
      #>
      [CmdletBinding()]
      Param (
        [parameter(Mandatory = $True)]
        [System.Windows.Forms.TextBox]$Sender,
        [parameter(Mandatory = $True)]
        [Object]$EventArg
      )
      Write-Verbose -Message "Enter LostFocus Event for `$GetListViewChoiceDialogMainTextBox"
      
      [MyConfig]::AutoExit = 0
      
      # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
      If ([String]::IsNullOrEmpty(($Sender.Text.Trim())))
      {
        $Sender.Text = $Sender.Tag.HintText
        $Sender.Tag.HintEnabled = $True
        $Sender.Font = [MyConfig]::Font.Hint
        $Sender.ForeColor = [MyConfig]::Colors.TextHint
        
        $GetListViewChoiceDialogMainListView.Items.Clear()
        $GetListViewChoiceDialogMainListView.Items.AddRange($GetListViewChoiceDialogMainListView.Tag)
      }
      Else
      {
        $Sender.Tag.HintEnabled = $False
        $Sender.Font = [MyConfig]::Font.Regular
        $Sender.ForeColor = [MyConfig]::Colors.TextFore
        
        $TmpNewList = @($GetListViewChoiceDialogMainListView.Tag | Where-Object -FilterScript { ($PSItem.Text -Match $GetListViewChoiceDialogMainTextBox.Text) -or ($PSItem.SubItems[1].Text -Match $GetListViewChoiceDialogMainTextBox.Text) })
        $GetListViewChoiceDialogMainListView.Items.Clear()
        $GetListViewChoiceDialogMainListView.Items.AddRange($TmpNewList)
      }
      
      Write-Verbose -Message "Exit LostFocus Event for `$GetListViewChoiceDialogMainTextBox"
    }
    #endregion ******** Function Start-GetListViewChoiceDialogMainTextBoxLostFocus ********
    $GetListViewChoiceDialogMainTextBox.add_LostFocus({ Start-GetListViewChoiceDialogMainTextBoxLostFocus -Sender $This -EventArg $PSItem })
    
    Start-GetListViewChoiceDialogMainTextBoxLostFocus -Sender $GetListViewChoiceDialogMainTextBox -EventArg "Lost Focus"
    
    $TempClientSize = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainTextBox.Right + [MyConfig]::FormSpacer), ($GetListViewChoiceDialogMainTextBox.Bottom + [MyConfig]::FormSpacer))
  }
  Else
  {
    $TempClientSize = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainListView.Right + [MyConfig]::FormSpacer), ($GetListViewChoiceDialogMainListView.Bottom + [MyConfig]::FormSpacer))
  }

  #endregion ******** $GetListViewChoiceDialogMainPanel Controls ********

  # ************************************************
  # GetListViewChoiceDialogBtm Panel
  # ************************************************
  #region $GetListViewChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetListViewChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetListViewChoiceDialogForm.Controls.Add($GetListViewChoiceDialogBtmPanel)
  $GetListViewChoiceDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetListViewChoiceDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetListViewChoiceDialogBtmPanel.Name = "GetListViewChoiceDialogBtmPanel"
  $GetListViewChoiceDialogBtmPanel.Text = "GetListViewChoiceDialogBtmPanel"
  #endregion $GetListViewChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetListViewChoiceDialogBtmPanel Controls ********

  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetListViewChoiceDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons

  #region $GetListViewChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmPanel.Controls.Add($GetListViewChoiceDialogBtmLeftButton)
  $GetListViewChoiceDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetListViewChoiceDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetListViewChoiceDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetListViewChoiceDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetListViewChoiceDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetListViewChoiceDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetListViewChoiceDialogBtmLeftButton.Name = "GetListViewChoiceDialogBtmLeftButton"
  $GetListViewChoiceDialogBtmLeftButton.TabIndex = 1
  $GetListViewChoiceDialogBtmLeftButton.TabStop = $True
  $GetListViewChoiceDialogBtmLeftButton.Text = $ButtonLeft
  $GetListViewChoiceDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetListViewChoiceDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetListViewChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetListViewChoiceDialogBtmLeftButtonClick ********
  function Start-GetListViewChoiceDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetListViewChoiceDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetListViewChoiceDialogBtmLeft Button Control
      .PARAMETER Sender
         The Button Control that fired the Click Event
      .PARAMETER EventArg
         The Event Arguments for the Button Click Event
      .EXAMPLE
         Start-GetListViewChoiceDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetListViewChoiceDialogBtmLeftButton"

    [MyConfig]::AutoExit = 0

    if (($GetListViewChoiceDialogMainListView.SelectedItems.Count -and (-not $Multi.IsPresent)) -or ($GetListViewChoiceDialogMainListView.CheckedItems.Count -and $Multi.IsPresent))
    {
      $GetListViewChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetListViewChoiceDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }

    Write-Verbose -Message "Exit Click Event for `$GetListViewChoiceDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogBtmLeftButtonClick ********
  $GetListViewChoiceDialogBtmLeftButton.add_Click({ Start-GetListViewChoiceDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })

  #region $GetListViewChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmPanel.Controls.Add($GetListViewChoiceDialogBtmMidButton)
  $GetListViewChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetListViewChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetListViewChoiceDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetListViewChoiceDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetListViewChoiceDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetListViewChoiceDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetListViewChoiceDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetListViewChoiceDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetListViewChoiceDialogBtmMidButton.Name = "GetListViewChoiceDialogBtmMidButton"
  $GetListViewChoiceDialogBtmMidButton.TabIndex = 2
  $GetListViewChoiceDialogBtmMidButton.TabStop = $True
  $GetListViewChoiceDialogBtmMidButton.Text = $ButtonMid
  $GetListViewChoiceDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetListViewChoiceDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetListViewChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetListViewChoiceDialogBtmMidButtonClick ********
  function Start-GetListViewChoiceDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetListViewChoiceDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetListViewChoiceDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetListViewChoiceDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By MyUserName)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetListViewChoiceDialogBtmMidButton"

    [MyConfig]::AutoExit = 0

    if ([String]::IsNullOrEmpty($Selected))
    {
      $GetListViewChoiceDialogMainListView.SelectedItems.Clear()
      $GetListViewChoiceDialogMainListView.Items | ForEach-Object -Process { $PSItem.Checked = $False }
    }
    else
    {
      foreach ($Item in $GetListViewChoiceDialogMainListView.Items)
      {
        $Item.Selected = ($Item.Tag -in $Selected)
        $Item.Checked = ($Multi.IsPresent -and $Item.Selected)
      }
    }
    $GetListViewChoiceDialogMainListView.Refresh()
    $GetListViewChoiceDialogMainListView.Select()

    Write-Verbose -Message "Exit Click Event for `$GetListViewChoiceDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogBtmMidButtonClick ********
  $GetListViewChoiceDialogBtmMidButton.add_Click({ Start-GetListViewChoiceDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })

  #region $GetListViewChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetListViewChoiceDialogBtmPanel.Controls.Add($GetListViewChoiceDialogBtmRightButton)
  $GetListViewChoiceDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetListViewChoiceDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetListViewChoiceDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetListViewChoiceDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetListViewChoiceDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetListViewChoiceDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetListViewChoiceDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetListViewChoiceDialogBtmRightButton.Name = "GetListViewChoiceDialogBtmRightButton"
  $GetListViewChoiceDialogBtmRightButton.TabIndex = 3
  $GetListViewChoiceDialogBtmRightButton.TabStop = $True
  $GetListViewChoiceDialogBtmRightButton.Text = $ButtonRight
  $GetListViewChoiceDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetListViewChoiceDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetListViewChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetListViewChoiceDialogBtmRightButtonClick ********
  function Start-GetListViewChoiceDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetListViewChoiceDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetListViewChoiceDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetListViewChoiceDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetListViewChoiceDialogBtmRightButton"

    [MyConfig]::AutoExit = 0

    # Cancel Code Goes here

    $GetListViewChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    Write-Verbose -Message "Exit Click Event for `$GetListViewChoiceDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogBtmRightButtonClick ********
  $GetListViewChoiceDialogBtmRightButton.add_Click({ Start-GetListViewChoiceDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })

  $GetListViewChoiceDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetListViewChoiceDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetListViewChoiceDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $GetListViewChoiceDialogBtmPanel Controls ********

  $GetListViewChoiceDialogForm.ClientSize = [System.Drawing.Size]::New($GetListViewChoiceDialogForm.ClientSize.Width, ($TempClientSize.Height + $GetListViewChoiceDialogBtmPanel.Height))
  $GetListViewChoiceDialogForm.MinimumSize = $GetListViewChoiceDialogForm.Size
  $GetListViewChoiceDialogMainListView.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom, Right")
  If ($Filter.IsPresent)
  {
    $GetListViewChoiceDialogFilterLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Left, Bottom")
    $GetListViewChoiceDialogMainTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Left, Bottom, Right")
  }

  #endregion ******** Controls for GetListViewChoiceDialog Form ********

  #endregion ================ End **** GetListViewChoiceDialog **** End ================

  $DialogResult = $GetListViewChoiceDialogForm.ShowDialog($LAUForm)
  if ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
  {
    if ($Multi.IsPresent)
    {
      [GetListViewChoiceDialog]::New($True, $DialogResult, ($GetListViewChoiceDialogMainListView.CheckedItems | Select-Object -ExpandProperty "Tag"))
    }
    else
    {
      [GetListViewChoiceDialog]::New($True, $DialogResult, ($GetListViewChoiceDialogMainListView.SelectedItems | Select-Object -ExpandProperty "Tag"))
    }
  }
  else
  {
    [GetListViewChoiceDialog]::New($False, $DialogResult, "")
  }

  $GetListViewChoiceDialogForm.Dispose()

  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()

  Write-Verbose -Message "Exit Function Show-GetListViewChoiceDialog"
}
#endregion function Show-GetListViewChoiceDialog

#region GetComboChoiceDialog Result Class
Class GetComboChoiceDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [Object]$Item

  GetComboChoiceDialog ([Bool]$Success, [Object]$DialogResult, [Object]$Item)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.Item = $Item
  }
}
#endregion GetComboChoiceDialog Result Class

#region function Show-GetComboChoiceDialog
function Show-GetComboChoiceDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetComboChoiceDialog
    .DESCRIPTION
      Shows Show-GetComboChoiceDialog
    .PARAMETER DialogTitle
    .PARAMETER SelectText
    .PARAMETER MessageText
    .PARAMETER Items
    .PARAMETER Sorted
    .PARAMETER DisplayMember
    .PARAMETER ValueMember
    .PARAMETER Selected
    .PARAMETER Width
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetComboChoiceDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText = "Status Message",
    [String]$SelectText = "Select Value",
    [parameter(Mandatory = $True)]
    [Object[]]$Items = @(),
    [Switch]$Sorted,
    [String]$DisplayMember = "Text",
    [String]$ValueMember = "Value",
    [Object]$Selected,
    [Int]$Width = 35,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-GetComboChoiceDialog"

  #region >>>>>>>>>>>>>>>> Begin **** GetComboChoiceDialog **** Begin <<<<<<<<<<<<<<<<

  # ************************************************
  # GetComboChoiceDialog Form
  # ************************************************
  #region $GetComboChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetComboChoiceDialogForm = [System.Windows.Forms.Form]::New()
  $GetComboChoiceDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetComboChoiceDialogForm.Font = [MyConfig]::Font.Regular
  $GetComboChoiceDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetComboChoiceDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetComboChoiceDialogForm.Icon = $FCGForm.Icon
  $GetComboChoiceDialogForm.KeyPreview = $True
  $GetComboChoiceDialogForm.MaximizeBox = $False
  $GetComboChoiceDialogForm.MinimizeBox = $False
  $GetComboChoiceDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), 0)
  $GetComboChoiceDialogForm.Name = "GetComboChoiceDialogForm"
  $GetComboChoiceDialogForm.Owner = $FCGForm
  $GetComboChoiceDialogForm.ShowInTaskbar = $False
  $GetComboChoiceDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetComboChoiceDialogForm.Text = $DialogTitle
  #endregion $GetComboChoiceDialogForm = [System.Windows.Forms.Form]::New()

  #region ******** Function Start-GetComboChoiceDialogFormKeyDown ********
  function Start-GetComboChoiceDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetComboChoiceDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetComboChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetComboChoiceDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetComboChoiceDialogForm"

    [MyConfig]::AutoExit = 0

    if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetComboChoiceDialogForm.Close()
    }

    Write-Verbose -Message "Exit KeyDown Event for `$GetComboChoiceDialogForm"
  }
  #endregion ******** Function Start-GetComboChoiceDialogFormKeyDown ********
  $GetComboChoiceDialogForm.add_KeyDown({ Start-GetComboChoiceDialogFormKeyDown -Sender $This -EventArg $PSItem })

  #region ******** Function Start-GetComboChoiceDialogFormShown ********
  function Start-GetComboChoiceDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetComboChoiceDialog Form Control
      .DESCRIPTION
        Shown Event for the GetComboChoiceDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetComboChoiceDialogFormShown -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Shown Event for `$GetComboChoiceDialogForm"

    [MyConfig]::AutoExit = 0

    $Sender.Refresh()

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Verbose -Message "Exit Shown Event for `$GetComboChoiceDialogForm"
  }
  #endregion ******** Function Start-GetComboChoiceDialogFormShown ********
  $GetComboChoiceDialogForm.add_Shown({ Start-GetComboChoiceDialogFormShown -Sender $This -EventArg $PSItem })

  #region ******** Controls for GetComboChoiceDialog Form ********

  # ************************************************
  # GetComboChoiceDialogMain Panel
  # ************************************************
  #region $GetComboChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetComboChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetComboChoiceDialogForm.Controls.Add($GetComboChoiceDialogMainPanel)
  $GetComboChoiceDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetComboChoiceDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetComboChoiceDialogMainPanel.Name = "GetComboChoiceDialogMainPanel"
  $GetComboChoiceDialogMainPanel.Text = "GetComboChoiceDialogMainPanel"
  #endregion $GetComboChoiceDialogMainPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetComboChoiceDialogMainPanel Controls ********

  if ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $GetComboChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetComboChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()
    $GetComboChoiceDialogMainPanel.Controls.Add($GetComboChoiceDialogMainLabel)
    $GetComboChoiceDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $GetComboChoiceDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $GetComboChoiceDialogMainLabel.Name = "GetComboChoiceDialogMainLabel"
    $GetComboChoiceDialogMainLabel.Size = [System.Drawing.Size]::New(($GetComboChoiceDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $GetComboChoiceDialogMainLabel.Text = $MessageText
    #endregion $GetComboChoiceDialogMainLabel = [System.Windows.Forms.Label]::New()

    # Returns the minimum size required to display the text
    $GetComboChoiceDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetComboChoiceDialogMainLabel.Text, $GetComboChoiceDialogMainLabel.Font, $GetComboChoiceDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))

    $TmpBottom = $GetComboChoiceDialogMainLabel.Bottom + [MyConfig]::FormSpacer
  }
  else
  {
    $TmpBottom = 0
  }
  
  # ************************************************
  # GetComboChoiceDialogMain GroupBox
  # ************************************************
  #region $GetComboChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  $GetComboChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  # Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetComboChoiceDialogMainPanel.Controls.Add($GetComboChoiceDialogMainGroupBox)
  $GetComboChoiceDialogMainGroupBox.BackColor = [MyConfig]::Colors.Back
  $GetComboChoiceDialogMainGroupBox.Font = [MyConfig]::Font.Regular
  $GetComboChoiceDialogMainGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
  $GetComboChoiceDialogMainGroupBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TmpBottom + [MyConfig]::FormSpacer))
  $GetComboChoiceDialogMainGroupBox.Name = "GetComboChoiceDialogMainGroupBox"
  $GetComboChoiceDialogMainGroupBox.Size = [System.Drawing.Size]::New(($GetComboChoiceDialogMainPanel.Width - ([MyConfig]::FormSpacer * 2)), 50)
  $GetComboChoiceDialogMainGroupBox.Text = $Null
  #endregion $GetComboChoiceDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  
  #region ******** $GetComboChoiceDialogMainGroupBox Controls ********
  
  #region $GetComboChoiceComboBox = [System.Windows.Forms.ComboBox]::New()
  $GetComboChoiceComboBox = [System.Windows.Forms.ComboBox]::New()
  $GetComboChoiceDialogMainGroupBox.Controls.Add($GetComboChoiceComboBox)
  $GetComboChoiceComboBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom")
  $GetComboChoiceComboBox.AutoSize = $True
  $GetComboChoiceComboBox.BackColor = [MyConfig]::Colors.TextBack
  $GetComboChoiceComboBox.DisplayMember = $DisplayMember
  $GetComboChoiceComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
  $GetComboChoiceComboBox.Font = [MyConfig]::Font.Regular
  $GetComboChoiceComboBox.ForeColor = [MyConfig]::Colors.TextFore
  [void]$GetComboChoiceComboBox.Items.Add([PSCustomObject]@{ $DisplayMember = " - $($SelectText) - "; $ValueMember = " - $($SelectText) - "})
  $GetComboChoiceComboBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetComboChoiceComboBox.Name = "GetComboChoiceComboBox"
  $GetComboChoiceComboBox.SelectedIndex = 0
  $GetComboChoiceComboBox.Size = [System.Drawing.Size]::New(($GetComboChoiceDialogMainGroupBox.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), $GetComboChoiceComboBox.PreferredHeight)
  $GetComboChoiceComboBox.Sorted = $Sorted.IsPresent
  $GetComboChoiceComboBox.TabIndex = 0
  $GetComboChoiceComboBox.TabStop = $True
  $GetComboChoiceComboBox.Tag = $Null
  $GetComboChoiceComboBox.Text = "GetComboChoiceComboBox"
  $GetComboChoiceComboBox.ValueMember = $ValueMember
  #endregion $GetComboChoiceComboBox = [System.Windows.Forms.ComboBox]::New()

  $GetComboChoiceComboBox.Items.AddRange($Items)

  if ($PSBoundParameters.ContainsKey("Selected"))
  {
    $GetComboChoiceComboBox.Tag = $Items | Where-Object -FilterScript { $PSItem -eq $Selected}
    $GetComboChoiceComboBox.SelectedItem = $GetComboChoiceComboBox.Tag
  }
  else
  {
    $GetComboChoiceComboBox.SelectedIndex = 0
  }
  
  $GetComboChoiceDialogMainGroupBox.ClientSize = [System.Drawing.Size]::New($GetComboChoiceDialogMainGroupBox.ClientSize.Width, ($GetComboChoiceComboBox.Bottom + ([MyConfig]::FormSpacer * 2)))
  
  #endregion ******** $GetComboChoiceDialogMainGroupBox Controls ********

  $TempClientSize = [System.Drawing.Size]::New(($GetComboChoiceDialogMainGroupBox.Right + [MyConfig]::FormSpacer), ($GetComboChoiceDialogMainGroupBox.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $GetComboChoiceDialogMainPanel Controls ********

  # ************************************************
  # GetComboChoiceDialogBtm Panel
  # ************************************************
  #region $GetComboChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetComboChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetComboChoiceDialogForm.Controls.Add($GetComboChoiceDialogBtmPanel)
  $GetComboChoiceDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetComboChoiceDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetComboChoiceDialogBtmPanel.Name = "GetComboChoiceDialogBtmPanel"
  $GetComboChoiceDialogBtmPanel.Text = "GetComboChoiceDialogBtmPanel"
  #endregion $GetComboChoiceDialogBtmPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $GetComboChoiceDialogBtmPanel Controls ********

  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetComboChoiceDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons

  #region $GetComboChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmPanel.Controls.Add($GetComboChoiceDialogBtmLeftButton)
  $GetComboChoiceDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetComboChoiceDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboChoiceDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboChoiceDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetComboChoiceDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboChoiceDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetComboChoiceDialogBtmLeftButton.Name = "GetComboChoiceDialogBtmLeftButton"
  $GetComboChoiceDialogBtmLeftButton.TabIndex = 1
  $GetComboChoiceDialogBtmLeftButton.TabStop = $True
  $GetComboChoiceDialogBtmLeftButton.Text = $ButtonLeft
  $GetComboChoiceDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetComboChoiceDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetComboChoiceDialogBtmLeftButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetComboChoiceDialogBtmLeftButtonClick ********
  function Start-GetComboChoiceDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboChoiceDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetComboChoiceDialogBtmLeft Button Control
      .PARAMETER Sender
         The Button Control that fired the Click Event
      .PARAMETER EventArg
         The Event Arguments for the Button Click Event
      .EXAMPLE
         Start-GetComboChoiceDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboChoiceDialogBtmLeftButton"

    [MyConfig]::AutoExit = 0

    if ($GetComboChoiceComboBox.SelectedIndex -gt 0)
    {
      $GetComboChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetComboChoiceDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }

    Write-Verbose -Message "Exit Click Event for `$GetComboChoiceDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetComboChoiceDialogBtmLeftButtonClick ********
  $GetComboChoiceDialogBtmLeftButton.add_Click({ Start-GetComboChoiceDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })

  #region $GetComboChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmPanel.Controls.Add($GetComboChoiceDialogBtmMidButton)
  $GetComboChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetComboChoiceDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetComboChoiceDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboChoiceDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboChoiceDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetComboChoiceDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboChoiceDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetComboChoiceDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetComboChoiceDialogBtmMidButton.Name = "GetComboChoiceDialogBtmMidButton"
  $GetComboChoiceDialogBtmMidButton.TabIndex = 2
  $GetComboChoiceDialogBtmMidButton.TabStop = $True
  $GetComboChoiceDialogBtmMidButton.Text = $ButtonMid
  $GetComboChoiceDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetComboChoiceDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetComboChoiceDialogBtmMidButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetComboChoiceDialogBtmMidButtonClick ********
  function Start-GetComboChoiceDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboChoiceDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetComboChoiceDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetComboChoiceDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By MyUserName)
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboChoiceDialogBtmMidButton"

    [MyConfig]::AutoExit = 0

    if ([String]::IsNullOrEmpty($GetComboChoiceComboBox.Tag))
    {
      $GetComboChoiceComboBox.SelectedIndex = 0
    }
    else
    {
      $GetComboChoiceComboBox.SelectedItem = $GetComboChoiceComboBox.Tag
    }

    Write-Verbose -Message "Exit Click Event for `$GetComboChoiceDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetComboChoiceDialogBtmMidButtonClick ********
  $GetComboChoiceDialogBtmMidButton.add_Click({ Start-GetComboChoiceDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })

  #region $GetComboChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetComboChoiceDialogBtmPanel.Controls.Add($GetComboChoiceDialogBtmRightButton)
  $GetComboChoiceDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetComboChoiceDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboChoiceDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboChoiceDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetComboChoiceDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboChoiceDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetComboChoiceDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetComboChoiceDialogBtmRightButton.Name = "GetComboChoiceDialogBtmRightButton"
  $GetComboChoiceDialogBtmRightButton.TabIndex = 3
  $GetComboChoiceDialogBtmRightButton.TabStop = $True
  $GetComboChoiceDialogBtmRightButton.Text = $ButtonRight
  $GetComboChoiceDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetComboChoiceDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetComboChoiceDialogBtmRightButton = [System.Windows.Forms.Button]::New()

  #region ******** Function Start-GetComboChoiceDialogBtmRightButtonClick ********
  function Start-GetComboChoiceDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboChoiceDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetComboChoiceDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetComboChoiceDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboChoiceDialogBtmRightButton"

    [MyConfig]::AutoExit = 0

    # Cancel Code Goes here

    $GetComboChoiceDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    Write-Verbose -Message "Exit Click Event for `$GetComboChoiceDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetComboChoiceDialogBtmRightButtonClick ********
  $GetComboChoiceDialogBtmRightButton.add_Click({ Start-GetComboChoiceDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })

  $GetComboChoiceDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetComboChoiceDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetComboChoiceDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $GetComboChoiceDialogBtmPanel Controls ********

  $GetComboChoiceDialogForm.ClientSize = [System.Drawing.Size]::New($GetComboChoiceDialogForm.ClientSize.Width, ($TempClientSize.Height + $GetComboChoiceDialogBtmPanel.Height))
  
  #endregion ******** Controls for GetComboChoiceDialog Form ********

  #endregion ================ End **** GetComboChoiceDialog **** End ================

  $DialogResult = $GetComboChoiceDialogForm.ShowDialog()
  [GetComboChoiceDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, $GetComboChoiceComboBox.SelectedItem)

  $GetComboChoiceDialogForm.Dispose()

  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()

  Write-Verbose -Message "Exit Function Show-GetComboChoiceDialog"
}
#endregion function Show-GetComboChoiceDialog

#region GetComboFilterDialog Result Class
Class GetComboFilterDialog
{
  [Bool]$Success
  [Object]$DialogResult
  [HashTable]$Values
  
  GetComboFilterDialog ([Bool]$Success, [Object]$DialogResult, [HashTable]$Values)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
    $This.Values = $Values
  }
}
#endregion GetComboFilterDialog Result Class

#region function Show-GetComboFilterDialog
Function Show-GetComboFilterDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-GetComboFilterDialog
    .DESCRIPTION
      Shows Show-GetComboFilterDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER Items
    .PARAMETER Properties
    .PARAMETER Selected
    .PARAMETER Width
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .EXAMPLE
      $Return = Show-GetComboFilterDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [parameter(Mandatory = $True)]
    [String]$MessageText = "Status Message",
    [Object[]]$Items = @(),
    [String[]]$Properties,
    [HashTable]$Selected = @{},
    [Int]$Width = 35,
    [String]$ButtonLeft = "&OK",
    [String]$ButtonMid = "&Reset",
    [String]$ButtonRight = "&Cancel"
  )
  Write-Verbose -Message "Enter Function Show-GetComboFilterDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** GetComboFilterDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # GetComboFilterDialog Form
  # ************************************************
  #region $GetComboFilterDialogForm = [System.Windows.Forms.Form]::New()
  $GetComboFilterDialogForm = [System.Windows.Forms.Form]::New()
  $GetComboFilterDialogForm.BackColor = [MyConfig]::Colors.Back
  $GetComboFilterDialogForm.Font = [MyConfig]::Font.Regular
  $GetComboFilterDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $GetComboFilterDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $GetComboFilterDialogForm.Icon = $FCGForm.Icon
  $GetComboFilterDialogForm.KeyPreview = $True
  $GetComboFilterDialogForm.MaximizeBox = $False
  $GetComboFilterDialogForm.MinimizeBox = $False
  $GetComboFilterDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), 0)
  $GetComboFilterDialogForm.Name = "GetComboFilterDialogForm"
  $GetComboFilterDialogForm.Owner = $FCGForm
  $GetComboFilterDialogForm.ShowInTaskbar = $False
  $GetComboFilterDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $GetComboFilterDialogForm.Text = $DialogTitle
  #endregion $GetComboFilterDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-GetComboFilterDialogFormKeyDown ********
  Function Start-GetComboFilterDialogFormKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetComboFilterDialog Form Control
      .DESCRIPTION
        KeyDown Event for the GetComboFilterDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the KeyDown Event
      .PARAMETER EventArg
        The Event Arguments for the Form KeyDown Event
      .EXAMPLE
        Start-GetComboFilterDialogFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$GetComboFilterDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $GetComboFilterDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetComboFilterDialogForm"
  }
  #endregion ******** Function Start-GetComboFilterDialogFormKeyDown ********
  $GetComboFilterDialogForm.add_KeyDown({ Start-GetComboFilterDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-GetComboFilterDialogFormShown ********
  Function Start-GetComboFilterDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the GetComboFilterDialog Form Control
      .DESCRIPTION
        Shown Event for the GetComboFilterDialog Form Control
      .PARAMETER Sender
        The Form Control that fired the Shown Event
      .PARAMETER EventArg
        The Event Arguments for the Form Shown Event
      .EXAMPLE
        Start-GetComboFilterDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$GetComboFilterDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Shown Event for `$GetComboFilterDialogForm"
  }
  #endregion ******** Function Start-GetComboFilterDialogFormShown ********
  $GetComboFilterDialogForm.add_Shown({ Start-GetComboFilterDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for GetComboFilterDialog Form ********
  
  # ************************************************
  # GetComboFilterDialogMain Panel
  # ************************************************
  #region $GetComboFilterDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetComboFilterDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $GetComboFilterDialogForm.Controls.Add($GetComboFilterDialogMainPanel)
  $GetComboFilterDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetComboFilterDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $GetComboFilterDialogMainPanel.Name = "GetComboFilterDialogMainPanel"
  $GetComboFilterDialogMainPanel.Text = "GetComboFilterDialogMainPanel"
  #endregion $GetComboFilterDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetComboFilterDialogMainPanel Controls ********
  
  #region $GetComboFilterDialogMainLabel = [System.Windows.Forms.Label]::New()
  $GetComboFilterDialogMainLabel = [System.Windows.Forms.Label]::New()
  $GetComboFilterDialogMainPanel.Controls.Add($GetComboFilterDialogMainLabel)
  $GetComboFilterDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
  $GetComboFilterDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
  $GetComboFilterDialogMainLabel.Name = "GetComboFilterDialogMainLabel"
  $GetComboFilterDialogMainLabel.Size = [System.Drawing.Size]::New(($GetComboFilterDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
  $GetComboFilterDialogMainLabel.Text = $MessageText
  #endregion $GetComboFilterDialogMainLabel = [System.Windows.Forms.Label]::New()
  
  # Returns the minimum size required to display the text
  $GetComboFilterDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($GetComboFilterDialogMainLabel.Text, $GetComboFilterDialogMainLabel.Font, $GetComboFilterDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))
  
  If ($PSBoundParameters.ContainsKey("Properties"))
  {
    $FilterOptionNames = $Properties
  }
  Else
  {
    $FilterOptionNames = ($Items | Select-Object -First 1).PSObject.Properties | Select-Object -ExpandProperty Name
  }
  
  # ************************************************
  # GetComboFilterDialogMain GroupBox
  # ************************************************
  #region $GetComboFilterDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  $GetComboFilterDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  # Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
  $GetComboFilterDialogMainPanel.Controls.Add($GetComboFilterDialogMainGroupBox)
  $GetComboFilterDialogMainGroupBox.BackColor = [MyConfig]::Colors.Back
  $GetComboFilterDialogMainGroupBox.Font = [MyConfig]::Font.Regular
  $GetComboFilterDialogMainGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
  $GetComboFilterDialogMainGroupBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($GetComboFilterDialogMainLabel.Bottom + ([MyConfig]::FormSpacer * 2)))
  $GetComboFilterDialogMainGroupBox.Name = "GetComboFilterDialogMainGroupBox"
  $GetComboFilterDialogMainGroupBox.Size = [System.Drawing.Size]::New(($GetComboFilterDialogMainPanel.Width - ([MyConfig]::FormSpacer * 2)), 50)
  $GetComboFilterDialogMainGroupBox.Text = $Null
  #endregion $GetComboFilterDialogMainGroupBox = [System.Windows.Forms.GroupBox]::New()
  
  #region ******** $GetComboFilterDialogMainGroupBox Controls ********
  
  #region ******** Function Start-GetComboFilterComboBoxSelectedIndexChanged ********
  Function Start-GetComboFilterComboBoxSelectedIndexChanged
  {
  <#
    .SYNOPSIS
      SelectedIndexChanged Event for the GetSiteComboChoice ComboBox Control
    .DESCRIPTION
      SelectedIndexChanged Event for the GetSiteComboChoice ComboBox Control
    .PARAMETER Sender
       The ComboBox Control that fired the SelectedIndexChanged Event
    .PARAMETER EventArg
       The Event Arguments for the ComboBox SelectedIndexChanged Event
    .EXAMPLE
       Start-GetComboFilterComboBoxSelectedIndexChanged -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ComboBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter SelectedIndexChanged Event for `$GetSiteComboChoiceComboBox"
    
    [MyConfig]::AutoExit = 0
    
    $ValidItems = @($Items)
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      $ValidItems = @($ValidItems | Where-Object -FilterScript { $PSItem.($FilterOptionName) -like $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedItem.Value })
    }
    
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      $ValidItemNames = @($ValidItems | Select-Object -ExpandProperty $FilterOptionName -Unique)
      If ($FilterOptionName -ne $Sender.Name)
      {
        $RemoveList = @($GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Items | Where-Object -FilterScript { ($PSItem.Text -notin $ValidItemNames) -and ($PSItem.Value -ne "*") })
        ForEach ($RemoveItem In $RemoveList)
        {
          $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Items.Remove($RemoveItem)
        }
      }
      $HaveItemNames = @($GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Items | Select-Object -ExpandProperty Text -Unique)
      $AddList = @($GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Tag.Items | Where-Object -FilterScript { ($PSItem.Text -in $ValidItemNames) -and ($PSItem.Text -notin $HaveItemNames) })
      $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Items.AddRange($AddList)
    }
    
    Write-Verbose -Message "Exit SelectedIndexChanged Event for `$GetSiteComboChoiceComboBox"
  }
  #endregion ******** Function Start-GetComboFilterComboBoxSelectedIndexChanged ********
  
  $GroupBottom = [MyConfig]::Font.Height
  ForEach ($FilterOptionName In $FilterOptionNames)
  {
    #region $TmpFilterComboBox = [System.Windows.Forms.ComboBox]::New()
    $TmpFilterComboBox = [System.Windows.Forms.ComboBox]::New()
    $GetComboFilterDialogMainGroupBox.Controls.Add($TmpFilterComboBox)
    $TmpFilterComboBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom")
    $TmpFilterComboBox.AutoSize = $True
    $TmpFilterComboBox.BackColor = [MyConfig]::Colors.TextBack
    $TmpFilterComboBox.DisplayMember = "Text"
    $TmpFilterComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $TmpFilterComboBox.Font = [MyConfig]::Font.Regular
    $TmpFilterComboBox.ForeColor = [MyConfig]::Colors.TextFore
    [void]$TmpFilterComboBox.Items.Add([PSCustomObject]@{ "Text" = " - Return All $($FilterOptionName) Values - "; "Value" = "*" })
    $TmpFilterComboBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, $GroupBottom)
    $TmpFilterComboBox.Name = $FilterOptionName
    $TmpFilterComboBox.SelectedIndex = 0
    $TmpFilterComboBox.Size = [System.Drawing.Size]::New(($GetComboFilterDialogMainGroupBox.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), $TmpFilterComboBox.PreferredHeight)
    $TmpFilterComboBox.Sorted = $True
    $TmpFilterComboBox.TabIndex = 0
    $TmpFilterComboBox.TabStop = $True
    $TmpFilterComboBox.Tag = $Null
    $TmpFilterComboBox.ValueMember = "Value"
    #endregion $TmpFilterComboBox = [System.Windows.Forms.ComboBox]::New()
    
    $TmpFilterComboBox.SelectedIndex = 0
    $TmpFilterComboBox.Items.AddRange(@($Items | Where-Object -FilterScript { -not [String]::IsNullOrEmpty($PSITem.($FilterOptionName)) } | Sort-Object -Property $FilterOptionName -Unique | ForEach-Object -Process { [MyListItem]::New($PSITem.($FilterOptionName), $PSITem.($FilterOptionName)) }))
    $TmpFilterComboBox.Tag = @{ "Items" = @($TmpFilterComboBox.Items); "SelectedItem" = $Null }
    
    $TmpFilterComboBox.add_SelectedIndexChanged({ Start-GetComboFilterComboBoxSelectedIndexChanged -Sender $This -EventArg $PSItem })
    
    $GroupBottom = ($TmpFilterComboBox.Bottom + [MyConfig]::FormSpacer)
  }
  
  $GetComboFilterDialogMainGroupBox.ClientSize = [System.Drawing.Size]::New($GetComboFilterDialogMainGroupBox.ClientSize.Width, ($GroupBottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetComboFilterDialogMainGroupBox Controls ********
  
  ForEach ($FilterOptionName In $FilterOptionNames)
  {
    # $Sender
    If ($Selected.ContainsKey($FilterOptionName))
    {
      $TmpItem = $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Items | Where-Object -FilterScript { $PSItem.Value -eq $Selected.($FilterOptionName) }
      If (-not [String]::IsNullOrEmpty($TmpItem.Text))
      {
        $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedItem = $TmpItem
      }
    }
    $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Tag.SelectedItem = $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedItem
  }
  
  $TempClientSize = [System.Drawing.Size]::New(($GetComboFilterDialogMainGroupBox.Right + [MyConfig]::FormSpacer), ($GetComboFilterDialogMainGroupBox.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetComboFilterDialogMainPanel Controls ********
  
  # ************************************************
  # GetComboFilterDialogBtm Panel
  # ************************************************
  #region $GetComboFilterDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetComboFilterDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $GetComboFilterDialogForm.Controls.Add($GetComboFilterDialogBtmPanel)
  $GetComboFilterDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $GetComboFilterDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $GetComboFilterDialogBtmPanel.Name = "GetComboFilterDialogBtmPanel"
  $GetComboFilterDialogBtmPanel.Text = "GetComboFilterDialogBtmPanel"
  #endregion $GetComboFilterDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $GetComboFilterDialogBtmPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($GetComboFilterDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $GetComboFilterDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmPanel.Controls.Add($GetComboFilterDialogBtmLeftButton)
  $GetComboFilterDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
  $GetComboFilterDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboFilterDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboFilterDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
  $GetComboFilterDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboFilterDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $GetComboFilterDialogBtmLeftButton.Name = "GetComboFilterDialogBtmLeftButton"
  $GetComboFilterDialogBtmLeftButton.TabIndex = 1
  $GetComboFilterDialogBtmLeftButton.TabStop = $True
  $GetComboFilterDialogBtmLeftButton.Text = $ButtonLeft
  $GetComboFilterDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $GetComboFilterDialogBtmLeftButton.PreferredSize.Height)
  #endregion $GetComboFilterDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetComboFilterDialogBtmLeftButtonClick ********
  Function Start-GetComboFilterDialogBtmLeftButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboFilterDialogBtmLeft Button Control
      .DESCRIPTION
        Click Event for the GetComboFilterDialogBtmLeft Button Control
      .PARAMETER Sender
         The Button Control that fired the Click Event
      .PARAMETER EventArg
         The Event Arguments for the Button Click Event
      .EXAMPLE
         Start-GetComboFilterDialogBtmLeftButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboFilterDialogBtmLeftButton"
    
    [MyConfig]::AutoExit = 0
    
    $ValidateClick = 0
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      $ValidateClick = $ValidateClick + $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedIndex
    }
    If ($ValidateClick -eq 0)
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetComboFilterDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
    }
    Else
    {
      $GetComboFilterDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetComboFilterDialogBtmLeftButton"
  }
  #endregion ******** Function Start-GetComboFilterDialogBtmLeftButtonClick ********
  $GetComboFilterDialogBtmLeftButton.add_Click({ Start-GetComboFilterDialogBtmLeftButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetComboFilterDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmPanel.Controls.Add($GetComboFilterDialogBtmMidButton)
  $GetComboFilterDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $GetComboFilterDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $GetComboFilterDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboFilterDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboFilterDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $GetComboFilterDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboFilterDialogBtmMidButton.Location = [System.Drawing.Point]::New(($GetComboFilterDialogBtmLeftButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetComboFilterDialogBtmMidButton.Name = "GetComboFilterDialogBtmMidButton"
  $GetComboFilterDialogBtmMidButton.TabIndex = 2
  $GetComboFilterDialogBtmMidButton.TabStop = $True
  $GetComboFilterDialogBtmMidButton.Text = $ButtonMid
  $GetComboFilterDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $GetComboFilterDialogBtmMidButton.PreferredSize.Height)
  #endregion $GetComboFilterDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetComboFilterDialogBtmMidButtonClick ********
  Function Start-GetComboFilterDialogBtmMidButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboFilterDialogBtmMid Button Control
      .DESCRIPTION
        Click Event for the GetComboFilterDialogBtmMid Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetComboFilterDialogBtmMidButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By MyUserName)
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboFilterDialogBtmMidButton"
    
    [MyConfig]::AutoExit = 0
    
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedIndex = 0
    }
    
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedItem = $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].Tag.SelectedItem
    }
    
    Write-Verbose -Message "Exit Click Event for `$GetComboFilterDialogBtmMidButton"
  }
  #endregion ******** Function Start-GetComboFilterDialogBtmMidButtonClick ********
  $GetComboFilterDialogBtmMidButton.add_Click({ Start-GetComboFilterDialogBtmMidButtonClick -Sender $This -EventArg $PSItem })
  
  #region $GetComboFilterDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  $GetComboFilterDialogBtmPanel.Controls.Add($GetComboFilterDialogBtmRightButton)
  $GetComboFilterDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
  $GetComboFilterDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $GetComboFilterDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
  $GetComboFilterDialogBtmRightButton.Font = [MyConfig]::Font.Bold
  $GetComboFilterDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $GetComboFilterDialogBtmRightButton.Location = [System.Drawing.Point]::New(($GetComboFilterDialogBtmMidButton.Right + [MyConfig]::FormSpacer), [MyConfig]::FormSpacer)
  $GetComboFilterDialogBtmRightButton.Name = "GetComboFilterDialogBtmRightButton"
  $GetComboFilterDialogBtmRightButton.TabIndex = 3
  $GetComboFilterDialogBtmRightButton.TabStop = $True
  $GetComboFilterDialogBtmRightButton.Text = $ButtonRight
  $GetComboFilterDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $GetComboFilterDialogBtmRightButton.PreferredSize.Height)
  #endregion $GetComboFilterDialogBtmRightButton = [System.Windows.Forms.Button]::New()
  
  #region ******** Function Start-GetComboFilterDialogBtmRightButtonClick ********
  Function Start-GetComboFilterDialogBtmRightButtonClick
  {
    <#
      .SYNOPSIS
        Click Event for the GetComboFilterDialogBtmRight Button Control
      .DESCRIPTION
        Click Event for the GetComboFilterDialogBtmRight Button Control
      .PARAMETER Sender
        The Button Control that fired the Click Event
      .PARAMETER EventArg
        The Event Arguments for the Button Click Event
      .EXAMPLE
        Start-GetComboFilterDialogBtmRightButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By MyUserName)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Button]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$GetComboFilterDialogBtmRightButton"
    
    [MyConfig]::AutoExit = 0
    
    $GetComboFilterDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    
    Write-Verbose -Message "Exit Click Event for `$GetComboFilterDialogBtmRightButton"
  }
  #endregion ******** Function Start-GetComboFilterDialogBtmRightButtonClick ********
  $GetComboFilterDialogBtmRightButton.add_Click({ Start-GetComboFilterDialogBtmRightButtonClick -Sender $This -EventArg $PSItem })
  
  $GetComboFilterDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($GetComboFilterDialogBtmRightButton.Right + [MyConfig]::FormSpacer), ($GetComboFilterDialogBtmRightButton.Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $GetComboFilterDialogBtmPanel Controls ********
  
  $GetComboFilterDialogForm.ClientSize = [System.Drawing.Size]::New($GetComboFilterDialogForm.ClientSize.Width, ($TempClientSize.Height + $GetComboFilterDialogBtmPanel.Height))
  
  #endregion ******** Controls for GetComboFilterDialog Form ********
  
  #endregion ================ End **** GetComboFilterDialog **** End ================
  
  $DialogResult = $GetComboFilterDialogForm.ShowDialog()
  If ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
  {
    $TmpHash = [HashTable]::New()
    ForEach ($FilterOptionName In $FilterOptionNames)
    {
      [Void]$TmpHash.Add($FilterOptionName, $GetComboFilterDialogMainGroupBox.Controls[$FilterOptionName].SelectedItem.Value)
    }
    [GetComboFilterDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, $TmpHash)
  }
  Else
  {
    [GetComboFilterDialog]::New(($DialogResult -eq [System.Windows.Forms.DialogResult]::OK), $DialogResult, @{ })
  }
  
  $GetComboFilterDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-GetComboFilterDialog"
}
#endregion function Show-GetComboFilterDialog

#region function Show-ChangeLogDialog
Function Show-ChangeLogDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-ChangeLogDialog
    .DESCRIPTION
      Shows Show-ChangeLogDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER ScriptBlock
    .PARAMETER Items
    .PARAMETER Width
    .PARAMETER Height
    .PARAMETER ButtonMid
    .PARAMETER AllowCancel
    .PARAMETER AutoClose
    .EXAMPLE
      $Return = Show-ChangeLogDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding()]
  Param (
    [String]$Title = "Change Log - $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)",
    [parameter(Mandatory = $True)]
    [String]$ChangeText,
    [Int]$Width = 60,
    [Int]$Height = 30
  )
  Write-Verbose -Message "Enter Function Show-ChangeLogDialog"
  
  #region >>>>>>>>>>>>>>>> Begin **** ChangeLogDialog **** Begin <<<<<<<<<<<<<<<<
  
  # ************************************************
  # ChangeLogDialog Form
  # ************************************************
  #region $ChangeLogDialogForm = [System.Windows.Forms.Form]::New()
  $ChangeLogDialogForm = [System.Windows.Forms.Form]::New()
  $ChangeLogDialogForm.BackColor = [MyConfig]::Colors.Back
  $ChangeLogDialogForm.Font = [MyConfig]::Font.Regular
  $ChangeLogDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $ChangeLogDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $ChangeLogDialogForm.Icon = $FCGForm.Icon
  $ChangeLogDialogForm.KeyPreview = $True
  $ChangeLogDialogForm.MaximizeBox = $False
  $ChangeLogDialogForm.MinimizeBox = $False
  $ChangeLogDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * $Height))
  $ChangeLogDialogForm.Name = "ChangeLogDialogForm"
  $ChangeLogDialogForm.Owner = $FCGForm
  $ChangeLogDialogForm.ShowInTaskbar = $False
  $ChangeLogDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $ChangeLogDialogForm.Tag = $False
  $ChangeLogDialogForm.Text = $Title
  #endregion $ChangeLogDialogForm = [System.Windows.Forms.Form]::New()
  
  #region ******** Function Start-ChangeLogDialogFormKeyDown ********
  Function Start-ChangeLogDialogFormKeyDown
  {
  <#
    .SYNOPSIS
      KeyDown Event for the ChangeLogDialog Form Control
    .DESCRIPTION
      KeyDown Event for the ChangeLogDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-ChangeLogDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$ChangeLogDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
    {
      $ChangeLogDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$ChangeLogDialogForm"
  }
  #endregion ******** Function Start-ChangeLogDialogFormKeyDown ********
  $ChangeLogDialogForm.add_KeyDown({ Start-ChangeLogDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** Function Start-ChangeLogDialogFormShown ********
  Function Start-ChangeLogDialogFormShown
  {
    <#
     .SYNOPSIS
       Shown Event for the ChangeLogDialog Form Control
     .DESCRIPTION
       Shown Event for the ChangeLogDialog Form Control
     .PARAMETER Sender
        The Form Control that fired the Shown Event
     .PARAMETER EventArg
         The Event Arguments for the Form Shown Event
      .EXAMPLE
         Start-ChangeLogDialogFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet)
    #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$ChangeLogDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    $Sender.Refresh()
    
    $ChangeLogDialogMainTextBox.AppendText($ChangeText)
    
    $ChangeLogDialogMainTextBox.SelectionLength = 0
    $ChangeLogDialogMainTextBox.SelectionStart = 0
    $ChangeLogDialogMainTextBox.ScrollToCaret()
    $ChangeLogDialogMainTextBox.Refresh()
    
    
    Write-Verbose -Message "Exit Shown Event for `$ChangeLogDialogForm"
  }
  #endregion ******** Function Start-ChangeLogDialogFormShown ********
  $ChangeLogDialogForm.add_Shown({ Start-ChangeLogDialogFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** Controls for ChangeLogDialog Form ********
  
  # ************************************************
  # ChangeLogDialogMain Panel
  # ************************************************
  #region $ChangeLogDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $ChangeLogDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $ChangeLogDialogForm.Controls.Add($ChangeLogDialogMainPanel)
  $ChangeLogDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $ChangeLogDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $ChangeLogDialogMainPanel.Name = "ChangeLogDialogMainPanel"
  $ChangeLogDialogMainPanel.Text = "ChangeLogDialogMainPanel"
  #endregion $ChangeLogDialogMainPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $ChangeLogDialogMainPanel Controls ********
  
  #region $ChangeLogDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  $ChangeLogDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  $ChangeLogDialogMainPanel.Controls.Add($ChangeLogDialogMainTextBox)
  $ChangeLogDialogMainTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom")
  $ChangeLogDialogMainTextBox.BackColor = [MyConfig]::Colors.TextBack
  $ChangeLogDialogMainTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $ChangeLogDialogMainTextBox.Font = [System.Drawing.Font]::New("Courier New", [MyConfig]::FontSize, [System.Drawing.FontStyle]::Regular)
  $ChangeLogDialogMainTextBox.ForeColor = [MyConfig]::Colors.TextFore
  $ChangeLogDialogMainTextBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $ChangeLogDialogMainTextBox.MaxLength = [Int]::MaxValue
  $ChangeLogDialogMainTextBox.Multiline = $True
  $ChangeLogDialogMainTextBox.Name = "ChangeLogDialogMainTextBox"
  $ChangeLogDialogMainTextBox.ReadOnly = $True
  $ChangeLogDialogMainTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
  $ChangeLogDialogMainTextBox.Size = [System.Drawing.Size]::New(($ChangeLogDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($ChangeLogDialogMainPanel.ClientSize.Height - ($ChangeLogDialogMainTextBox.Top + [MyConfig]::FormSpacer)))
  $ChangeLogDialogMainTextBox.TabStop = $False
  $ChangeLogDialogMainTextBox.Text = $Null
  $ChangeLogDialogMainTextBox.WordWrap = $False
  #endregion $ChangeLogDialogMainTextBox = [System.Windows.Forms.TextBox]::New()
  
  #endregion ******** $ChangeLogDialogMainPanel Controls ********
  
  # ************************************************
  # ChangeLogDialogBtm Panel
  # ************************************************
  #region $ChangeLogDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $ChangeLogDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  $ChangeLogDialogForm.Controls.Add($ChangeLogDialogBtmPanel)
  $ChangeLogDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $ChangeLogDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $ChangeLogDialogBtmPanel.Name = "ChangeLogDialogBtmPanel"
  $ChangeLogDialogBtmPanel.Text = "ChangeLogDialogBtmPanel"
  #endregion $ChangeLogDialogBtmPanel = [System.Windows.Forms.Panel]::New()
  
  #region ******** $ChangeLogDialogBtmPanel Controls ********
  
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 3
  $TempSpace = [Math]::Floor($ChangeLogDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  
  #region $ChangeLogDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $ChangeLogDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  $ChangeLogDialogBtmPanel.Controls.Add($ChangeLogDialogBtmMidButton)
  #$ChangeLogDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $ChangeLogDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top")
  $ChangeLogDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
  $ChangeLogDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
  $ChangeLogDialogBtmMidButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $ChangeLogDialogBtmMidButton.Enabled = $True
  $ChangeLogDialogBtmMidButton.Font = [MyConfig]::Font.Bold
  $ChangeLogDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
  $ChangeLogDialogBtmMidButton.Location = [System.Drawing.Point]::New(($TempWidth + ([MyConfig]::FormSpacer * 2)), 0)
  $ChangeLogDialogBtmMidButton.Name = "ChangeLogDialogBtmMidButton"
  $ChangeLogDialogBtmMidButton.TabStop = $True
  $ChangeLogDialogBtmMidButton.Text = "&Ok"
  $ChangeLogDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $ChangeLogDialogBtmMidButton.PreferredSize.Height)
  #endregion $ChangeLogDialogBtmMidButton = [System.Windows.Forms.Button]::New()
  
  $ChangeLogDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($ChangeLogDialogMainTextBox.Right + [MyConfig]::FormSpacer), (($ChangeLogDialogBtmPanel.Controls[$ChangeLogDialogBtmPanel.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))
  
  #endregion ******** $ChangeLogDialogBtmPanel Controls ********
  
  #endregion ******** Controls for ChangeLogDialog Form ********
  
  #endregion ================ End **** ChangeLogDialog **** End ================
  
  $DialogResult = $ChangeLogDialogForm.ShowDialog($FCGForm)
  
  $ChangeLogDialogForm.Dispose()
  
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
  
  Write-Verbose -Message "Exit Function Show-ChangeLogDialog"
}
#endregion function Show-ChangeLogDialog

#region MyStatusDialog Result Class
Class MyStatusDialog
{
  [Bool]$Success
  [Object]$DialogResult

  MyStatusDialog ([Bool]$Success, [Object]$DialogResult)
  {
    $This.Success = $Success
    $This.DialogResult = $DialogResult
  }
}
#endregion MyStatusDialog Result Class

#region function Show-MyStatusDialog
function Show-MyStatusDialog ()
{
  <#
    .SYNOPSIS
      Shows Show-MyStatusDialog
    .DESCRIPTION
      Shows Show-MyStatusDialog
    .PARAMETER DialogTitle
    .PARAMETER MessageText
    .PARAMETER ScriptBlock
    .PARAMETER HashTable
    .PARAMETER Width
    .PARAMETER Height
    .PARAMETER ButtonDefault
    .PARAMETER ButtonLeft
    .PARAMETER ButtonMid
    .PARAMETER ButtonRight
    .PARAMETER AllowControl
    .PARAMETER AutoClose
    .PARAMETER AutoCloseWait
    .EXAMPLE
      $Return = Show-MyStatusDialog -DialogTitle $DialogTitle
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "Zero")]
  param (
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$MessageText = "Status Message",
    [parameter(Mandatory = $True)]
    [ScriptBlock]$ScriptBlock = {},
    [HashTable]$HashTable = @{},
    [Int]$Width = 45,
    [Int]$Height = 30,
    [System.Windows.Forms.DialogResult]$ButtonDefault = "OK",
    [parameter(Mandatory = $True, ParameterSetName = "Two")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonLeft,
    [parameter(Mandatory = $True, ParameterSetName = "One")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonMid,
    [parameter(Mandatory = $True, ParameterSetName = "Two")]
    [parameter(Mandatory = $True, ParameterSetName = "Three")]
    [System.Windows.Forms.DialogResult]$ButtonRight,
    [Switch]$AllowControl,
    [Switch]$AutoClose,
    [ValidateRange(0, 300)]
    [int]$AutoCloseWait = 10
  )
  Write-Verbose -Message "Enter Function Show-MyStatusDialog"

  #region >>>>>>>>>>>>>>>> Begin **** $MyStatusDialog **** Begin <<<<<<<<<<<<<<<<

  # ************************************************
  # $MyStatusDialog Form
  # ************************************************
  #region $MyStatusDialogForm = [System.Windows.Forms.Form]::New()
  $MyStatusDialogForm = [System.Windows.Forms.Form]::New()
  $MyStatusDialogForm.BackColor = [MyConfig]::Colors.Back
  $MyStatusDialogForm.Font = [MyConfig]::Font.Regular
  $MyStatusDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $MyStatusDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $MyStatusDialogForm.Icon = $FCGForm.Icon
  $MyStatusDialogForm.KeyPreview = $AllowControl.IsPresent
  $MyStatusDialogForm.MaximizeBox = $False
  $MyStatusDialogForm.MinimizeBox = $False
  $MyStatusDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * $Height))
  $MyStatusDialogForm.Name = "MyStatusDialogForm"
  $MyStatusDialogForm.Owner = $FCGForm
  $MyStatusDialogForm.ShowInTaskbar = $False
  $MyStatusDialogForm.Size = $MyStatusDialogForm.MinimumSize
  $MyStatusDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyStatusDialogForm.Tag = @{ "Cancel" = $False; "Pause" = $False }
  $MyStatusDialogForm.Text = $DialogTitle
  #endregion $MyStatusDialogForm = [System.Windows.Forms.Form]::New()

  #region ******** Function Start-MyStatusDialogFormKeyDown ********
  Function Start-MyStatusDialogFormKeyDown
  {
  <#
    .SYNOPSIS
      KeyDown Event for the MyStatusDialog Form Control
    .DESCRIPTION
      KeyDown Event for the MyStatusDialog Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-MyStatusDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.Form]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MyStatusDialogForm"
    
    [MyConfig]::AutoExit = 0
    
    If ($EventArg.Control -and $EventArg.Alt)
    {
      Switch ($EventArg.KeyCode)
      {
        { $PSItem -eq [System.Windows.Forms.Keys]::Back }
        {
          $Sender.Tag.Cancel = $True
          Break
        }
        { $PSItem -eq [System.Windows.Forms.Keys]::End }
        {
          $Sender.Tag.Cancel = $True
          Break
        }
      }
    }
    Else
    {
      Switch ($EventArg.KeyCode)
      {
        { $PSItem -eq [System.Windows.Forms.Keys]::Pause }
        {
          $Sender.Tag.Pause = (-not $Sender.Tag.Pause)
          Break
        }
      }
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$MyStatusDialogForm"
  }
  #endregion ******** Function Start-MyStatusDialogFormKeyDown ********
  If ($AllowControl.IsPresent)
  {
    $MyStatusDialogForm.add_KeyDown({ Start-MyStatusDialogFormKeyDown -Sender $This -EventArg $PSItem })
  }

  #region ******** Function Start-MyStatusDialogFormShown ********
  function Start-MyStatusDialogFormShown
  {
    <#
      .SYNOPSIS
        Shown Event for the $MyStatusDialog Form Control
      .DESCRIPTION
        Shown Event for the $MyStatusDialog Form Control
      .PARAMETER Sender
         The Form Control that fired the Shown Event
      .PARAMETER EventArg
         The Event Arguments for the Form Shown Event
      .EXAMPLE
         Start-MyStatusDialogFormShown -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Shown Event for `$MyStatusDialogForm"

    [MyConfig]::AutoExit = 0

    $Sender.Refresh()

    If ([MyConfig]::Production)
    {
      # Disable Auto Exit Timer
      $FCGTimer.Enabled = $False
    }

    if ($PassHashTable)
    {
      $DialogResult = Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $MyStatusDialogMainRichTextBox, $HashTable
    }
    else
    {
      $DialogResult = Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $MyStatusDialogMainRichTextBox
    }

    If ([MyConfig]::Production)
    {
      # Re-enable Auto Exit Timer
      $FCGTimer.Enabled = ([MyConfig]::AutoExitMax -gt 0)
    }

    switch ($MyStatusDialogButtons)
    {
      1
      {
        $MyStatusDialogBtmMidButton.Enabled = $True
        $MyStatusDialogBtmMidButton.DialogResult = $DialogResult
        Break
      }
      2
      {
        $MyStatusDialogBtmLeftButton.Enabled = $True
        $MyStatusDialogBtmRightButton.Enabled = $True
        Break
      }
      3
      {
        $MyStatusDialogBtmLeftButton.Enabled = $True
        $MyStatusDialogBtmMidButton.Enabled = $True
        $MyStatusDialogBtmRightButton.Enabled = $True
        Break
      }
    }

    if ((($DialogResult -eq $ButtonDefault) -and $AutoClose.IsPresent) -or ($MyStatusDialogButtons -eq 0))
    {
      $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
      while ($StopWatch.Elapsed.TotalSeconds -le $AutoCloseWait)
      {
        [System.Threading.Thread]::Sleep(10)
        [System.Windows.Forms.Application]::DoEvents()
      }

      $MyStatusDialogForm.DialogResult = $DialogResult
    }

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Verbose -Message "Exit Shown Event for `$MyStatusDialogForm"
  }
  #endregion ******** Function Start-MyStatusDialogFormShown ********
  $MyStatusDialogForm.add_Shown({Start-MyStatusDialogFormShown -Sender $This -EventArg $PSItem})

  #region ******** Controls for $MyStatusDialog Form ********

  # ************************************************
  # $MyStatusDialogMain Panel
  # ************************************************
  #region $MyStatusDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $MyStatusDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $MyStatusDialogForm.Controls.Add($MyStatusDialogMainPanel)
  $MyStatusDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyStatusDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $MyStatusDialogMainPanel.Name = "MyStatusDialogMainPanel"
  $MyStatusDialogMainPanel.Text = "$MyStatusDialogMainPanel"
  #endregion $MyStatusDialogMainPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $MyStatusDialogMainPanel Controls ********

  if ($PSBoundParameters.ContainsKey("MessageText"))
  {
    #region $MyStatusDialogMainLabel = [System.Windows.Forms.Label]::New()
    $MyStatusDialogMainLabel = [System.Windows.Forms.Label]::New()
    $MyStatusDialogMainPanel.Controls.Add($MyStatusDialogMainLabel)
    $MyStatusDialogMainLabel.ForeColor = [MyConfig]::Colors.LabelFore
    $MyStatusDialogMainLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ([MyConfig]::FormSpacer * 2))
    $MyStatusDialogMainLabel.Name = "MyStatusDialogMainLabel"
    $MyStatusDialogMainLabel.Size = [System.Drawing.Size]::New(($MyStatusDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), 23)
    $MyStatusDialogMainLabel.Text = $MessageText
    #endregion $MyStatusDialogMainLabel = [System.Windows.Forms.Label]::New()

    # Returns the minimum size required to display the text
    $MyStatusDialogMainLabel.Size = [System.Windows.Forms.TextRenderer]::MeasureText($MyStatusDialogMainLabel.Text, $MyStatusDialogMainLabel.Font, $MyStatusDialogMainLabel.Size, ([System.Windows.Forms.TextFormatFlags]("Top", "Left", "WordBreak")))

    $TempBottom = $MyStatusDialogMainLabel.Bottom + [MyConfig]::FormSpacer
  }
  else
  {
    $TempBottom = 0
  }

  #region $MyStatusDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()
  $MyStatusDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()
  $MyStatusDialogMainPanel.Controls.Add($MyStatusDialogMainRichTextBox)
  $MyStatusDialogMainRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom")
  $MyStatusDialogMainRichTextBox.BackColor = [MyConfig]::Colors.TextBack
  $MyStatusDialogMainRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $MyStatusDialogMainRichTextBox.DetectUrls = $True
  $MyStatusDialogMainRichTextBox.Font = [MyConfig]::Font.Regular
  $MyStatusDialogMainRichTextBox.ForeColor = [MyConfig]::Colors.TextFore
  $MyStatusDialogMainRichTextBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, ($TempBottom + [MyConfig]::FormSpacer))
  $MyStatusDialogMainRichTextBox.MaxLength = [Int]::MaxValue
  $MyStatusDialogMainRichTextBox.Multiline = $True
  $MyStatusDialogMainRichTextBox.Name = "MyStatusDialogMainRichTextBox"
  $MyStatusDialogMainRichTextBox.ReadOnly = $True
  $MyStatusDialogMainRichTextBox.Rtf = ""
  $MyStatusDialogMainRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
  $MyStatusDialogMainRichTextBox.Size = [System.Drawing.Size]::New(($MyStatusDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($MyStatusDialogMainPanel.ClientSize.Height - ($MyStatusDialogMainRichTextBox.Top + [MyConfig]::FormSpacer)))
  $MyStatusDialogMainRichTextBox.TabStop = $False
  $MyStatusDialogMainRichTextBox.Text = ""
  $MyStatusDialogMainRichTextBox.WordWrap = $False
  #endregion $MyStatusDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()

  #region ******** Function Start-MyStatusDialogMainRichTextBoxMouseDown ********
  Function Start-MyStatusDialogMainRichTextBoxMouseDown
  {
  <#
    .SYNOPSIS
      MouseDown Event for the MyStatusDialogMain RichTextBox Control
    .DESCRIPTION
      MouseDown Event for the MyStatusDialogMain RichTextBox Control
    .PARAMETER Sender
       The RichTextBox Control that fired the MouseDown Event
    .PARAMETER EventArg
       The Event Arguments for the RichTextBox MouseDown Event
    .EXAMPLE
       Start-MyStatusDialogMainRichTextBoxMouseDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By ken.sweet
  #>
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.RichTextBox]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter MouseDown Event for `$MyStatusDialogMainRichTextBox"
    
    [MyConfig]::AutoExit = 0
    
    $MyStatusDialogMainRichTextBox.SelectionLength = 0
    $MyStatusDialogMainRichTextBox.SelectionStart = $MyStatusDialogMainRichTextBox.TextLength
    
    Write-Verbose -Message "Exit MouseDown Event for `$MyStatusDialogMainRichTextBox"
  }
  #endregion ******** Function Start-MyStatusDialogMainRichTextBoxMouseDown ********
  $MyStatusDialogMainRichTextBox.add_MouseDown({ Start-MyStatusDialogMainRichTextBoxMouseDown -Sender $This -EventArg $PSItem })

  #endregion ******** $MyStatusDialogMainPanel Controls ********

  switch ($PSCmdlet.ParameterSetName)
  {
    "Zero"
    {
      $MyStatusDialogButtons = 0
      Break
    }
    "One"
    {
      $MyStatusDialogButtons = 1
      Break
    }
    "Two"
    {
      $MyStatusDialogButtons = 2
      Break
    }
    "Three"
    {
      $MyStatusDialogButtons = 3
      Break
    }
  }

  # Evenly Space Buttons - Move Size to after Text
  if ($MyStatusDialogButtons -gt 0)
  {
    # ************************************************
    # $MyStatusDialogBtm Panel
    # ************************************************
    #region $MyStatusDialogBtmPanel = [System.Windows.Forms.Panel]::New()
    $MyStatusDialogBtmPanel = [System.Windows.Forms.Panel]::New()
    $MyStatusDialogForm.Controls.Add($MyStatusDialogBtmPanel)
    $MyStatusDialogBtmPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $MyStatusDialogBtmPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $MyStatusDialogBtmPanel.Name = "MyStatusDialogBtmPanel"
    $MyStatusDialogBtmPanel.Text = "$MyStatusDialogBtmPanel"
    #endregion $MyStatusDialogBtmPanel = [System.Windows.Forms.Panel]::New()

    #region ******** $MyStatusDialogBtmPanel Controls ********

    $NumButtons = 3
    $TempSpace = [Math]::Floor($MyStatusDialogBtmPanel.ClientSize.Width - ([MyConfig]::FormSpacer * ($NumButtons + 1)))
    $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
    $TempMod = $TempSpace % $NumButtons

    #region $MyStatusDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
    If (($MyStatusDialogButtons -eq 2) -or ($MyStatusDialogButtons -eq 3))
    {
      $MyStatusDialogBtmLeftButton = [System.Windows.Forms.Button]::New()
      $MyStatusDialogBtmPanel.Controls.Add($MyStatusDialogBtmLeftButton)
      $MyStatusDialogBtmLeftButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
      $MyStatusDialogBtmLeftButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
      $MyStatusDialogBtmLeftButton.BackColor = [MyConfig]::Colors.ButtonBack
      $MyStatusDialogBtmLeftButton.DialogResult = $ButtonLeft
      $MyStatusDialogBtmLeftButton.Enabled = $False
      $MyStatusDialogBtmLeftButton.Font = [MyConfig]::Font.Bold
      $MyStatusDialogBtmLeftButton.ForeColor = [MyConfig]::Colors.ButtonFore
      $MyStatusDialogBtmLeftButton.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
      $MyStatusDialogBtmLeftButton.Name = "MyStatusDialogBtmLeftButton"
      $MyStatusDialogBtmLeftButton.TabIndex = 0
      $MyStatusDialogBtmLeftButton.TabStop = $True
      $MyStatusDialogBtmLeftButton.Text = "&$($ButtonLeft.ToString())"
      $MyStatusDialogBtmLeftButton.Size = [System.Drawing.Size]::New($TempWidth, $MyStatusDialogBtmLeftButton.PreferredSize.Height)
    }
    #endregion $MyStatusDialogBtmLeftButton = [System.Windows.Forms.Button]::New()

    #region $MyStatusDialogBtmMidButton = [System.Windows.Forms.Button]::New()
    If (($MyStatusDialogButtons -eq 1) -or ($MyStatusDialogButtons -eq 3))
    {
      $MyStatusDialogBtmMidButton = [System.Windows.Forms.Button]::New()
      $MyStatusDialogBtmPanel.Controls.Add($MyStatusDialogBtmMidButton)
      $MyStatusDialogBtmMidButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
      $MyStatusDialogBtmMidButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
      $MyStatusDialogBtmMidButton.BackColor = [MyConfig]::Colors.ButtonBack
      $MyStatusDialogBtmMidButton.DialogResult = $ButtonMid
      $MyStatusDialogBtmMidButton.Enabled = $False
      $MyStatusDialogBtmMidButton.Font = [MyConfig]::Font.Bold
      $MyStatusDialogBtmMidButton.ForeColor = [MyConfig]::Colors.ButtonFore
      $MyStatusDialogBtmMidButton.Location = [System.Drawing.Point]::New(($TempWidth + ([MyConfig]::FormSpacer * 2)), [MyConfig]::FormSpacer)
      $MyStatusDialogBtmMidButton.Name = "MyStatusDialogBtmMidButton"
      $MyStatusDialogBtmMidButton.TabStop = $True
      $MyStatusDialogBtmMidButton.Text = "&$($ButtonMid.ToString())"
      $MyStatusDialogBtmMidButton.Size = [System.Drawing.Size]::New(($TempWidth + $TempMod), $MyStatusDialogBtmMidButton.PreferredSize.Height)
    }
    #endregion $MyStatusDialogBtmMidButton = [System.Windows.Forms.Button]::New()

    #region $MyStatusDialogBtmRightButton = [System.Windows.Forms.Button]::New()
    If (($MyStatusDialogButtons -eq 2) -or ($MyStatusDialogButtons -eq 3))
    {
      $MyStatusDialogBtmRightButton = [System.Windows.Forms.Button]::New()
      $MyStatusDialogBtmPanel.Controls.Add($MyStatusDialogBtmRightButton)
      $MyStatusDialogBtmRightButton.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Right")
      $MyStatusDialogBtmRightButton.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
      $MyStatusDialogBtmRightButton.BackColor = [MyConfig]::Colors.ButtonBack
      $MyStatusDialogBtmRightButton.DialogResult = $ButtonRight
      $MyStatusDialogBtmRightButton.Enabled = $False
      $MyStatusDialogBtmRightButton.Font = [MyConfig]::Font.Bold
      $MyStatusDialogBtmRightButton.ForeColor = [MyConfig]::Colors.ButtonFore
      $MyStatusDialogBtmRightButton.Location = [System.Drawing.Point]::New(($MyStatusDialogBtmLeftButton.Right + $TempWidth + $TempMod + ([MyConfig]::FormSpacer * 2)), [MyConfig]::FormSpacer)
      $MyStatusDialogBtmRightButton.Name = "MyStatusDialogBtmRightButton"
      $MyStatusDialogBtmRightButton.TabIndex = 1
      $MyStatusDialogBtmRightButton.TabStop = $True
      $MyStatusDialogBtmRightButton.Text = "&$($ButtonRight.ToString())"
      $MyStatusDialogBtmRightButton.Size = [System.Drawing.Size]::New($TempWidth, $MyStatusDialogBtmRightButton.PreferredSize.Height)
    }
    #endregion $MyStatusDialogBtmRightButton = [System.Windows.Forms.Button]::New()

    $MyStatusDialogBtmPanel.ClientSize = [System.Drawing.Size]::New(($MyStatusDialogMainTextBox.Right + [MyConfig]::FormSpacer), (($MyStatusDialogBtmPanel.Controls[$MyStatusDialogBtmPanel.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))

    #endregion ******** $MyStatusDialogBtmPanel Controls ********
  }

  #endregion ******** Controls for $MyStatusDialog Form ********

  #endregion ================ End **** $MyStatusDialog **** End ================

  $PassHashTable = $PSBoundParameters.ContainsKey("HashTable")
  $DialogResult = $MyStatusDialogForm.ShowDialog($FCGForm)
  [MyStatusDialog]::New(($DialogResult -eq $ButtonDefault), $DialogResult)

  $MyStatusDialogForm.Dispose()

  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()

  Write-Verbose -Message "Exit Function Show-MyStatusDialog"
}
#endregion function Show-MyStatusDialog

#region Function Write-RichTextBox
Function Write-RichTextBox
{
  <#
    .SYNOPSIS
      Write to RichTextBox
    .DESCRIPTION
      Write to RichTextBox
    .PARAMETER RichTextBox
    .PARAMETER TextFore
    .PARAMETER Font
    .PARAMETER Alignment
    .PARAMETER Text
    .PARAMETER BulletFore
    .PARAMETER NoNewLine
    .EXAMPLE
      Write-RichTextBox -RichTextBox $RichTextBox -Text $Text
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "NewLine")]
  param (
    [System.Windows.Forms.RichTextBox]$RichTextBox = $MyStatusDialogMainRichTextBox,
    [System.Drawing.Color]$TextFore = [MyConfig]::Colors.TextFore,
    [System.Drawing.Font]$Font = [MyConfig]::Font.Regular,
    [System.Windows.Forms.HorizontalAlignment]$Alignment = [System.Windows.Forms.HorizontalAlignment]::Left,
    [String]$Text,
    [parameter(Mandatory = $False, ParameterSetName = "NewLine")]
    [System.Drawing.Color]$BulletFore = [MyConfig]::Colors.TextFore,
    [parameter(Mandatory = $True, ParameterSetName = "NoNewLine")]
    [Switch]$NoNewLine
  )
  $RichTextBox.SelectionLength = 0
  $RichTextBox.SelectionStart = $RichTextBox.TextLength
  $RichTextBox.SelectionAlignment = $Alignment
  $RichTextBox.SelectionFont = $Font
  $RichTextBox.SelectionColor = $TextFore
  $RichTextBox.AppendText($Text)
  if (-not $NoNewLine.IsPresent)
  {
    $RichTextBox.SelectionColor = $BulletFore
    $RichTextBox.AppendText("`r`n")
  }
  $RichTextBox.ScrollToCaret()
  $RichTextBox.Refresh()
}
#endregion Function Write-RichTextBox

#region Function Write-RichTextBoxValue
Function Write-RichTextBoxValue
{
  <#
    .SYNOPSIS
      Write Property Value to RichTextBox
    .DESCRIPTION
      Write Property Value to RichTextBox
    .PARAMETER RichTextBox
    .PARAMETER TextFore
    .PARAMETER ValueFore
    .PARAMETER BulletFore
    .PARAMETER Font
    .PARAMETER Text
    .PARAMETER Value
    .EXAMPLE
      Write-RichTextBoxValue -RichTextBox $RichTextBox -Text $Text -Value $Value
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  Param (
    [System.Windows.Forms.RichTextBox]$RichTextBox = $MyStatusDialogMainRichTextBox,
    [System.Drawing.Color]$TextFore = [MyConfig]::Colors.TextFore,
    [System.Drawing.Color]$ValueFore = [MyConfig]::Colors.TextInfo,
    [System.Drawing.Color]$BulletFore = [MyConfig]::Colors.TextFore,
    [System.Drawing.Font]$Font = [MyConfig]::Font.Regular,
    [Parameter(Mandatory = $True)]
    [String]$Text,
    [Parameter(Mandatory = $True)]
    [String]$Value
  )
  $RichTextBox.SelectionLength = 0
  $RichTextBox.SelectionStart = $RichTextBox.TextLength
  $RichTextBox.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left
  $RichTextBox.SelectionFont = $Font
  $RichTextBox.SelectionColor = $TextFore
  $RichTextBox.AppendText("$($Text)")
  $RichTextBox.SelectionColor = $BulletFore
  $RichTextBox.AppendText(": ")
  $RichTextBox.SelectionColor = $ValueFore
  $RichTextBox.AppendText("$($Value)")
  $RichTextBox.SelectionColor = $BulletFore
  $RichTextBox.AppendText("`r`n")
  $RichTextBox.ScrollToCaret()
  $RichTextBox.Refresh()
}
#endregion Function Write-RichTextBoxValue

#region Function Write-RichTextBoxError
Function Write-RichTextBoxError
{
  <#
    .SYNOPSIS
      Write Error Message to RichTextBox
    .DESCRIPTION
      Write Error Message to RichTextBox
    .PARAMETER RichTextBox
    .EXAMPLE
      Write-RichTextBoxError -RichTextBox $RichTextBox
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [System.Windows.Forms.RichTextBox]$RichTextBox = $MyStatusDialogMainRichTextBox
  )

  Write-RichTextBox -RichTextBox $RichTextBox -Text "Error: " -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox -Text $($Error[0].Exception.Message) -TextFore ([MyConfig]::Colors.TextBad) -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox

  Write-RichTextBox -RichTextBox $RichTextBox -Text "Code: " -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox -Text (($Error[0].InvocationInfo.Line).Trim()) -TextFore ([MyConfig]::Colors.TextBad) -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox

  Write-RichTextBox -RichTextBox $RichTextBox -Text "Line: " -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox -Text ($Error[0].InvocationInfo.ScriptLineNumber) -TextFore ([MyConfig]::Colors.TextBad) -NoNewLine
  Write-RichTextBox -RichTextBox $RichTextBox

}
#endregion Function Write-RichTextBoxError

# ---------------------------------------
# Sample Function Display Status Messages
# ---------------------------------------
#region function Display-MyStatusRichTextBox
function Display-MyStatusRichTextBox()
{
  <#
    .SYNOPSIS
      Display Utility Status Sample Function
    .DESCRIPTION
      Display Utility Status Sample Function
    .PARAMETER RichTextBox
    .PARAMETER HashTable
    .EXAMPLE
      Display-MyStatusRichTextBox -RichTextBox $RichTextBox
    .EXAMPLE
      Display-MyStatusRichTextBox -RichTextBox $RichTextBox -HashTable $HashTable
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $True)]
    [System.Windows.Forms.RichTextBox]$RichTextBox,
    [HashTable]$HashTable
  )
  Write-Verbose -Message "Enter Function Display-MyStatusRichTextBox"

  $DisplayResult = [System.Windows.Forms.DialogResult]::OK
  $RichTextBox.Refresh()

  If ($PSBoundParameters.ContainsKey("HashTable"))
  {
    If ($HashTable.ContainsKey("ShowHeader"))
    {
      $ShowHeader = $HashTable.ShowHeader
    }
    Else
    {
      $ShowHeader = $True
    }
  }
  Else
  {
    $ShowHeader = $True
  }

  # **************
  # RFT Formatting
  # **************
  # Permanate till Changed
  #$RichTextBox.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left
  #$RichTextBox.SelectionBullet = $True
  #$RichTextBox.SelectionIndent = 10
  # Resets After AppendText
  #$RichTextBox.SelectionBackColor = [MyConfig]::Colors.TextBack
  #$RichTextBox.SelectionCharOffset = 0
  #$RichTextBox.SelectionColor = [MyConfig]::Colors.TextFore
  #$RichTextBox.SelectionFont = [MyConfig]::Font.Bold
  # **********************
  # Update RichTextBox Text...
  # **********************

  $RichTextBox.SelectionIndent = 10
  $RichTextBox.SelectionBullet = $False

  # Write KPI Event
  #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Some Unknown KPI Event"

  if ($ShowHeader)
  {
    Write-RichTextBox -RichTextBox $RichTextBox
    Write-RichTextBox -RichTextBox $RichTextBox -Font ([MyConfig]::Font.Title) -Alignment "Center" -Text "$($RichTextBox.Parent.Parent.Text)" -TextFore ([MyConfig]::Colors.TextTitle)
    Write-RichTextBox -RichTextBox $RichTextBox

    # Initialize StopWatch
    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
 }

  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Started Proccess List Data Here..." -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextTitle)
  $RichTextBox.SelectionIndent = 20
  $RichTextBox.SelectionBullet = $True

  if ($PSBoundParameters.ContainsKey("HashTable"))
  {
    :UserCancel foreach ($Key in $HashTable.Keys)
    {
      Write-RichTextBox -RichTextBox $RichTextBox -Text "Found Key" -TextFore ([MyConfig]::Colors.TextInfo) -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox -Text ": " -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox -Text "$($Key) = $($HashTable[$Key])" -TextFore ([MyConfig]::Colors.TextGood) -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox
      # Check for Fast Exit
      [System.Windows.Forms.Application]::DoEvents()
      If ($RichTextBox.Parent.Parent.Tag.Cancel)
      {
        $RichTextBox.SelectionIndent = 10
        $RichTextBox.SelectionBullet = $False
        Write-RichTextBox -RichTextBox $RichTextBox
        Write-RichTextBox -RichTextBox $RichTextBox -Text "Exiting - User Canceled" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextBad) -Alignment Center
        $DisplayResult = [System.Windows.Forms.DialogResult]::Cancel
        Break UserCancel
      }
      # Pause Processing Loop
      If ($RichTextBox.Parent.Parent.Tag.Pause)
      {
        $TmpPause = $RichTextBox.SelectionBullet
        $TmpTitle = $RichTextBox.Parent.Parent.Text
        $RichTextBox.Parent.Parent.Text = "$($TmpTitle) - PAUSED!"
        $RichTextBox.SelectionBullet = $False
        While ($RichTextBox.Parent.Parent.Tag.Pause)
        {
          [System.Threading.Thread]::Sleep(100)
          [System.Windows.Forms.Application]::DoEvents()
        }
        $RichTextBox.SelectionBullet = $TmpPause
        $RichTextBox.Parent.Parent.Text = $TmpTitle
      }
      Start-Sleep -Milliseconds 100
    }
  }
  else
  {
    :UserCancel For ($Count = 1; $Count -le 19; $Count++)
    {
      Write-RichTextBox -RichTextBox $RichTextBox -Text "$("X" * $Count)" -TextFore ([MyConfig]::Colors.TextInfo) -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox -Text " - " -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox -Text "Green" -TextFore ([MyConfig]::Colors.TextGood) -NoNewLine
      Write-RichTextBox -RichTextBox $RichTextBox
      # Check for Fast Exit
      [System.Windows.Forms.Application]::DoEvents()
      If ($RichTextBox.Parent.Parent.Tag.Cancel)
      {
        $RichTextBox.SelectionIndent = 10
        $RichTextBox.SelectionBullet = $False
        Write-RichTextBox -RichTextBox $RichTextBox
        Write-RichTextBox -RichTextBox $RichTextBox -Text "Exiting - User Canceled" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextBad) -Alignment Center
        $DisplayResult = [System.Windows.Forms.DialogResult]::Cancel
        Break UserCancel
      }
      # Pause Processing Loop
      If ($RichTextBox.Parent.Parent.Tag.Pause)
      {
        $TmpPause = $RichTextBox.SelectionBullet
        $TmpTitle = $RichTextBox.Parent.Parent.Text
        $RichTextBox.Parent.Parent.Text = "$($TmpTitle) - PAUSED!"
        $RichTextBox.SelectionBullet = $False
        While ($RichTextBox.Parent.Parent.Tag.Pause)
        {
          [System.Threading.Thread]::Sleep(100)
          [System.Windows.Forms.Application]::DoEvents()
        }
        $RichTextBox.SelectionBullet = $TmpPause
        $RichTextBox.Parent.Parent.Text = $TmpTitle
      }
      Start-Sleep -Milliseconds 100
    }
  }

  # Pause Before Deployment
  $RichTextBox.Parent.Parent.Tag.Pause = $True
  $TmpPause = $RichTextBox.SelectionBullet
  $TmpTitle = $RichTextBox.Parent.Parent.Text
  $RichTextBox.Parent.Parent.Text = "$($TmpTitle) - PAUSED!"
  $RichTextBox.SelectionBullet = $False

  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Pause to Review Status" -Font ([MyConfig]::Font.Bold) -Alignment Center
  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Press 'Pause' to Continue with the Current Deployment" -Alignment Center
  Write-RichTextBox -RichTextBox $RichTextBox -Text "or Ctrl-Alt-Backspace to Exit / Cancel" -Alignment Center
  Write-RichTextBox -RichTextBox $RichTextBox

  While ($RichTextBox.Parent.Parent.Tag.Pause)
  {
    [System.Threading.Thread]::Sleep(100)
    [System.Windows.Forms.Application]::DoEvents()
    If ($RichTextBox.Parent.Parent.Tag.Cancel)
    {
      $RichTextBox.Parent.Parent.Tag.Pause = $False
      $RichTextBox.SelectionIndent = 10
      $RichTextBox.SelectionBullet = $False
      Write-RichTextBox -RichTextBox $RichTextBox
      Write-RichTextBox -RichTextBox $RichTextBox -Text "Exiting - User Canceled" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextBad) -Alignment Center
      $DisplayResult = [System.Windows.Forms.DialogResult]::Cancel
    }
  }
  $RichTextBox.SelectionBullet = $TmpPause
  $RichTextBox.Parent.Parent.Text = $TmpTitle

  $RichTextBox.SelectionIndent = 10
  $RichTextBox.SelectionBullet = $False
  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Show Fake Error Message"-TextFore ([MyConfig]::Colors.TextWarn) -Font ([MyConfig]::Font.Bold)
  $RichTextBox.SelectionIndent = 20
  $RichTextBox.SelectionBullet = $True

  if ($ShowHeader)
  {

    Try
    {
      Throw "This is a Fake Error!"
    }
    Catch
    {
      # Write Error to Status Dialog
      Write-RichTextBoxError -RichTextBox $RichTextBox
    }

    $RichTextBox.SelectionIndent = 10
    $RichTextBox.SelectionBullet = $False
    Write-RichTextBox -RichTextBox $RichTextBox

    if ($DisplayResult -eq [System.Windows.Forms.DialogResult]::OK)
    {
      $FinalMsg = "Add Success Message Here!"
      $FinalClr = [MyConfig]::Colors.TextGood
    }
    else
    {
      $FinalMsg = "Add Error Message Here!"
      $FinalClr = [MyConfig]::Colors.TextBad
    }

    Write-RichTextBox -RichTextBox $RichTextBox
    Write-RichTextBox -RichTextBox $RichTextBox -Font ([MyConfig]::Font.Title) -Alignment "Center" -TextFore $FinalClr -Text $FinalMsg
    Write-RichTextBox -RichTextBox $RichTextBox

    Write-RichTextBox -RichTextBox $RichTextBox -Alignment "Center" -Text ($StopWatch.Elapsed.ToString())
    Write-RichTextBox -RichTextBox $RichTextBox
  }

  $DisplayResult
  $DisplayResult = $Null

  Write-Verbose -Message "Exit Function Display-MyStatusRichTextBox"
}
#endregion function Display-MyStatusRichTextBox

# ---------------------------------
# Add Custom Display Status Message
# ---------------------------------
#region function Display-InitiliazeFCGUtility
Function Display-InitiliazeFCGUtility()
{
  <#
    .SYNOPSIS
      Display Utility Status Sample Function
    .DESCRIPTION
      Display Utility Status Sample Function
    .PARAMETER RichTextBox
    .PARAMETER HashTable
    .EXAMPLE
      Display-InitiliazeFCGUtility -RichTextBox $RichTextBox
    .EXAMPLE
      Display-InitiliazeFCGUtility -RichTextBox $RichTextBox -HashTable $HashTable
    .NOTES
      Original Script By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $True)]
    [System.Windows.Forms.RichTextBox]$RichTextBox,
    [HashTable]$HashTable
  )
  Write-Verbose -Message "Enter Function Display-InitiliazeFCGUtility"
  
  $DisplayResult = [System.Windows.Forms.DialogResult]::OK
  $RichTextBox.Refresh()
  
  If ($PSBoundParameters.ContainsKey("HashTable"))
  {
    If ($HashTable.ContainsKey("ShowHeader"))
    {
      $ShowHeader = $HashTable.ShowHeader
    }
    Else
    {
      $ShowHeader = $True
    }
  }
  Else
  {
    $ShowHeader = $True
  }
  
  $RichTextBox.SelectionIndent = 10
  $RichTextBox.SelectionBullet = $False
  
  # Write KPI Event
  #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Some Unknown KPI Event"
  
  If ($ShowHeader)
  {
    Write-RichTextBox -RichTextBox $RichTextBox
    Write-RichTextBox -RichTextBox $RichTextBox -Font ([MyConfig]::Font.Title) -Alignment "Center" -Text "$($RichTextBox.Parent.Parent.Text)" -TextFore ([MyConfig]::Colors.TextTitle)
    Write-RichTextBox -RichTextBox $RichTextBox
    
    # Initialize StopWatch
    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  }
  
  
  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Validate Runtime Parameters" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextTitle)
  $RichTextBox.SelectionIndent = 20
  $RichTextBox.SelectionBullet = $True
  
  #region ******** Validating Runtime Parameters ********
  
  # Script / Utility
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Utility" -Value ([MyConfig]::ScriptName) -ValueFore ([MyConfig]::Colors.TextGood)
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Version" -Value ([MyConfig]::ScriptVersion) -ValueFore ([MyConfig]::Colors.TextGood)
  
  # Run From/As Info
  $TmpRunFrom = Get-WmiObject -Query "Select Name, Domain, PartOfDomain From Win32_ComputerSystem"
  If ($TmpRunFrom.PartOfDomain)
  {
    $TmpRunFromText = "$($TmpRunFrom.Name).$($TmpRunFrom.Domain)"
  }
  Else
  {
    $TmpRunFromText = "$($TmpRunFrom.Name)"
  }
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Run From" -Value $TmpRunFromText
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Run As" -Value "$([Environment]::UserDomainName)\$([Environment]::UserName)"
  
  # Microsoft Entra Logon
  #Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Microsoft Entra Logon: " -Value ([MyConfig]::AADLogonInfo.Context.Account.Id)
  
  # Logon Authentication
  If ([MyConfig]::CurrentUser.AuthenticationType -eq "CloudAP")
  {
    $TmpText = "Microsoft Entra"
  }
  Else
  {
    $TmpText = "Active Directory"
  }
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Authentication" -Value "$($TmpText)"
  
  # Verify OS Architecture
  $TempRunOS = Get-WmiObject -Query "Select Caption, Version, OSArchitecture From Win32_OperatingSystem"
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Op Sys" -Value "$($TempRunOS.Caption)"
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Build" -Value "$($TempRunOS.Version)"
  
  # Verify AC Power
  $ChkBattery = (Get-WmiObject -Class Win32_Battery).BatteryStatus
  If ([String]::IsNullOrEmpty($ChkBattery) -or ($ChkBattery -eq 2))
  {
    $TmpText = "Yes"
    $TmpColor = [MyConfig]::Colors.TextGood
  }
  Else
  {
    $TmpText = "No"
    $TmpColor = [MyConfig]::Colors.TextWarn
  }
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "AC Power" -Value "$($TmpText)" -ValueFore $TmpColor
  
  # -------------------------
  # Display Passed Parameters
  # -------------------------
  $CheckParams = $Script:PSBoundParameters
  If ($CheckParams.Keys.Count)
  {
    Write-RichTextBox -RichTextBox $RichTextBox -Text "Runtime Parameters"
    ForEach ($Key In $CheckParams.Keys)
    {
      $RichTextBox.SelectionIndent = 30
      Write-RichTextBoxValue -RichTextBox $RichTextBox -Text $Key -Value $($CheckParams[$Key])
    }
  }
  
  #endregion ******** Validating Runtime Parameters ********
  
  $RichTextBox.SelectionIndent = 10
  $RichTextBox.SelectionBullet = $False
  Write-RichTextBox -RichTextBox $RichTextBox
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Start Script Specific Init Here" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextTitle)
  
  $RichTextBox.SelectionIndent = 20
  $RichTextBox.SelectionBullet = $True
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Config Step" -Value "Step Value"
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Config Step" -Value "Step Value"
  
  If ($ShowHeader)
  {
    $RichTextBox.SelectionIndent = 10
    $RichTextBox.SelectionBullet = $False
    Write-RichTextBox -RichTextBox $RichTextBox
    
    If ($DisplayResult -eq [System.Windows.Forms.DialogResult]::OK)
    {
      $FinalMsg = "Initialization was Successful"
      $FinalClr = [MyConfig]::Colors.TextGood
    }
    Else
    {
      $FinalMsg = "Initialization Failed"
      $FinalClr = [MyConfig]::Colors.TextBad
    }
    
    Write-RichTextBox -RichTextBox $RichTextBox
    Write-RichTextBox -RichTextBox $RichTextBox -Font ([MyConfig]::Font.Title) -Alignment "Center" -TextFore $FinalClr -Text $FinalMsg
    Write-RichTextBox -RichTextBox $RichTextBox
    
    Write-RichTextBox -RichTextBox $RichTextBox -Alignment "Center" -Text ($StopWatch.Elapsed.ToString())
    Write-RichTextBox -RichTextBox $RichTextBox
  }
  
  $DisplayResult
  $DisplayResult = $Null
  
  Write-Verbose -Message "Exit Function Display-InitiliazeFCGUtility"
}
#endregion function Display-InitiliazeFCGUtility


#endregion ================ FCG Common Dialogs ================

#region >>>>>>>>>>>>>>>> FCG Custom Dialogs <<<<<<<<<<<<<<<<

#endregion ================ FCG Custom Dialogs ================

#region >>>>>>>>>>>>>>>> Begin **** FCG **** Begin <<<<<<<<<<<<<<<<

#$Result = [System.Windows.Forms.MessageBox]::Show($FCGForm, "Message Text", [MyConfig]::ScriptName, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

$FCGFormComponents = [System.ComponentModel.Container]::New()

#region $FCGOpenFileDialog = [System.Windows.Forms.OpenFileDialog]::New()
$FCGOpenFileDialog = [System.Windows.Forms.OpenFileDialog]::New()
#$FCGOpenFileDialog.AddExtension = $True
#$FCGOpenFileDialog.AutoUpgradeEnabled = $True
#$FCGOpenFileDialog.CheckFileExists = $True
#$FCGOpenFileDialog.CheckPathExists = $True
#$FCGOpenFileDialog.DefaultExt = ""
#$FCGOpenFileDialog.DereferenceLinks = $True
#$FCGOpenFileDialog.FileName = ""
#$FCGOpenFileDialog.Filter = ""
#$FCGOpenFileDialog.FilterIndex = 1
#$FCGOpenFileDialog.InitialDirectory = ""
#$FCGOpenFileDialog.Multiselect = $False
#$FCGOpenFileDialog.ReadOnlyChecked = $False
#$FCGOpenFileDialog.RestoreDirectory = $False
#$FCGOpenFileDialog.ShowHelp = $False
#$FCGOpenFileDialog.ShowReadOnly = $False
#$FCGOpenFileDialog.SupportMultiDottedExtensions = $False
#$FCGOpenFileDialog.Tag = [System.Object]::New()
#$FCGOpenFileDialog.Title = ""
#$FCGOpenFileDialog.ValidateNames = $True
#endregion $FCGOpenFileDialog = [System.Windows.Forms.OpenFileDialog]::New()

# How to Call / Use $FCGOpenFileDialog
#$FCGOpenFileDialog.FileName = ""
#$FCGOpenFileDialog.Filter = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
#$FCGOpenFileDialog.FilterIndex = 1
#$FCGOpenFileDialog.InitialDirectory = $PSScriptRoot
#$FCGOpenFileDialog.Multiselect = $False
#$FCGOpenFileDialog.Title = "Show this Title to the User"
#$FCGOpenFileDialog.Tag = $Null
#$Response = $FCGOpenFileDialog.ShowDialog()
#If ($Response = [System.Windows.Forms.DialogResult]::OK)
#{
#  # Do Work Here
#}

#$FCGOpenFileDialog.CustomPlaces.Add([System.String]$Path)
#$FCGOpenFileDialog.CustomPlaces.Add([System.Guid]$KnownFolderGuid)
#$FCGOpenFileDialog.BeginUpdate()
#$FCGOpenFileDialog.EndUpdate()


#region $FCGSaveFileDialog = [System.Windows.Forms.SaveFileDialog]::New()
$FCGSaveFileDialog = [System.Windows.Forms.SaveFileDialog]::New()
#$FCGSaveFileDialog.AddExtension = $True
#$FCGSaveFileDialog.AutoUpgradeEnabled = $True
#$FCGSaveFileDialog.CheckFileExists = $False
#$FCGSaveFileDialog.CheckPathExists = $True
#$FCGSaveFileDialog.CreatePrompt = $False
#$FCGSaveFileDialog.DefaultExt = ""
#$FCGSaveFileDialog.DereferenceLinks = $True
#$FCGSaveFileDialog.FileName = ""
#$FCGSaveFileDialog.Filter = ""
#$FCGSaveFileDialog.FilterIndex = 1
#$FCGSaveFileDialog.InitialDirectory = ""
#$FCGSaveFileDialog.OverwritePrompt = $True
#$FCGSaveFileDialog.RestoreDirectory = $False
#$FCGSaveFileDialog.ShowHelp = $False
#$FCGSaveFileDialog.SupportMultiDottedExtensions = $False
#$FCGSaveFileDialog.Tag = [System.Object]::New()
#$FCGSaveFileDialog.Title = ""
#$FCGSaveFileDialog.ValidateNames = $True
#endregion $FCGSaveFileDialog = [System.Windows.Forms.SaveFileDialog]::New()

# How to Call / Use $FCGSaveFileDialog
#$FCGSaveFileDialog.FileName = "")
#$FCGSaveFileDialog.Filter = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
#$FCGSaveFileDialog.FilterIndex = 1
#$FCGSaveFileDialog.InitialDirectory = $PSScriptRoot
#$FCGSaveFileDialog.Title = "Show this Title to the User"
#$FCGSaveFileDialog.Tag = $Null
#$Response = $FCGSaveFileDialog.ShowDialog()
#If ($Response = [System.Windows.Forms.DialogResult]::OK)
#{
#  # Do Work Here
#}

#$FCGSaveFileDialog.CustomPlaces.Add([System.String]$Path)
#$FCGSaveFileDialog.CustomPlaces.Add([System.Guid]$KnownFolderGuid)
#$FCGSaveFileDialog.BeginUpdate()
#$FCGSaveFileDialog.EndUpdate()


#region $FCGFolderBrowserDialog = [System.Windows.Forms.FolderBrowserDialog]::New()
$FCGFolderBrowserDialog = [System.Windows.Forms.FolderBrowserDialog]::New()
#$FCGFolderBrowserDialog.Description = ""
#$FCGFolderBrowserDialog.RootFolder = [System.Environment+SpecialFolder]::Desktop
#$FCGFolderBrowserDialog.SelectedPath = ""
#$FCGFolderBrowserDialog.ShowNewFolderButton = $True
#$FCGFolderBrowserDialog.Tag = [System.Object]::New()
#endregion $FCGFolderBrowserDialog = [System.Windows.Forms.FolderBrowserDialog]::New()

# How to Call / Use $FCGFolderBrowserDialog
#$FCGFolderBrowserDialog.Description = "Select a Random Folder"
#$FCGFolderBrowserDialog.RootFolder = [System.Environment+SpecialFolder]::Desktop
#$FCGFolderBrowserDialog.SelectedPath = "C:\Windows"
#$FCGFolderBrowserDialog.ShowNewFolderButton = $True
#$FCGFolderBrowserDialog.Tag = $Null
#$Response = $FCGFolderBrowserDialog.ShowDialog()
#If ($Response = [System.Windows.Forms.DialogResult]::OK)
#{
#  # Do Work Here
#}


#region $FCGToolTip = [System.Windows.Forms.ToolTip]::New()
$FCGToolTip = [System.Windows.Forms.ToolTip]::New($FCGFormComponents)
#$FCGToolTip.Active = $True
#$FCGToolTip.AutomaticDelay = 500
#$FCGToolTip.AutoPopDelay = 5000
#$FCGToolTip.BackColor = [MyConfig]::Colors.Back
#$FCGToolTip.ForeColor = [MyConfig]::Colors.Fore
#$FCGToolTip.InitialDelay = 500
#$FCGToolTip.IsBalloon = $False
#$FCGToolTip.OwnerDraw = $False
#$FCGToolTip.ReshowDelay = 100
#$FCGToolTip.ShowAlways = $False
#$FCGToolTip.StripAmpersands = $False
#$FCGToolTip.Tag = [System.Object]::New()
#$FCGToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
#$FCGToolTip.ToolTipTitle = "$([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
#$FCGToolTip.UseAnimation = $True
#$FCGToolTip.UseFading = $True
#endregion $FCGToolTip = [System.Windows.Forms.ToolTip]::New()

#$FCGToolTip.SetToolTip($FormControl, "Form Control Help")

# ************************************************
# FCG ImageList
# ************************************************
#region $FCGImageList = [System.Windows.Forms.ImageList]::New()
$FCGImageList = [System.Windows.Forms.ImageList]::New($FCGFormComponents)
#$FCGImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth8Bit
#$FCGImageList.ImageSize = [System.Drawing.Size]::New(16, 16)
#$FCGImageList.ImageStream = [System.Windows.Forms.ImageListStreamer]::New()
#$FCGImageList.Tag = [System.Object]::New()
#$FCGImageList.TransparentColor = [System.Drawing.Color]::Color [Transparent]
#endregion $FCGImageList = [System.Windows.Forms.ImageList]::New()

#$FCGImageList.Images.Add([System.Drawing.Image]$Value, [System.Drawing.Color]$TransparentColor)
#$FCGImageList.Images.Add([System.Windows.Forms.ImageList+Original]$Original, [System.Windows.Forms.ImageList+ImageCollection+ImageInfo]$ImageInfo)
#$FCGImageList.Images.Add([System.String]$Key, [System.Drawing.Image]$Image)
#$FCGImageList.Images.Add([System.String]$Key, [System.Drawing.Icon]$Icon)
#$FCGImageList.Images.Add([System.Drawing.Icon]$Value)
#$FCGImageList.Images.Add([System.Drawing.Image]$Value)
#$FCGImageList.Images.AddRange([System.Drawing.Image[]]$Images)
#$FCGImageList.BeginUpdate()
#$FCGImageList.EndUpdate()


#region ******** FCG Custom Icons ********

#region ******** $FCGFormIcon ********
# Icons for Forms are 16x16
$FCGFormIcon = @"
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
#endregion ******** $FCGFormIcon ********
$FCGImageList.Images.Add("FCGFormIcon", [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($FCGFormIcon))))

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
$FCGImageList.Images.Add("ExitIcon", [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($ExitIcon))))

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
$FCGImageList.Images.Add("HelpIcon", [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($HelpIcon))))

#region ******** $BugIcon ********
$BugIcon = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE/UHwBQ1VsAUNVaAFDVHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACFjYfAp57/oAfvf/AH/4/wBx7vkAVtp0AAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADVvYaSuR+P8jlv//DYX4/wB/+f8Acu//AHz2/gBV2GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABycHAgL2CxCyB86u4YbOL/BU7R/xd+8P8Jdu7/AELK/wB4
8/8AaejoKF2zCnFwcRwAAAAAAAAAAAAAAAAAAAAAdXJupTVdpY8tnvv/AkjO/wVLz/8lh/P/Ho35/w2D9/8Ah/7/AIH6/0Bfm7R0cW9zAAAAAAAAAAAAAAAAAAAAAGxudR08aKbzJ6b//y6g/P81of3/MJX4/yqT
+f8ilP3/AEnP/wBu7P83YqbXYmt9BgAAAAAAAAAAAAAAAAAAAAAAAAAAE2XNkheo//8npv//MaX//y+X+P8xl/r/MZz+/xp+7/8MiPr/CFrUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZZ0W0Fpv7/CGrf/wtc
2P8qmfj/MJn5/xNl3v8ff+7/IpX+/wlX02MAAAAAAAAAAAAAAAAAAAAAAAAAAHBwcltIZJSJAJD0/xKX9P8QjfH/IJr4/yua+f8MW9j/In3r/yWG8f9LZZWFbm9zSgAAAAAAAAAAAAAAAAAAAAB0cW5HZ2xzYSZe
luFPkLD/Inyv/yp1q/8ydaz/Onqu/zx4rf8yW5TbZmt0XnRxbjgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABRT1CZkI2M/2pmZf9jYF//XFlY/1RRUP9LSEf/RUNFjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AABxbmsbbWpny3BtbPGCfn3/Y2Bf/1xZWP9UUVD/SUZF72xpZr1vbGkIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdXJvMmxpZjBVUlFMdXJy9oOAf/9tamn/UExM9ExIR0RsaWZKdHFuGAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAE9MSyVSTk55UExMd0pGRiIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA//+sQfw/rEH4H6xB8A+sQcADrEHAA6xBwAOsQeAHrEHgB6xBwAOsQcADrEHwD6xB4AesQeAHrEH8P6xB//+sQQ==
"@
#endregion ******** $BugIcon ********
$FCGImageList.Images.Add("BugIcon", [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($BugIcon))))

#endregion ******** FCG Custom Icons ********


# ************************************************
# FCG Form
# ************************************************
#region $FCGForm = [System.Windows.Forms.Form]::New()
$FCGForm = [System.Windows.Forms.Form]::New()
#$FCGForm.AcceptButton = [System.Windows.Forms.IButtonControl]::New()
#$FCGForm.ActiveControl = [System.Windows.Forms.Control]::New()
#$FCGForm.AllowDrop = $False
#$FCGForm.AllowTransparency = $False
#$FCGForm.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
#$FCGForm.AutoScale = $True
#$FCGForm.AutoScaleBaseSize = [System.Drawing.Size]::New(5, 13)
#$FCGForm.AutoScaleDimensions = [System.Drawing.SizeF]::New(0, 0)
#$FCGForm.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
#$FCGForm.AutoScroll = $False
#$FCGForm.AutoScrollMargin = [System.Drawing.Size]::New(0, 0)
#$FCGForm.AutoScrollMinSize = [System.Drawing.Size]::New(0, 0)
#$FCGForm.AutoScrollOffset = [System.Drawing.Point]::New(0, 0)
#$FCGForm.AutoScrollPosition = [System.Drawing.Point]::New(0, 0)
#$FCGForm.AutoSize = $False
#$FCGForm.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowOnly
#$FCGForm.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
$FCGForm.BackColor = [MyConfig]::Colors.Back
#$FCGForm.BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($ImageString)))
#$FCGForm.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
#$FCGForm.BindingContext = [System.Windows.Forms.BindingContext]::New()
#$FCGForm.Bounds = [System.Drawing.Rectangle]::New(0, 0, 300, 300)
#$FCGForm.CancelButton = [System.Windows.Forms.IButtonControl]::New()
#$FCGForm.Capture = $False
#$FCGForm.CausesValidation = $True
#$FCGForm.ClientSize = [System.Drawing.Size]::New(284, 261)
#$FCGForm.ContextMenu = [System.Windows.Forms.ContextMenu]::New()
#$FCGForm.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGForm.ControlBox = $True
#$FCGForm.Cursor = [System.Windows.Forms.Cursors]::Default
#$FCGForm.DesktopBounds = [System.Drawing.Rectangle]::New(0, 0, 300, 300)
#$FCGForm.DesktopLocation = [System.Drawing.Point]::New(0, 0)
#$FCGForm.DialogResult = [System.Windows.Forms.DialogResult]::None
#$FCGForm.Dock = [System.Windows.Forms.DockStyle]::None
#$FCGForm.Enabled = $True
$FCGForm.Font = [MyConfig]::Font.Regular
$FCGForm.ForeColor = [MyConfig]::Colors.Fore
#$FCGForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
#$FCGForm.Height = 300
#$FCGForm.HelpButton = $False
$FCGForm.Icon = [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($FCGFormIcon)))
#$FCGForm.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
#$FCGForm.IsAccessible = $False
#$FCGForm.IsMdiContainer = $False
$FCGForm.KeyPreview = $True
#$FCGForm.Left = 0
#$FCGForm.Location = [System.Drawing.Point]::New(0, 0)
#$FCGForm.MainMenuStrip = [System.Windows.Forms.MenuStrip]::New()
#$FCGForm.Margin = [System.Windows.Forms.Padding]::New([MyConfig]::FormSpacer, 3, [MyConfig]::FormSpacer, 3)
#$FCGForm.MaximizeBox = $True
#$FCGForm.MaximumSize = [System.Drawing.Size]::New(0, 0)
#$FCGForm.MdiParent = [System.Windows.Forms.Form]::New()
#$FCGForm.Menu = [System.Windows.Forms.MainMenu]::New()
#$FCGForm.MinimizeBox = $True
$FCGForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * [MyConfig]::FormMinWidth), ([MyConfig]::Font.Height * [MyConfig]::FormMinHeight))
$FCGForm.Name = "FCGForm"
#$FCGForm.Opacity = 1
#$FCGForm.Owner = [System.Windows.Forms.Form]::New()
#$FCGForm.Padding = [System.Windows.Forms.Padding]::New([MyConfig]::FormSpacer, 0, [MyConfig]::FormSpacer, 0)
#$FCGForm.Parent = [System.Windows.Forms.Control]::New()
#$FCGForm.Region = [System.Drawing.Region]::New()
#$FCGForm.RightToLeft = [System.Windows.Forms.RightToLeft]::No
#$FCGForm.RightToLeftLayout = $False
#$FCGForm.ShowIcon = $True
#$FCGForm.ShowInTaskbar = $True
#$FCGForm.Size = [System.Drawing.Size]::New(300, 300)
#$FCGForm.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Auto
#$FCGForm.StartPosition = [System.Windows.Forms.FormStartPosition]::WindowsDefaultLocation
#$FCGForm.TabIndex = 0
#$FCGForm.TabStop = $True
#$FCGForm.Tag = (-not [MyConfig]::Production)
$FCGForm.Text = "$([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
#$FCGForm.Top = 0
#$FCGForm.TopLevel = $True
#$FCGForm.TopMost = $False
#$FCGForm.TransparencyKey = [System.Drawing.Color]::Color [Empty]
#$FCGForm.UseWaitCursor = $False
#$FCGForm.Visible = $False
#$FCGForm.Width = 300
#$FCGForm.WindowState = [System.Windows.Forms.FormWindowState]::Normal
#endregion $FCGForm = [System.Windows.Forms.Form]::New()

#region ******** Function Start-FCGFormClosing ********
function Start-FCGFormClosing
{
  <#
    .SYNOPSIS
      Closing Event for the FCG Form Control
    .DESCRIPTION
      Closing Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Closing Event
    .PARAMETER EventArg
       The Event Arguments for the Form Closing Event
    .EXAMPLE
       Start-FCGFormClosing -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Closing Event for `$FCGForm"

  [MyConfig]::AutoExit = 0

  #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 2 -Category 0 -Message "Exiting $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"

  if ([MyConfig]::Production)
  {
    # Show Console Window
    $Script:VerbosePreference = "Continue"
    $Script:DebugPreference = "Continue"

    [Void][Console.Window]::Show()
    [System.Console]::Title = "CLOSING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
    $FCGForm.Tag = $True
  }

  Write-Verbose -Message "Exit Closing Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormClosing ********
$FCGForm.add_Closing({Start-FCGFormClosing -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGFormKeyDown ********
function Start-FCGFormKeyDown
{
  <#
    .SYNOPSIS
      KeyDown Event for the FCG Form Control
    .DESCRIPTION
      KeyDown Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the Form KeyDown Event
    .EXAMPLE
       Start-FCGFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyDown Event for `$FCGForm"

  [MyConfig]::AutoExit = 0

  If ($EventArg.Control -and $EventArg.Alt)
  {
    Switch ($EventArg.KeyCode)
    {
      "F10"
      {
        If ($FCGForm.Tag)
        {
          # Hide Console Window
          $Script:VerbosePreference = "SilentlyContinue"
          $Script:DebugPreference = "SilentlyContinue"
          [System.Console]::Title = "RUNNING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
          [Void][Console.Window]::Hide()
          $FCGForm.Tag = $False
        }
        Else
        {
          # Show Console Window
          $Script:VerbosePreference = "Continue"
          $Script:DebugPreference = "Continue"
          [Void][Console.Window]::Show()
          [System.Console]::Title = "DEBUG: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
          $FCGForm.Tag = $True
        }
        $FCGForm.Activate()
        $FCGForm.Select()
        Break
      }
    }
  }
  Else
  {
    Switch ($EventArg.KeyCode)
    {
      "F1"
      {
        $FCGToolTip.Active = (-not $FCGToolTip.Active)
        $FCGBtmStatusStrip.Items["Status"].Text = "Enable / Disable My PS5 Form Code Generator ToolTips = $($FCGToolTip.Active)"
        Break
      }
      "F2"
      {
        $FCGBtmStatusStrip.Items["Status"].Text = "Show Change Log for $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
        $ScriptContents = ($Script:MyInvocation.MyCommand.ScriptBlock).ToString()
        $CLogStart = ($ScriptContents.IndexOf("<#") + 2)
        $CLogEnd = $ScriptContents.IndexOf("#>")
        Show-ChangeLogDialog -ChangeText ($ScriptContents.SubString($CLogStart, ($CLogEnd - $CLogStart)))
        Break
      }
    }
  }

  Write-Verbose -Message "Exit KeyDown Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormKeyDown ********
$FCGForm.add_KeyDown({Start-FCGFormKeyDown -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGFormLoad ********
function Start-FCGFormLoad
{
  <#
    .SYNOPSIS
      Load Event for the FCG Form Control
    .DESCRIPTION
      Load Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Load Event
    .PARAMETER EventArg
       The Event Arguments for the Form Load Event
    .EXAMPLE
       Start-FCGFormLoad -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Load Event for `$FCGForm"

  [MyConfig]::AutoExit = 0

  $Screen = ([System.Windows.Forms.Screen]::FromControl($Sender)).WorkingArea
  $Sender.Left = [Math]::Floor(($Screen.Width - $Sender.Width) / 2)
  $Sender.Top = [Math]::Floor(($Screen.Height - $Sender.Height) / 2)

  if ([MyConfig]::Production)
  {
    # Disable Control Close Menu / [X]
    #[ControlBox.Menu]::DisableFormClose($FCGForm.Handle)

    # Hide Console Window
    $Script:VerbosePreference = "SilentlyContinue"
    $Script:DebugPreference = "SilentlyContinue"

    [System.Console]::Title = "RUNNING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
    [Void][Console.Window]::Hide()
    $FCGForm.Tag = $False
  }
  else
  {
    [Void][Console.Window]::Show()
    [System.Console]::Title = "DEBUG: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
    $FCGForm.Tag = $True
  }

  Write-Verbose -Message "Exit Load Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormLoad ********
$FCGForm.add_Load({Start-FCGFormLoad -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGFormMove ********
function Start-FCGFormMove
{
  <#
    .SYNOPSIS
      Move Event for the FCG Form Control
    .DESCRIPTION
      Move Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Move Event
    .PARAMETER EventArg
       The Event Arguments for the Form Move Event
    .EXAMPLE
       Start-FCGFormMove -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Move Event for `$FCGForm"

  [MyConfig]::AutoExit = 0


  Write-Verbose -Message "Exit Move Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormMove ********
$FCGForm.add_Move({Start-FCGFormMove -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGFormResize ********
function Start-FCGFormResize
{
  <#
    .SYNOPSIS
      Resize Event for the FCG Form Control
    .DESCRIPTION
      Resize Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Resize Event
    .PARAMETER EventArg
       The Event Arguments for the Form Resize Event
    .EXAMPLE
       Start-FCGFormResize -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Resize Event for `$FCGForm"

  [MyConfig]::AutoExit = 0


  Write-Verbose -Message "Exit Resize Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormResize ********
$FCGForm.add_Resize({Start-FCGFormResize -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGFormShown ********
function Start-FCGFormShown
{
  <#
    .SYNOPSIS
      Shown Event for the FCG Form Control
    .DESCRIPTION
      Shown Event for the FCG Form Control
    .PARAMETER Sender
       The Form Control that fired the Shown Event
    .PARAMETER EventArg
       The Event Arguments for the Form Shown Event
    .EXAMPLE
       Start-FCGFormShown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Form]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Shown Event for `$FCGForm"

  [MyConfig]::AutoExit = 0

  $Sender.Refresh()

  #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 1 -Category 0 -Message "Begin Running $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"

  $HashTable = @{"ShowHeader" = $True}
  $ScriptBlock = { [CmdletBinding()] param ([System.Windows.Forms.RichTextBox]$RichTextBox, [HashTable]$HashTable) Display-InitiliazeFCGUtility -RichTextBox $RichTextBox -HashTable $HashTable }
  $DialogResult = Show-MyStatusDialog -ScriptBlock $ScriptBlock -DialogTitle "Initializing $([MyConfig]::ScriptName)" -ButtonMid "OK" -HashTable $HashTable

  if ([MyConfig]::Production)
  {
    # Enable $FCGTimer
    $FCGTimer.Enabled = ([MyConfig]::AutoExitMax -gt 0)
  }

  Write-Verbose -Message "Exit Shown Event for `$FCGForm"
}
#endregion ******** Function Start-FCGFormShown ********
$FCGForm.add_Shown({Start-FCGFormShown -Sender $This -EventArg $PSItem})


#region ******** Controls for FCG Form ********

#region $FCGTimer = [System.Windows.Forms.Timer]::New()
$FCGTimer = [System.Windows.Forms.Timer]::New($FCGFormComponents)
#$FCGTimer.Enabled = $False
$FCGTimer.Interval = [MyConfig]::AutoExitTic
#$FCGTimer.Tag = [System.Object]::New()
#endregion $FCGTimer = [System.Windows.Forms.Timer]::New()

#region ******** Function Start-FCGTimerTick ********
function Start-FCGTimerTick
{
  <#
    .SYNOPSIS
      Tick Event for the FCG Timer Control
    .DESCRIPTION
      Tick Event for the FCG Timer Control
    .PARAMETER Sender
       The Timer Control that fired the Tick Event
    .PARAMETER EventArg
       The Event Arguments for the Timer Tick Event
    .EXAMPLE
       Start-FCGTimerTick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.Timer]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Tick Event for `$FCGTimer"

  [MyConfig]::AutoExit += 1
  Write-Verbose -Message "Auto Exit in $([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) Minutes"
  if ([MyConfig]::AutoExit -ge [MyConfig]::AutoExitMax)
  {
    $FCGForm.Close()
  }
  ElseIf (([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) -le 5)
  {
    $FCGBtmStatusStrip.Items["Status"].Text = "Auto Exit in $([MyConfig]::AutoExitMax - [MyConfig]::AutoExit) Minutes"
  }

  #$FCGBtmStatusStrip.Items["Status"].Text = "$($Sender.Name)"

  Write-Verbose -Message "Exit Tick Event for `$FCGTimer"
}
#endregion ******** Function Start-FCGTimerTick ********
$FCGTimer.add_Tick({Start-FCGTimerTick -Sender $This -EventArg $PSItem})


#region $FCGNotifyIcon = [System.Windows.Forms.NotifyIcon]::New()
$FCGNotifyIcon = [System.Windows.Forms.NotifyIcon]::New($FCGFormComponents)
#$FCGNotifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None
#$FCGNotifyIcon.BalloonTipText = ""
#$FCGNotifyIcon.BalloonTipTitle = ""
#$FCGNotifyIcon.ContextMenu = [System.Windows.Forms.ContextMenu]::New()
#$FCGNotifyIcon.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGNotifyIcon.Icon = $FCGForm.Icon
#$FCGNotifyIcon.Icon = [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($IconString)))
#$FCGNotifyIcon.Tag = [System.Object]::New()
$FCGNotifyIcon.Text = "FCGNotifyIcon"
#$FCGNotifyIcon.Visible = $False
#endregion $FCGNotifyIcon = [System.Windows.Forms.NotifyIcon]::New()

#region ******** Function Start-FCGNotifyIconMouseClick ********
function Start-FCGNotifyIconMouseClick
{
  <#
    .SYNOPSIS
      MouseClick Event for the FCG NotifyIcon Control
    .DESCRIPTION
      MouseClick Event for the FCG NotifyIcon Control
    .PARAMETER Sender
       The NotifyIcon Control that fired the MouseClick Event
    .PARAMETER EventArg
       The Event Arguments for the NotifyIcon MouseClick Event
    .EXAMPLE
       Start-FCGNotifyIconMouseClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.NotifyIcon]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter MouseClick Event for `$FCGNotifyIcon"

  [MyConfig]::AutoExit = 0

  #$FCGBtmStatusStrip.Items["Status"].Text = "$($Sender.Name)"

  Write-Verbose -Message "Exit MouseClick Event for `$FCGNotifyIcon"
}
#endregion ******** Function Start-FCGNotifyIconMouseClick ********
$FCGNotifyIcon.add_MouseClick({Start-FCGNotifyIconMouseClick -Sender $This -EventArg $PSItem})


# ************************************************
# FCGMain SplitContainer
# ************************************************
#region $FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGForm.Controls.Add($FCGMainSplitContainer)
#$FCGMainSplitContainer.ActiveControl = [System.Windows.Forms.Control]::New()
#$FCGMainSplitContainer.AllowDrop = $False
#$FCGMainSplitContainer.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
#$FCGMainSplitContainer.AutoScaleDimensions = [System.Drawing.SizeF]::New(0, 0)
#$FCGMainSplitContainer.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
#$FCGMainSplitContainer.AutoScroll = $False
#$FCGMainSplitContainer.AutoScrollMargin = [System.Drawing.Size]::New(0, 0)
#$FCGMainSplitContainer.AutoScrollMinSize = [System.Drawing.Size]::New(0, 0)
#$FCGMainSplitContainer.AutoScrollOffset = [System.Drawing.Point]::New(0, 0)
#$FCGMainSplitContainer.AutoScrollPosition = [System.Drawing.Point]::New(0, 0)
#$FCGMainSplitContainer.AutoSize = $False
#$FCGMainSplitContainer.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
#$FCGMainSplitContainer.BackColor = [MyConfig]::Colors.Back
#$FCGMainSplitContainer.BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($ImageString)))
#$FCGMainSplitContainer.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
#$FCGMainSplitContainer.BindingContext = [System.Windows.Forms.BindingContext]::New()
#$FCGMainSplitContainer.BorderStyle = [System.Windows.Forms.BorderStyle]::None
#$FCGMainSplitContainer.Bounds = [System.Drawing.Rectangle]::New(0, 0, 150, 100)
#$FCGMainSplitContainer.Capture = $False
#$FCGMainSplitContainer.CausesValidation = $True
#$FCGMainSplitContainer.ClientSize = [System.Drawing.Size]::New(150, 100)
#$FCGMainSplitContainer.ContextMenu = [System.Windows.Forms.ContextMenu]::New()
#$FCGMainSplitContainer.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGMainSplitContainer.Cursor = [System.Windows.Forms.Cursors]::Default
$FCGMainSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
#$FCGMainSplitContainer.Enabled = $True
#$FCGMainSplitContainer.FixedPanel = [System.Windows.Forms.FixedPanel]::None
#$FCGMainSplitContainer.Font = [MyConfig]::Font.Regular
#$FCGMainSplitContainer.ForeColor = [MyConfig]::Colors.Fore
#$FCGMainSplitContainer.Height = 100
#$FCGMainSplitContainer.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
#$FCGMainSplitContainer.IsAccessible = $False
#$FCGMainSplitContainer.IsSplitterFixed = $False
#$FCGMainSplitContainer.Left = 0
#$FCGMainSplitContainer.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
#$FCGMainSplitContainer.Margin = [System.Windows.Forms.Padding]::New(3, 3, 3, 3)
#$FCGMainSplitContainer.MaximumSize = [System.Drawing.Size]::New(0, 0)
#$FCGMainSplitContainer.MinimumSize = [System.Drawing.Size]::New(0, 0)
$FCGMainSplitContainer.Name = "FCGMainSplitContainer"
#$FCGMainSplitContainer.Orientation = [System.Windows.Forms.Orientation]::Vertical
#$FCGMainSplitContainer.Padding = [System.Windows.Forms.Padding]::New(0, 0, 0, 0)
#$FCGMainSplitContainer.Panel1Collapsed = $False
#$FCGMainSplitContainer.Panel1MinSize = 25
#$FCGMainSplitContainer.Panel2Collapsed = $False
#$FCGMainSplitContainer.Panel2MinSize = 25
#$FCGMainSplitContainer.Parent = [System.Windows.Forms.Control]::New()
#$FCGMainSplitContainer.Region = [System.Drawing.Region]::New()
#$FCGMainSplitContainer.RightToLeft = [System.Windows.Forms.RightToLeft]::No
#$FCGMainSplitContainer.Size = [System.Drawing.Size]::New(150, 100)
#$FCGMainSplitContainer.SplitterDistance = 50
#$FCGMainSplitContainer.SplitterIncrement = 1
#$FCGMainSplitContainer.SplitterWidth = 4
#$FCGMainSplitContainer.TabIndex = 0
#$FCGMainSplitContainer.TabStop = $True
#$FCGMainSplitContainer.Tag = [System.Object]::New()
$FCGMainSplitContainer.Text = "FCGMainSplitContainer"
#$FCGMainSplitContainer.Top = 0
#$FCGMainSplitContainer.UseWaitCursor = $False
#$FCGMainSplitContainer.Visible = $True
#$FCGMainSplitContainer.Width = 150
#endregion $FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()

# ************************************************
# $FCGMainSplitContainer Panel1 Controls
# ************************************************
#region ******** $FCGMainSplitContainer Panel1 Controls ********

$FCGMainSplitContainer.Panel1.Padding = [System.Windows.Forms.Padding]::New([MyConfig]::FormSpacer, 0, 0, 0)

#endregion ******** $FCGMainSplitContainer Panel1 Controls ********

# ************************************************
# $FCGMainSplitContainer Panel2 Controls
# ************************************************
#region ******** $FCGMainSplitContainer Panel2 Controls ********

$FCGMainSplitContainer.Panel2.Padding = [System.Windows.Forms.Padding]::New(0, 0, [MyConfig]::FormSpacer, 0)

#endregion ******** $FCGMainSplitContainer Panel2 Controls ********


# ************************************************
# FCGTop MenuStrip
# ************************************************
#region $FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()
$FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()
$FCGForm.Controls.Add($FCGTopMenuStrip)
$FCGForm.MainMenuStrip = $FCGTopMenuStrip
#$FCGTopMenuStrip.AllowDrop = $False
#$FCGTopMenuStrip.AllowItemReorder = $False
#$FCGTopMenuStrip.AllowMerge = $True
#$FCGTopMenuStrip.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
#$FCGTopMenuStrip.AutoScroll = $False
#$FCGTopMenuStrip.AutoScrollMargin = [System.Drawing.Size]::New(0, 0)
#$FCGTopMenuStrip.AutoScrollMinSize = [System.Drawing.Size]::New(0, 0)
#$FCGTopMenuStrip.AutoScrollOffset = [System.Drawing.Point]::New(0, 0)
#$FCGTopMenuStrip.AutoScrollPosition = [System.Drawing.Point]::New(0, 0)
#$FCGTopMenuStrip.AutoSize = $True
$FCGTopMenuStrip.BackColor = [MyConfig]::Colors.Back
#$FCGTopMenuStrip.BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($ImageString)))
#$FCGTopMenuStrip.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
#$FCGTopMenuStrip.BindingContext = [System.Windows.Forms.BindingContext]::New()
#$FCGTopMenuStrip.Bounds = [System.Drawing.Rectangle]::New(0, 0, 200, 24)
#$FCGTopMenuStrip.CanOverflow = $False
#$FCGTopMenuStrip.Capture = $False
#$FCGTopMenuStrip.CausesValidation = $False
#$FCGTopMenuStrip.ClientSize = [System.Drawing.Size]::New(200, 24)
#$FCGTopMenuStrip.ContextMenu = [System.Windows.Forms.ContextMenu]::New()
#$FCGTopMenuStrip.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGTopMenuStrip.Cursor = [System.Windows.Forms.Cursors]::Default
#$FCGTopMenuStrip.DefaultDropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
#$FCGTopMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Top
#$FCGTopMenuStrip.Enabled = $True
$FCGTopMenuStrip.Font = [MyConfig]::Font.Regular
$FCGTopMenuStrip.ForeColor = [MyConfig]::Colors.Fore
#$FCGTopMenuStrip.GripMargin = [System.Windows.Forms.Padding]::New(2, 2, 0, 2)
#$FCGTopMenuStrip.GripStyle = [System.Windows.Forms.ToolStripGripStyle]::Hidden
#$FCGTopMenuStrip.Height = 24
$FCGTopMenuStrip.ImageList = $FCGImageList
#$FCGTopMenuStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
#$FCGTopMenuStrip.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
#$FCGTopMenuStrip.IsAccessible = $False
#$FCGTopMenuStrip.LayoutSettings = [System.Windows.Forms.LayoutSettings]::New()
#$FCGTopMenuStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::HorizontalStackWithOverflow
#$FCGTopMenuStrip.Left = 0
#$FCGTopMenuStrip.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
#$FCGTopMenuStrip.Margin = [System.Windows.Forms.Padding]::New(0, 0, 0, 0)
#$FCGTopMenuStrip.MaximumSize = [System.Drawing.Size]::New(0, 0)
#$FCGTopMenuStrip.MdiWindowListItem = [System.Windows.Forms.ToolStripMenuItem]::New()
#$FCGTopMenuStrip.MinimumSize = [System.Drawing.Size]::New(0, 0)
$FCGTopMenuStrip.Name = "FCGTopMenuStrip"
#$FCGTopMenuStrip.Padding = [System.Windows.Forms.Padding]::New(6, 2, 0, 2)
#$FCGTopMenuStrip.Parent = [System.Windows.Forms.Control]::New()
#$FCGTopMenuStrip.Region = [System.Drawing.Region]::New()
#$FCGTopMenuStrip.Renderer = [System.Windows.Forms.ToolStripRenderer]::New()
#$FCGTopMenuStrip.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::ManagerRenderMode
#$FCGTopMenuStrip.RightToLeft = [System.Windows.Forms.RightToLeft]::No
#$FCGTopMenuStrip.ShowItemToolTips = $False
#$FCGTopMenuStrip.Size = [System.Drawing.Size]::New(200, 24)
#$FCGTopMenuStrip.Stretch = $True
#$FCGTopMenuStrip.TabIndex = 0
#$FCGTopMenuStrip.TabStop = $False
#$FCGTopMenuStrip.Tag = [System.Object]::New()
$FCGTopMenuStrip.Text = "FCGTopMenuStrip"
#$FCGTopMenuStrip.TextDirection = [System.Windows.Forms.ToolStripTextDirection]::Horizontal
#$FCGTopMenuStrip.Top = 0
#$FCGTopMenuStrip.UseWaitCursor = $False
#$FCGTopMenuStrip.Visible = $True
#$FCGTopMenuStrip.Width = 200
#endregion $FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()

#$FCGTopMenuStrip.Items.Add([System.String]$Text)
#$FCGTopMenuStrip.Items.Add([System.Drawing.Image]$Image)
#$FCGTopMenuStrip.Items.Add([System.String]$Text, [System.Drawing.Image]$Image)
#$FCGTopMenuStrip.Items.Add([System.String]$Text, [System.Drawing.Image]$Image, [System.EventHandler]$OnClick)
#$FCGTopMenuStrip.Items.Add([System.Windows.Forms.ToolStripItem]$Value)
#$FCGTopMenuStrip.Items.AddRange([System.Windows.Forms.ToolStripItem[]]$ToolStripItems)
#$FCGTopMenuStrip.Items.AddRange([System.Windows.Forms.ToolStripItemCollection]$ToolStripItems)
#$FCGTopMenuStrip.BeginUpdate()
#$FCGTopMenuStrip.EndUpdate()

$FCGTopMenuStripItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "FCG" -Name "FCG" -Tag "FCG" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru

#region ******** Function Start-FCGTopMenuStripItemClick ********
function Start-FCGTopMenuStripItemClick
{
  <#
    .SYNOPSIS
      Click Event for the FCGTop ToolStripItem Control
    .DESCRIPTION
      Click Event for the FCGTop ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-FCGTopMenuStripItemClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ToolStripItem]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Click Event for `$FCGTopMenuStripItem"

  [MyConfig]::AutoExit = 0

  Switch ($Sender.Name)
  {
    "Bug"
    {
      Show-MyWebReport -ReportURL ([MyConfig]::BugURL)
      Break
    }
    "Help"
    {
      Show-MyWebReport -ReportURL ([MyConfig]::HelpURL)
      Break
    }
    "Exit"
    {
      if ([MyConfig]::Production)
      {
        $FCGForm.Close()
      }
      else
      {
        # **** Testing - Exit to Nested Prompt ****
        Write-Host -Object "Line Num: $((Get-PSCallStack).ScriptLineNumber)"
        $Host.EnterNestedPrompt()
        # **** Testing - Exit to Nested Prompt ****
      }
      Break
    }
  }

  Write-Verbose -Message "Exit Click Event for `$FCGTopMenuStripItem"
}
#endregion ******** Function Start-FCGTopMenuStripItemClick ********

(New-MenuItem -Menu $FCGTopMenuStrip -Text "&Bug" -Name "Bug" -Tag "Bug" -DisplayStyle "ImageAndText" -ImageKey "BugIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGTopMenuStrip -Text "&Help" -Name "Help" -Tag "Help" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGTopMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

# Right Dropdown
#$DropDownMenu = New-MenuItem -Menu $FCGTopMenuStrip -Text "DropDown Menu" -Name "DropMenu" -Tag "DropMenu" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru
#$DropDownMenu.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
#$DropDownMenu.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No

# Sample Dialogs
#region ******** Function Start-FCGMySampleDialogsMenuStripItemClick ********
function Start-FCGMySampleDialogsMenuStripItemClick
{
  <#
    .SYNOPSIS
      Click Event for the FCGMySampleDialogs ToolStripItem Control
    .DESCRIPTION
      Click Event for the FCGMySampleDialogs ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-FCGMySampleDialogsMenuStripItemClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ToolStripItem]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Click Event for `$FCGMySampleDialogsMenuStripItem"

  [MyConfig]::AutoExit = 0

  Switch ($Sender.Name)
  {
    "Status01"
    {
      #region Show Status Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Status Dialog 01"
      $HashTable = @{"ShowHeader" = $True; "Name" = "Item Name"; "Value" = "Item Value"}
      $ScriptBlock = { [CmdletBinding()] param ([System.Windows.Forms.RichTextBox]$RichTextBox, [HashTable]$HashTable) Display-MyStatusRichTextBox -RichTextBox $RichTextBox -HashTable $HashTable }
      $CommandResult = Show-MyStatusDialog -ScriptBlock $ScriptBlock -DialogTitle "This is a Test Status 01" -ButtonMid "OK" -HashTable $HashTable
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Status Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult

        # Write KPI Event
        #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Successfull KPI Event"
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Status Dialog 01"

        # Write KPI Event
        #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Failed KPI Event"
      }
      #endregion Show Status Dialog 01
      Break
    }
    "Status02"
    {
      #region Show Status Dialog 02
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Status Dialog 02"
      $ScriptBlock = { [CmdletBinding()] param ([System.Windows.Forms.RichTextBox]$RichTextBox, [HashTable]$HashTable) Display-MyStatusRichTextBox -RichTextBox $RichTextBox }
      $CommandResult = Show-MyStatusDialog -ScriptBlock $ScriptBlock -DialogTitle "This is a Test Status 02" -ButtonMid "OK" -AllowControl
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Status Dialog 02"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult

        # Write KPI Event
        #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Successfull KPI Event"
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Status Dialog 02"

        # Write KPI Event
        #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Failed KPI Event"
      }
      #endregion Show Status Dialog 02
      Break
    }
    "UserAlert01"
    {
      #region Show User Alert 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show User Alert 01"
      # Write KPI Event
      #Write-KPIEvent -Source "Utility" -EntryType "Information" -EventID 0 -Category 0 -Message "Successfull KPI Event"
      Show-UserAlertDialog -Title "Message Alert Title" -Message "Display this Alert Message Text to the user." -MsgType "Info"
      # Success
      $FCGBtmStatusStrip.Items["Status"].Text = "Success Show User Alert 01"
      #endregion Show User Alert 01
      Break
    }
    "UserResponse01"
    {
      #region Show Get User Response 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Get User Response 01"
      $CommandResult = Show-GetUserResponseDialog -MessageText "This is the Sample Message I wish to Display." -ButtonLeft Yes -ButtonRight No -ButtonDefault Yes
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Get User Response 01 - $($CommandResult.DialogResult)"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Get User Response 01 - $($CommandResult.DialogResult)"
      }
      #endregion Show Get User Response 01
      Break
    }
    "UserText01"
    {
      #region Show User Text Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show User Text Dialog 01"
      $CommandResult = Show-GetUserTextDialog -DialogTitle "This is User Text 01" -MessageText "Show this Message Prompt" -Items "Sample Text"
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success User Text Dialog 01 - $($CommandResult.Items[0])"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Items
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed User Text Dialog 01"
      }
      #endregion Show User Text Dialog 02
      Break
    }
    "UserText02"
    {
      #region Show User Text Dialog 02
      $FCGBtmStatusStrip.Items["Status"].Text = "Show User Text Dialog 02"
      $CommandResult = Show-GetUserTextDialog -DialogTitle "This is User Text 02" -MessageText "Show this Message Prompt" -Items @("Computer01", "Computer02", "Computer03") -Height 20 -Multi
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success User Text Dialog 02 - $($CommandResult.Items.Count) Items"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Items
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed User Text Dialog 02"
      }
      #endregion Show User Text Dialog 02
      Break
    }
    "MultiValue01"
    {
      #region Show Multi Value Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Multi Value Dialog 01"
      $OrderedItems = [Ordered]@{ "FirstName" = "John"; "LastName" = "Doe"; "Height" = "5' 11''"; "Weight" = "180 Lbs"}
      $CommandResult = Show-GetMultiValueDialog -DialogTitle "Multi Value Dialog 01" -MessageText "Show this Message Prompt" -OrderedItems $OrderedItems
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Multi Value Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.OrderedItems
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Multi Value Dialog 01"
      }
      #endregion Show Multi Value Dialog 01
      Break
    }
    "RadioChoice01"
    {
      #region Show Radio Choice Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Radio Choice Dialog 01"
      $OrderedItems = [Ordered]@{ "First Choice in the List." = "1"; "Pick this Item!" = "2"; "No, Pick this one!!" = "3"; "Never Pick this Option." = "4"}
      $CommandResult = Show-GetRadioChoiceDialog -DialogTitle "Radio Choice Dialog 01" -MessageText "Show this Message Prompt" -OrderedItems $OrderedItems -Selected $OrderedItems["Never Pick this Option."]
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Radio Choice Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Item
        # $CommandResult.Object
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Radio Choice Dialog 01"
      }
      #endregion Show Radio Choice Dialog 01
      Break
    }
    "ListViewChoice01"
    {
      #region Show ListView Choice Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show ListView Choice Dialog 01"
      $Functions = @(Get-ChildItem -Path "Function:\")
      $CommandResult = Show-GetListViewChoiceDialog -DialogTitle "ListView Choice Dialog 01" -MessageText "Show this Message Prompt" -List $Functions -Property "Name", "Version", "Source" -Selected ($Functions[2]) -Tooltip "Name"
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success ListView Choice Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Item
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed ListView Choice Dialog 01"
      }
      #endregion Show ListView Choice Dialog 01
      Break
    }
    "ListViewChoice02"
    {
      #region Show ListView Choice Dialog 02
      $FCGBtmStatusStrip.Items["Status"].Text = "Show ListView Choice Dialog 02"
      $Functions = @(Get-ChildItem -Path "Function:\")
      $CommandResult = Show-GetListViewChoiceDialog -DialogTitle "ListView Choice Dialog 01" -MessageText "Show this Message Prompt" -List $Functions -Property "Name", "Version", "Source" -Multi -Selected ($Functions[3..5])
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success ListView Choice Dialog 02"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Item
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed ListView Choice Dialog 02"
      }
      #endregion Show ListView Choice Dialog 02
      Break
    }
    "ComboChoice01"
    {
      #region Show Combo Choice Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Combo Choice Dialog 01"
      $Variables = @(Get-ChildItem -Path "Variable:\")
      $CommandResult = Show-GetComboChoiceDialog -DialogTitle "Combo Choice Dialog 01" -MessageText "Show this Message Prompt" -Items $Variables -DisplayMember "Name" -ValueMember "Value" -Selected ($Variables[4])
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Combo Choice Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Item
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Combo Choice Dialog 01"
      }
      #endregion Show Combo Choice Dialog 01
      Break
    }
    "ComboFilter01"
    {
      #region Show Combo Filter Dialog 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show Combo Filter Dialog 01"
      $ServiceList = @(Get-Service | Select-Object -Property Status, Name, StartType)
      $CommandResult = Show-GetComboFilterDialog -DialogTitle "Combo Filter Dialog 01" -MessageText "Show this Message Prompt" -Items $ServiceList -Properties Status, Name, StartType
      If ($CommandResult.Success)
      {
        # Success
        $FCGBtmStatusStrip.Items["Status"].Text = "Success Combo Filter Dialog 01"
        Write-Host -Object ($CommandResult | Format-List -Property * | Out-String)
        # $CommandResult.Success
        # $CommandResult.DialogResult
        # $CommandResult.Values
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Combo Filter Dialog 01"
      }
      #endregion Show Combo Filter Dialog 01
      Break
    }
  }

  Write-Verbose -Message "Exit Click Event for `$FCGMySampleDialogsMenuStripItem"
}
#endregion ******** Function Start-FCGMySampleDialogsMenuStripItemClick ********

(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Status Dialog - 01" -Name "Status01" -Tag "Status01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Status Dialog - 02" -Name "Status02" -Tag "Status02" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "User Alert Dialog - 01" -Name "UserAlert01" -Tag "UserAlert01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "User Response Dialog - 01" -Name "UserResponse01" -Tag "UserResponse01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "User Text Dialog - 01" -Name "UserText01" -Tag "UserText01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "User Text Dialog - 02" -Name "UserText02" -Tag "UserText01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Multi Value Dialog - 01" -Name "MultiValue01" -Tag "MultiValue01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Radio Choice Dialog - 01" -Name "RadioChoice01" -Tag "RadioChoice01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "ListView Choice Dialog - 01" -Name "ListViewChoice01" -Tag "ListViewChoice01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "ListView Choice Dialog - 02" -Name "ListViewChoice02" -Tag "ListViewChoice02" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Combo Choice Dialog - 01" -Name "ComboChoice01" -Tag "ComboChoice01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })
(New-MenuItem -Menu $FCGTopMenuStripItem -Text "Combo Filter Dialog - 01" -Name "ComboFilter01" -Tag "ComboFilter01" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({ Start-FCGMySampleDialogsMenuStripItemClick -Sender $This -EventArg $PSItem })

# ************************************************
# FCGBtm StatusStrip
# ************************************************
#region $FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
$FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
$FCGForm.Controls.Add($FCGBtmStatusStrip)
#$FCGForm.StatusStrip = $FCGBtmStatusStrip
#$FCGBtmStatusStrip.AllowDrop = $False
#$FCGBtmStatusStrip.AllowItemReorder = $False
#$FCGBtmStatusStrip.AllowMerge = $True
#$FCGBtmStatusStrip.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left")
#$FCGBtmStatusStrip.AutoScroll = $False
#$FCGBtmStatusStrip.AutoScrollMargin = [System.Drawing.Size]::New(0, 0)
#$FCGBtmStatusStrip.AutoScrollMinSize = [System.Drawing.Size]::New(0, 0)
#$FCGBtmStatusStrip.AutoScrollOffset = [System.Drawing.Point]::New(0, 0)
#$FCGBtmStatusStrip.AutoScrollPosition = [System.Drawing.Point]::New(0, 0)
#$FCGBtmStatusStrip.AutoSize = $True
$FCGBtmStatusStrip.BackColor = [MyConfig]::Colors.Back
#$FCGBtmStatusStrip.BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($ImageString)))
#$FCGBtmStatusStrip.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
#$FCGBtmStatusStrip.BindingContext = [System.Windows.Forms.BindingContext]::New()
#$FCGBtmStatusStrip.Bounds = [System.Drawing.Rectangle]::New(0, 0, 200, 22)
#$FCGBtmStatusStrip.CanOverflow = $False
#$FCGBtmStatusStrip.Capture = $False
#$FCGBtmStatusStrip.CausesValidation = $False
#$FCGBtmStatusStrip.ClientSize = [System.Drawing.Size]::New(200, 22)
#$FCGBtmStatusStrip.ContextMenu = [System.Windows.Forms.ContextMenu]::New()
#$FCGBtmStatusStrip.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGBtmStatusStrip.Cursor = [System.Windows.Forms.Cursors]::Default
#$FCGBtmStatusStrip.DefaultDropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::AboveRight
#$FCGBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
#$FCGBtmStatusStrip.Enabled = $True
$FCGBtmStatusStrip.Font = [MyConfig]::Font.Regular
$FCGBtmStatusStrip.ForeColor = [MyConfig]::Colors.Fore
#$FCGBtmStatusStrip.GripMargin = [System.Windows.Forms.Padding]::New(2, 2, 2, 2)
#$FCGBtmStatusStrip.GripStyle = [System.Windows.Forms.ToolStripGripStyle]::Hidden
#$FCGBtmStatusStrip.Height = 22
$FCGBtmStatusStrip.ImageList = $FCGImageList
#$FCGBtmStatusStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
#$FCGBtmStatusStrip.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
#$FCGBtmStatusStrip.IsAccessible = $False
#$FCGBtmStatusStrip.LayoutSettings = [System.Windows.Forms.LayoutSettings]::New()
#$FCGBtmStatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::Table
#$FCGBtmStatusStrip.Left = 0
#$FCGBtmStatusStrip.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
#$FCGBtmStatusStrip.Margin = [System.Windows.Forms.Padding]::New(0, 0, 0, 0)
#$FCGBtmStatusStrip.MaximumSize = [System.Drawing.Size]::New(0, 0)
#$FCGBtmStatusStrip.MinimumSize = [System.Drawing.Size]::New(0, 0)
$FCGBtmStatusStrip.Name = "FCGBtmStatusStrip"
#$FCGBtmStatusStrip.Padding = [System.Windows.Forms.Padding]::New(1, 0, 14, 0)
#$FCGBtmStatusStrip.Parent = [System.Windows.Forms.Control]::New()
#$FCGBtmStatusStrip.Region = [System.Drawing.Region]::New()
#$FCGBtmStatusStrip.Renderer = [System.Windows.Forms.ToolStripRenderer]::New()
#$FCGBtmStatusStrip.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::System
#$FCGBtmStatusStrip.RightToLeft = [System.Windows.Forms.RightToLeft]::No
#$FCGBtmStatusStrip.ShowItemToolTips = $False
#$FCGBtmStatusStrip.Size = [System.Drawing.Size]::New(200, 22)
#$FCGBtmStatusStrip.SizingGrip = $True
#$FCGBtmStatusStrip.Stretch = $True
#$FCGBtmStatusStrip.TabIndex = 0
#$FCGBtmStatusStrip.TabStop = $False
#$FCGBtmStatusStrip.Tag = [System.Object]::New()
$FCGBtmStatusStrip.Text = "FCGBtmStatusStrip"
#$FCGBtmStatusStrip.TextDirection = [System.Windows.Forms.ToolStripTextDirection]::Horizontal
#$FCGBtmStatusStrip.Top = 0
#$FCGBtmStatusStrip.UseWaitCursor = $False
#$FCGBtmStatusStrip.Visible = $True
#$FCGBtmStatusStrip.Width = 200
#endregion $FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()

#$FCGBtmStatusStrip.Items.Add([System.String]$Text)
#$FCGBtmStatusStrip.Items.Add([System.Drawing.Image]$Image)
#$FCGBtmStatusStrip.Items.Add([System.String]$Text, [System.Drawing.Image]$Image)
#$FCGBtmStatusStrip.Items.Add([System.String]$Text, [System.Drawing.Image]$Image, [System.EventHandler]$OnClick)
#$FCGBtmStatusStrip.Items.Add([System.Windows.Forms.ToolStripItem]$Value)
#$FCGBtmStatusStrip.Items.AddRange([System.Windows.Forms.ToolStripItem[]]$ToolStripItems)
#$FCGBtmStatusStrip.Items.AddRange([System.Windows.Forms.ToolStripItemCollection]$ToolStripItems)
#$FCGBtmStatusStrip.BeginUpdate()
#$FCGBtmStatusStrip.EndUpdate()

New-MenuLabel -Menu $FCGBtmStatusStrip -Text "Status" -Name "Status" -Tag "Status"

#$FCGForm.ClientSize = [System.Drawing.Size]::New(($FCGForm.Controls[$FCGForm.Controls.Count - 1]).Right + [MyConfig]::FormSpacer, ($FCGForm.Controls[$FCGForm.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))

#endregion ******** Controls for FCG Form ********

#endregion ================ End **** FCG **** End ================

#region ******** Start Form  ********
# *********************
# Add Form Code here...
# *********************
[System.Console]::Title = "RUNNING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
if ([MyConfig]::Production)
{
  [Void][Console.Window]::Hide()
}

Try
{
  [System.Windows.Forms.Application]::Run($FCGForm)
}
Catch
{
  if (-not [MyConfig]::Production)
  {
    # **** Testing - Exit to Nested Prompt ****
    Write-Host -Object "Line Num: $((Get-PSCallStack).ScriptLineNumber)"
    #$Host.EnterNestedPrompt()
    # **** Testing - Exit to Nested Prompt ****
  }
}

$FCGOpenFileDialog.Dispose()
$FCGSaveFileDialog.Dispose()
$FCGFolderBrowserDialog.Dispose()
$FCGFormComponents.Dispose()
$FCGForm.Dispose()
# *********************
# Add Form Code here...
# *********************

#endregion ******** Start Form  ********

#region ******** Azure Logon and Start Form  ********

# Set Defaut Screen Colors
[Console]::ForegroundColor = "Gray"
[Console]::BackgroundColor = "Black"
[Console]::Clear()

# Set Default Flag / Check Values
$ChkUser = $True
$RunMe = $True

# Import / Install Required Azure Modules
Write-Host -Object ("-" * 32) -ForegroundColor DarkGray
Write-Host -Object "Importing Required Azure Modules" -ForegroundColor DarkRed
Write-Host -Object ("-" * 32) -ForegroundColor DarkGray
# Process Required Modules
:ModInstall foreach ($Key in [MyConfig]::RequiredModules.Keys)
{
  # Module Info / Status
  Write-Host -Object "Module: " -ForegroundColor Gray -NoNewline
  Write-Host -Object $Key -ForegroundColor Cyan -NoNewline
  Write-Host -Object " Version: " -ForegroundColor Gray -NoNewline
  Write-Host -Object ([MyConfig]::RequiredModules[$Key]) -ForegroundColor Cyan
  Write-Host -Object "Status: " -ForegroundColor Gray -NoNewline
  # Check if Module is Installed
  if ((Install-MyModule -Name $Key -Version ([MyConfig]::RequiredModules[$Key])).Success)
  {
    Write-Host -Object "Imported" -ForegroundColor DarkGreen
  }
  else
  {
    # Check for Admion Rights
    if ([MyConfig]::IsLocalAdmin)
    {
      # Insatll Module for All Users
      if ((Install-MyModule -Name $Key -Version ([MyConfig]::RequiredModules[$Key]) -Install).Success)
      {
        # Instalation Suceeded
        Write-Host -Object "Installed" -ForegroundColor DarkGreen
      }
      else
      {
        # Installation Failed
        Write-Host -Object "Failed" -ForegroundColor DarkRed
        break ModInstall
        $RunMe = $False
      }
    }
    else
    {
      if ($ChkUser)
      {
        # Ask user to Install in User Profile
        Write-Host -Object "Prompt User" -ForegroundColor DarkYellow
        [Console]::ForegroundColor = "Green"
        $Choice = $Host.UI.PromptForChoice("Install Azure Module", "Install the Azure Module to your user profile?", ([System.Management.Automation.Host.ChoiceDescription[]]("&Yes", "&No")), 1)
        [Console]::ForegroundColor = "Gray"
        if ($Choice -eq 1)
        {
          # User Said No
          $RunMe = $False
          break ModInstall
        }
        else
        {
          # User Said Yes
          Write-Host
          Write-Host -Object "Module: " -ForegroundColor Gray -NoNewline
          Write-Host -Object $Key -ForegroundColor Cyan -NoNewline
          Write-Host -Object " Version: " -ForegroundColor Gray -NoNewline
          Write-Host -Object ([MyConfig]::RequiredModules[$Key]) -ForegroundColor Cyan
          Write-Host -Object "Status: " -ForegroundColor Gray -NoNewline
          $ChkUser = $False
        }
      }
      
      # Install Module as the Current User
      if ((Install-MyModule -Scope CurrentUser -Name $Key -Version ([MyConfig]::RequiredModules[$Key]) -Install).Success)
      {
        # Instalation Suceeded
        Write-Host -Object "Installed" -ForegroundColor DarkGreen
      }
      else
      {
        # Instalation Failed
        Write-Host -Object "Failed" -ForegroundColor DarkRed
        break ModInstall
        $RunMe = $False
      }
    }
  }
}

if ($RunMe)
{
  # Login to Azure
  Write-Host
  Write-Host -Object ("-" * 19) -ForegroundColor DarkGray
  Write-Host -Object "Azure / Entre Login" -ForegroundColor DarkRed
  Write-Host -Object ("-" * 19) -ForegroundColor DarkGray
  Write-Host -Object "Logon to Azure: " -ForegroundColor Gray -NoNewLine
  Update-AzConfig -EnableLoginByWam $False -DisplayBreakingChangeWarning $False -WarningAction SilentlyContinue | Out-Null
  #[MyConfig]::AADLogonInfo = Connect-AzAccount -Tenant ([MyConfig]::TenantID) -SubscriptionID ([MyConfig]::SubscriptionID) -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
  [MyConfig]::AADLogonInfo = Connect-AzAccount -ServicePrincipal -Tenant ([MyConfig]::TenantID) -Credential ([PSCredential]::New([MyConfig]::ApplicationID, (ConvertTo-SecureString -AsPlainText -Force -String (Encrypt-WithCert -Decrypt -Universal -Salt 2 -CertKey ([MyConfig]::CertKey) -TextString ([MyConfig]::SecretCode))))) -ErrorAction SilentlyContinue
  if ([String]::IsNullOrEmpty([MyConfig]::AADLogonInfo))
  {
    # Azure Login Failed
    Write-Host -Object "Failed" -ForegroundColor DarkRed
  }
  else
  {
    # Azure Login Succeeded
    Write-Host -Object "Success" -ForegroundColor DarkGreen
    
    # Update Console
    [System.Console]::Title = "RUNNING: $([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
    if ([MyConfig]::Production)
    {
      [Void][Console.Window]::Hide()
    }
    
    # Launch / Run Script
    [System.Windows.Forms.Application]::Run($IDPForm)
    
    # Close / Dispose of Form Objects
    $IDPOpenFileDialog.Dispose()
    $IDPSaveFileDialog.Dispose()
    $IDPFormComponents.Dispose()
    $IDPForm.Dispose()
  }
}
else
{
  if (-not [MyConfig]::Production)
  {
    # Exit to Nested Prompt - Testing Only
    Write-Host -Object "Exit Line Num: $((Get-PSCallStack).ScriptLineNumber)"
    $Host.EnterNestedPrompt()
  }
}

#endregion ******** Azure Logon and Start Form  ********


if ([MyConfig]::Production)
{
  [System.Environment]::Exit(0)
}
