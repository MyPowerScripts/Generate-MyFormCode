# ----------------------------------------------------------------------------------------------------------------------
#
#  Script: FCG
# Version: 7.0.0.0
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
Using namespace System.Collections.Specialized

<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER <Parameter-Name>
  .EXAMPLE
  .NOTES
    My Script FCG Version 1.0 by kensw on 08/03/2024
    Created with "My PS5 Form Code Generator" Version 6.1.3.1
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

  static [String]$ScriptName = "Generate My Form Code"
  static [Version]$ScriptVersion = [Version]::New("7.0.0.0")
  static [String]$ScriptAuthor = "Ken Sweet"

  # Script Configuration
  static [String]$ScriptRoot = ""
  static [String]$ConfigFile = ""
  static [PSCustomObject]$ConfigData = [PSCustomObject]@{ }

  # Script Runtime Values
  static [Bool]$Is64Bit = ([IntPtr]::Size -eq 8)

  # Default Form Settings
  static [Int]$FormSpacer = 4
  Static [int]$FormMinWidth = 75
  Static [int]$PanMinWidth = 25
  static [int]$FormMinHeight = 40

  # Default Font
  static [String]$FontFamily = "Verdana"
  static [Single]$FontSize = 10
  static [Single]$FontTitle = 1.5

  # Azure Module Logon Information
  static [String]$AZModuleName = "Az.Accounts"
  static [String]$AZModuleVersion = "2.19.0"

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
  [MyConfig]::Colors.Add("Fore", ([System.Drawing.Color]::LightCoral))
  #[MyConfig]::Colors.Add("Fore", ([System.Drawing.Color]::DodgerBlue))
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
  static [HashTable]$Favorites = [HashTable]::New()
}

#region CopyMe
$MyData = @{
  "Properties" = @()
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("CopyMe", $MyData)

#$Properties = @()
#$Events = @()
#[MyRuntime]::Favorites.Add("CopyMe", [MyFavorite]::new("CopyMe", $Properties, $Events))


#endregion CopyMe

#region Button
$MyData = @{
  "Properties" = @()
  "Events"     = @("Click")
}
[MyRuntime]::Favorites.Add("Button", $MyData)
#endregion Button

#region CheckBox
$MyData = @{
  "Properties" = @()
  "Events"     = @("CheckedChanged")
}
[MyRuntime]::Favorites.Add("CheckBox", $MyData)
#endregion CheckBox

#region CheckedListBox - Done
$MyData = @{
  "Properties" = @("Anchor", "BackColor", "BorderStyle", "CheckOnClick", "ColumnWidth", "ContextMenuStrip", "DataSource", "DisplayMember", "Dock", "Enabled", "Font", "ForeColor", "FormatString", "FormattingEnabled", "Height", "HorizontalScrollbar", "IntegralHeight", "ItemHeight", "Location", "MultiColumn", "Name", "ScrollAlwaysVisible", "SelectedIndex", "SelectedItem", "SelectedValue", "SelectionMode", "Size", "Sorted", "TabIndex", "TabStop", "Tag", "ThreeDCheckBoxes", "TopIndex", "ValueMember", "Visible", "Width")
  "Events"     = @("ItemCheck", "MouseDown", "SelectedIndexChanged")
}
[MyRuntime]::Favorites.Add("CheckedListBox", $MyData)
#endregion CheckedListBox

#region ComboBox
$MyData = @{
  "Properties" = @()
  "Events"     = @("SelectedIndexChanged")
}
[MyRuntime]::Favorites.Add("ComboBox", $MyData)
#endregion ComboBox

#region ContextMenuStrip - Done
$MyData = @{
  "Properties" = @("BackColor", "DefaultDropDownDirection", "DropShadowEnabled", "Enabled", "Font", "ForeColor", "GripMargin", "GripStyle", "ImageList", "ImageScalingSize", "Name", "Opacity", "RightToLeft", "ShowCheckMargin", "ShowImageMargin", "ShowItemToolTips", "Tag", "Text", "TextDirection", "Visible")
  "Events"     = @("Opening")
}
[MyRuntime]::Favorites.Add("ContextMenuStrip", $MyData)
#endregion ContextMenuStrip

#region Form - Done
$MyData = @{
  "Properties" = @("BackColor", "CancelButton", "ContextMenuStrip", "ControlBox", "DialogResult", "Dock", "Enabled", "Font", "ForeColor", "FormBorderStyle", "Icon", "IsMdiContainer", "KeyPreview", "MainMenuStrip", "MaximizeBox", "MaximumSize", "MdiParent", "MinimizeBox", "MinimumSize", "Name", "Opacity", "Owner", "ShowIcon", "ShowInTaskbar", "Size", "SizeGripStyle", "StartPosition", "TabIndex", "TabStop", "Tag", "Text", "TopLevel", "TopMost", "Visible", "Width", "WindowState")
  "Events"     = @("Closing", "KeyDown", "Load", "Move", "Resize", "Shown")
}
[MyRuntime]::Favorites.Add("Form", $MyData)
#endregion Form

#region GroupBox - Done
$MyData = @{
  "Properties" = @("Anchor", "BackColor", "Dock", "Enabled", "Font", "ForeColor", "Height", "Name", "Size", "TabIndex", "TabStop", "Tag", "Text", "Visible", "Width")
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("GroupBox", $MyData)
#endregion GroupBox

#region ImageList - Done
$MyData = @{
  "Properties" = @("ColorDepth", "ImageSize", "Tag")
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("ImageList", $MyData)
#endregion ImageList

#region ListBox - Done
$MyData = @{
  "Properties" = @("Anchor", "BackColor", "BorderStyle", "ColumnWidth", "ContextMenuStrip", "DataSource", "DisplayMember", "Dock", "Enabled", "Font", "ForeColor", "FormatString", "FormattingEnabled", "Height", "HorizontalScrollbar", "IntegralHeight", "ItemHeight", "Location", "MultiColumn", "Name", "ScrollAlwaysVisible", "SelectedIndex", "SelectedItem", "SelectedValue", "SelectionMode", "Size", "Sorted", "TabIndex", "TabStop", "Tag", "TopIndex", "ValueMember", "Visible", "Width")
  "Events"     = @("MouseDown", "SelectedIndexChanged")
}
[MyRuntime]::Favorites.Add("ListBox", $MyData)
#endregion ListBox

#region ListView
$MyData = @{
  "Properties" = @()
  "Events"     = @("ColumnClick")
}
[MyRuntime]::Favorites.Add("ListView", $MyData)
#endregion ListView

#region MenuStrip - Done
$MyData = @{
  "Properties" = @("BackColor", "DefaultDropDownDirection", "Dock", "Enabled", "Font", "ForeColor", "GripStyle", "ImageList", "ImageScalingSize", "LayoutStyle", "Name", "RightToLeft", "ShowItemToolTips", "TabIndex", "TabStop", "Tag", "TextDirection", "Visible")
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("MenuStrip", $MyData)
#endregion MenuStrip

#region NotifyIcon
$MyData = @{
  "Properties" = @()
  "Events"     = @("MouseClick")
}
[MyRuntime]::Favorites.Add("NotifyIcon", $MyData)
#endregion NotifyIcon

#region PictureBox - Done
$MyData = @{
  "Properties" = @("Anchor", "AutoSize", "BackColor", "BorderStyle", "ContextMenuStrip", "Dock", "Enabled", "Height", "Image", "InitialImage", "Location", "Name", "Size", "SizeMode", "TabIndex", "TabStop", "Tag", "Visible", "Width")
  "Events"     = @("DoubleClick", "MouseDown")
}
[MyRuntime]::Favorites.Add("PictureBox", $MyData)
#endregion PictureBox

#region RadioButton
$MyData = @{
  "Properties" = @()
  "Events"     = @("CheckedChanged")
}
[MyRuntime]::Favorites.Add("RadioButton", $MyData)
#endregion RadioButton

#region SplitContainer - Done
$MyData = @{
  "Properties" = @("Anchor", "BackColor", "BorderStyle", "Dock", "Enabled", "FixedPanel", "Font", "ForeColor", "IsSplitterFixed", "Location", "Name", "Orientation", "Panel1Collapsed", "Panel1MinSize", "Panel2Collapsed", "Panel2MinSize", "Size", "SplitterDistance", "SplitterIncrement", "SplitterWidth", "TabIndex", "TabStop", "Tag", "Visible", "Width")
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("SplitContainer", $MyData)
#endregion SplitContainer

#region StatusStrip - Done
$MyData = @{
  "Properties" = @("BackColor", "DefaultDropDownDirection", "Dock", "Enabled", "Font", "ForeColor", "GripStyle", "ImageList", "ImageScalingSize", "LayoutStyle", "Name", "RightToLeft", "ShowItemToolTips", "SizingGrip", "TabIndex", "TabStop", "Tag", "TextDirection", "Visible")
  "Events"     = @()
}
[MyRuntime]::Favorites.Add("StatusStrip", $MyData)
#endregion StatusStrip

#region TextBox - Done
$MyData = @{
  "Properties" = @("AcceptsReturn", "AcceptsTab", "Anchor", "AutoSize", "BackColor", "BorderStyle", "ContextMenuStrip", "Cursor", "Dock", "Enabled", "Font", "ForeColor", "Height", "HideSelection", "Left", "Lines", "Location", "Margin", "MaxLength", "Modified", "Multiline", "Name", "PasswordChar", "ReadOnly", "ScrollBars", "SelectedText", "SelectionLength", "SelectionStart", "ShortcutsEnabled", "Size", "TabIndex", "TabStop", "Tag", "Text", "TextAlign", "Top", "UseSystemPasswordChar", "Visible", "Width", "WordWrap")
  "Events"     = @("GotFocus", "KeyDown", "KeyPress", "KeyUp", "LostFocus")
}
[MyRuntime]::Favorites.Add("TextBox", $MyData)
#endregion TextBox

#region Timer - Dones
$MyData = @{
  "Properties" = @("Enabled", "Interval", "Tag")
  "Events"     = @("Tick")
}
[MyRuntime]::Favorites.Add("Timer", $MyData)
#endregion Timer

#region TreeView
$MyData = @{
  "Properties" = @()
  "Events"     = @("AfterSelect", "BeforeExpand")
}
[MyRuntime]::Favorites.Add("TreeView", $MyData)
#endregion TreeView

#region WebBrowser
$MyData = @{
  "Properties" = @()
  "Events"     = @("NewWindow", "StatusTextChanged")
}
[MyRuntime]::Favorites.Add("WebBrowser", $MyData)
#endregion WebBrowser

#endregion ================ FCG Runtime  Values ================

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

#region ******** MyListItem Class ********
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
#endregion ******** MyListItem Class ********

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

#endregion ================ My Custom Class ================

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
if ([MyConfig]::Production)
{
  [Void][Console.Window]::Hide()
}

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
Add-Type -TypeDefinition $MyCode -ReferencedAssemblies System.Drawing -Debug:$False
#endregion ******** [Extract.MyIcon] ********

#endregion ================ Windows APIs ================

#region >>>>>>>>>>>>>>>> My Custom Functions <<<<<<<<<<<<<<<<

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
Function New-MenuItem()
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
  Param (
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
  
  If ($Menu.GetType().Name -eq "ToolStripMenuItem")
  {
    [Void]$Menu.DropDownItems.Add($TempMenuItem)
    If ($Menu.DropDown.Items.Count -eq 1)
    {
      $Menu.DropDown.BackColor = $Menu.BackColor
      $Menu.DropDown.ForeColor = $Menu.ForeColor
      $Menu.DropDown.ImageList = $Menu.Owner.ImageList
    }
  }
  Else
  {
    [Void]$Menu.Items.Add($TempMenuItem)
  }
  
  If ($PSBoundParameters.ContainsKey("Name"))
  {
    $TempMenuItem.Name = $Name
  }
  Else
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
  
  If ($PSBoundParameters.ContainsKey("BackColor"))
  {
    $TempMenuItem.BackColor = $BackColor
  }
  $TempMenuItem.ForeColor = $ForeColor
  $TempMenuItem.Font = $Font
  
  If ($PSCmdlet.ParameterSetName -eq "Default")
  {
    $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
  }
  Else
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
Function New-MenuLabel()
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
  Param (
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
  
  If ($Menu.GetType().Name -eq "ToolStripMenuItem")
  {
    [Void]$Menu.DropDownItems.Add($TempMenuLabel)
  }
  Else
  {
    [Void]$Menu.Items.Add($TempMenuLabel)
  }
  
  If ($PSBoundParameters.ContainsKey("Name"))
  {
    $TempMenuLabel.Name = $Name
  }
  Else
  {
    $TempMenuLabel.Name = $Text
  }
  
  $TempMenuLabel.TextAlign = $Alignment
  $TempMenuLabel.Tag = $Tag
  $TempMenuLabel.ToolTipText = $ToolTip
  $TempMenuLabel.DisplayStyle = $DisplayStyle
  $TempMenuLabel.Enabled = (-not $Disable.IsPresent)
  
  If ($PSBoundParameters.ContainsKey("BackColor"))
  {
    $TempMenuLabel.BackColor = $BackColor
  }
  $TempMenuLabel.ForeColor = $ForeColor
  $TempMenuLabel.Font = $Font
  
  If ($PSBoundParameters.ContainsKey("Icon"))
  {
    $TempMenuLabel.Image = $Icon
    $TempMenuLabel.ImageAlign = $Alignment
    $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
  }
  Else
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
    .PARAMETER PassPhrase
    .PARAMETER Salt
    .PARAMETER HashAlgorithm
    .PARAMETER CipherMode
    .PARAMETER PaddingMode
    .PARAMETER Decrypt
    .EXAMPLE
      $EncryptedData = Encrypt-MySensitiveData -String $String -PassPhrase $PassPhrase -Salt $Pepper
    .EXAMPLE
      $DecryptedData = Encrypt-MySensitiveData -String $String -PassPhrase $PassPhrase -Salt $Pepper -Decrypt
    .NOTES
      Original Script By Kenneth D. Sweet

      2022-08-23 - 1.0 - Initial Release
    .LINK
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
  Write-Verbose -Message "Enter Function Encrypt-MySensitiveData"

  $Aes = [System.Security.Cryptography.Aes]::Create()
  $Aes.Mode = $CipherMode
  $Aes.Padding = $PaddingMode
  $SaltBytes = [System.Text.Encoding]::UTF8.GetBytes($Salt.PadRight(8, "*"))
  $Aes.Key = [System.Security.Cryptography.Rfc2898DeriveBytes]::New($PassPhrase, $SaltBytes, 8, $HashAlgorithm).GetBytes($Aes.Key.Length)

  if ($Decrypt.IsPresent)
  {
    $DecodeBytes = [System.Convert]::FromBase64String($String)
    $Aes.IV = $DecodeBytes[0..15]
    $Decryptor = $Aes.CreateDecryptor()
    [System.Text.Encoding]::UTF8.GetString(($Decryptor.TransformFinalBlock($DecodeBytes, 16, ($DecodeBytes.Length - 16))))
  }
  else
  {
    $EncodeBytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    $Encryptor = $Aes.CreateEncryptor()
    $EncryptedBytes = [System.Collections.ArrayList]::New($Aes.IV)
    $EncryptedBytes.AddRange($Encryptor.TransformFinalBlock($EncodeBytes, 0, $EncodeBytes.Length))
    [System.Convert]::ToBase64String($EncryptedBytes)
    $EncryptedBytes.Clear()
  }

  $Aes.Dispose()

  Write-Verbose -Message "Exit Function Encrypt-MySensitiveData"
}
#endregion Function Encrypt-MySensitiveData

#endregion ******* Encrypt / Encode Data Functions ********

#region ******* Generic / General Functions ********

#region function Set-MyClipboard
function Set-MyClipboard()
{
  <#
    .SYNOPSIS
      Copies Object Data to the ClipBoard
    .DESCRIPTION
      Copies Object Data to the ClipBoard
    .PARAMETER MyData
    .PARAMETER Title
    .PARAMETER TitleColor
    .PARAMETER Columns
    .PARAMETER ColumnColor
    .PARAMETER RowEven
    .PARAMETER RowOdd
    .PARAMETER OfficeFix
    .PARAMETER PassThru
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title"
    .EXAMPLE
      $MyData | Set-MyClipBoard -Title "This is My Title"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Property "Property1", "Property2", "Property3"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Columns ([Ordered@{"Property1" = "Left"; "Property2" = "Right"; "Property3" = "Center"})
    .NOTES
      Original Function By Ken Sweet
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True, ValueFromPipeline = $True)]
    [Object[]]$MyData,
    [String]$Title,
    [String]$TitleColor = "DodgerBlue",
    [parameter(Mandatory = $True, ParameterSetName = "Columns")]
    [System.Collections.Specialized.OrderedDictionary]$Columns,
    [parameter(Mandatory = $True, ParameterSetName = "Names")]
    [String[]]$Property,
    [String]$ColumnColor = "SkyBlue",
    [String]$RowEven = "White",
    [String]$RowOdd = "Gainsboro",
    [Switch]$OfficeFix,
    [Switch]$PassThru
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Begin Block"

    $HTMLStringBuilder = [System.Text.StringBuilder]::New()

    [Void]$HTMLStringBuilder.Append("Version:1.0`r`nStartHTML:000START`r`nEndHTML:00000END`r`nStartFragment:00FSTART`r`nEndFragment:0000FEND`r`n")
    [Void]$HTMLStringBuilder.Replace("000START", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<html><head><style>`r`nth { text-align: center; color: black; font: bold; background:$ColumnColor; }`r`ntd:nth-child(1) { text-align:right; }`r`ntable, th, td { border: 1px solid black; border-collapse: collapse; }`r`ntr:nth-child(odd) {background: $RowEven;}`r`ntr:nth-child($RowOdd) {background: gainsboro;}`r`n</style><title>$Title</title></head><body><!--StartFragment-->")
    [Void]$HTMLStringBuilder.Replace("00FSTART", ("{0:X8}" -f $HTMLStringBuilder.Length))

    $ObjectList = [System.Collections.ArrayList]::New()

    $GetColumns = $True

    Write-Verbose -Message "Exit Function Set-MyClipboard Begin Block"
  }
  Process
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Process Block"

    if ($GetColumns)
    {
      $Cols = [Ordered]@{ }
      Switch ($PSCmdlet.ParameterSetName)
      {
        "Columns"
        {
          $Cols = $Columns
          Break
        }
        "Names"
        {
          $Property | ForEach-Object -Process { $Cols.Add($PSItem, "Left") }
          Break
        }
        Default
        {
          $MyData[0].PSObject.Properties | Where-Object -FilterScript { $PSItem.MemberType -match "Property|NoteProperty" } | ForEach-Object -Process { $Cols.Add($PSItem.Name, "Left") }
          Break
        }
      }
      $ColNames = @($Cols.Keys)
      $GetColumns = $False
    }

    $ObjectList.AddRange(@($MyData | Select-Object -Property $ColNames))

    if ($PassThru.IsPresent)
    {
      $MyData
    }

    Write-Verbose -Message "Exit Function Set-MyClipboard Process Block"
  }
  End
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard End Block"

    if ($OfficeFix.IsPresent)
    {
      if ($PSBoundParameters.ContainsKey("Title"))
      {
        [Void]$HTMLStringBuilder.Append("<table><tr><th style='background:$TitleColor;' colspan='$($Cols.Keys.Count)'>&nbsp;$($Title)&nbsp;</th></tr>")
      }
      else
      {
        [Void]$HTMLStringBuilder.Append("<table>")
      }
      [Void]$HTMLStringBuilder.Append(("<tr style='background:$ColumnColor;'><th>&nbsp;" + ($Cols.Keys -join "&nbsp;</th><th>&nbsp;") + "&nbsp;</th></tr>"))
      $Row = -1
      $RowColor = @($RowEven, $RowOdd)
      ForEach ($Item in $ObjectList)
      {
        [Void]$HTMLStringBuilder.Append("<tr style='background: $($RowColor[($Row = ($Row + 1) % 2)])'>")
        ForEach ($Key in $Cols.Keys)
        {
          [Void]$HTMLStringBuilder.Append("<td style='text-align:$($Cols[$Key])'>&nbsp;$($Item.$Key)&nbsp;</td>")
        }
        [Void]$HTMLStringBuilder.Append("</tr>")
      }
      [Void]$HTMLStringBuilder.Append("</table><br><br>")
    }
    else
    {
      [Void]$HTMLStringBuilder.Append(($ObjectList | ConvertTo-Html -Property $ColNames -Fragment | Out-String))
    }
    [Void]$HTMLStringBuilder.Replace("0000FEND", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<!--EndFragment--></body></html>")
    [Void]$HTMLStringBuilder.Replace("00000END", ("{0:X8}" -f $HTMLStringBuilder.Length))

    [System.Windows.Forms.Clipboard]::Clear()
    $DataObject = [System.Windows.Forms.DataObject]::New()
    $DataObject.SetData("Text", ($ObjectList | Select-Object -Property $ColNames | ConvertTo-Csv -NoTypeInformation | Out-String))
    $DataObject.SetData("HTML Format", $HTMLStringBuilder.ToString())
    [System.Windows.Forms.Clipboard]::SetDataObject($DataObject)

    $ObjectList = $Null
    $HTMLStringBuilder = $Null
    $DataObject = $Null
    $Cols = $Null
    $ColNames = $Null
    $Row = $Null
    $RowColor = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Verbose -Message "Exit Function Set-MyClipboard End Block"
  }
}
#endregion function Set-MyClipboard

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

#endregion ******* Generic / General Functions ********

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

#endregion ******** FCG Commands ********

#endregion ================ My Custom Functions ================

#region >>>>>>>>>>>>>>>> FCG Custom Dialogs <<<<<<<<<<<<<<<<

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
    .PARAMETER ValidCars
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

    if ((-not $GetUserTextDialogMainTextBox.Tag.HintEnabled) -and ("$($GetUserTextDialogMainTextBox.Text.Trim())".Length -gt 0))
    {
      $GetUserTextDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    else
    {
      [Void][System.Windows.Forms.MessageBox]::Show($GetUserTextDialogForm, "Missing or Invalid Value.", [MyConfig]::ScriptName, "OK", "Warning")
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
    [String]$ButtonRight = "&Cancel"
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
  
  #region ******** Function Start-GetUserTextDialogMainTextBoxKeyDown ********
  function Start-GetUserTextDialogMainTextBoxKeyDown
  {
    <#
      .SYNOPSIS
        KeyDown Event for the GetUserTextMain TextBox Control
      .DESCRIPTION
        KeyDown Event for the GetUserTextMain TextBox Control
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
    Write-Verbose -Message "Enter KeyDown Event for `$GetMultiValueDialogTextBox"

    [MyConfig]::AutoExit = 0
    
    if ((-not $Sender.Multiline) -and ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Return))
    {
      $GetUserTextDialogBtmLeftButton.PerformClick()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$GetMultiValueDialogTextBox"
  }
  #endregion ******** Function Start-GetUserTextDialogMainTextBoxKeyDown ********
  #$GetMultiValueDialogTextBox.add_KeyDown({ Start-GetUserTextDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem })
  
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
    $GetMultiValueDialogTextBox.add_KeyDown({ Start-GetUserTextDialogMainTextBoxKeyDown -Sender $This -EventArg $PSItem})
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
    
    $TmpValidCheck = $True
    ForEach ($Key In @($OrderedItems.Keys))
    {
      $OrderedItems[$Key] = $GetMultiValueDialogGroupBox.Controls[$Key].Text
      $TmpValidCheck = (-not [String]::IsNullOrEmpty("$($GetMultiValueDialogGroupBox.Controls[$Key].Text)".Trim())) -and (-not $GetMultiValueDialogGroupBox.Controls[$Key].Tag.HintEnabled) -and $TmpValidCheck
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
  $GetListViewChoiceDialogMainListView.OwnerDraw = $True
  $GetListViewChoiceDialogMainListView.ShowGroups = $False
  $GetListViewChoiceDialogMainListView.ShowItemToolTips = $PSBoundParameters.ContainsKey("ToolTip")
  $GetListViewChoiceDialogMainListView.Size = [System.Drawing.Size]::New(($GetListViewChoiceDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ([MyConfig]::Font.Height * $Height))
  $GetListViewChoiceDialogMainListView.Text = "LAUGetListViewChoiceDialogMainListView"
  $GetListViewChoiceDialogMainListView.View = [System.Windows.Forms.View]::Details
  #endregion $GetListViewChoiceDialogMainListView = [System.Windows.Forms.ListView]::New()
  
  #region ******** Function Start-GetListViewChoiceDialogMainListViewDrawColumnHeader ********
  function Start-GetListViewChoiceDialogMainListViewDrawColumnHeader
  {
    <#
      .SYNOPSIS
        DrawColumnHeader Event for the GetListViewChoiceDialogMain ListView Control
      .DESCRIPTION
        DrawColumnHeader Event for the GetListViewChoiceDialogMain ListView Control
      .PARAMETER Sender
         The ListView Control that fired the DrawColumnHeader Event
      .PARAMETER EventArg
         The Event Arguments for the ListView DrawColumnHeader Event
      .EXAMPLE
         Start-GetListViewChoiceDialogMainListViewDrawColumnHeader -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By kensw
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ListView]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter DrawColumnHeader Event for `$GetListViewChoiceDialogMainListView"

    [MyConfig]::AutoExit = 0

    $EventArg.Graphics.FillRectangle(([System.Drawing.SolidBrush]::New([MyConfig]::Colors.TitleBack)), $EventArg.Bounds)
    $EventArg.Graphics.DrawRectangle(([System.Drawing.Pen]::New([MyConfig]::Colors.TitleFore)), $EventArg.Bounds.X, $EventArg.Bounds.Y, $EventArg.Bounds.Width, ($EventArg.Bounds.Height - 1))
    $EventArg.Graphics.DrawString($EventArg.Header.Text, $Sender.Font, ([System.Drawing.SolidBrush]::New([MyConfig]::Colors.TitleFore)), ($EventArg.Bounds.X + [MyConfig]::FormSpacer), ($EventArg.Bounds.Y + (($EventArg.Bounds.Height - [MyConfig]::Font.Height) / 1)))

    Write-Verbose -Message "Exit DrawColumnHeader Event for `$GetListViewChoiceDialogMainListView"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogMainListViewDrawColumnHeader ********
  $GetListViewChoiceDialogMainListView.add_DrawColumnHeader({Start-GetListViewChoiceDialogMainListViewDrawColumnHeader -Sender $This -EventArg $PSItem})

  #region ******** Function Start-GetListViewChoiceDialogMainListViewDrawItem ********
  function Start-GetListViewChoiceDialogMainListViewDrawItem
  {
    <#
      .SYNOPSIS
        DrawItem Event for the GetListViewChoiceDialogMain ListView Control
      .DESCRIPTION
        DrawItem Event for the GetListViewChoiceDialogMain ListView Control
      .PARAMETER Sender
         The ListView Control that fired the DrawItem Event
      .PARAMETER EventArg
         The Event Arguments for the ListView DrawItem Event
      .EXAMPLE
         Start-GetListViewChoiceDialogMainListViewDrawItem -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By kensw
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ListView]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter DrawItem Event for `$GetListViewChoiceDialogMainListView"

    [MyConfig]::AutoExit = 0

    # Return to Default Draw
    $EventArg.DrawDefault = $True

    Write-Verbose -Message "Exit DrawItem Event for `$GetListViewChoiceDialogMainListView"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogMainListViewDrawItem ********
  $GetListViewChoiceDialogMainListView.add_DrawItem({Start-GetListViewChoiceDialogMainListViewDrawItem -Sender $This -EventArg $PSItem})

  #region ******** Function Start-GetListViewChoiceDialogMainListViewDrawSubItem ********
  function Start-GetListViewChoiceDialogMainListViewDrawSubItem
  {
    <#
      .SYNOPSIS
        DrawSubItem Event for the GetListViewChoiceDialogMain ListView Control
      .DESCRIPTION
        DrawSubItem Event for the GetListViewChoiceDialogMain ListView Control
      .PARAMETER Sender
         The ListView Control that fired the DrawSubItem Event
      .PARAMETER EventArg
         The Event Arguments for the ListView DrawSubItem Event
      .EXAMPLE
         Start-GetListViewChoiceDialogMainListViewDrawSubItem -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By kensw
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [System.Windows.Forms.ListView]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter DrawSubItem Event for `$GetListViewChoiceDialogMainListView"

    [MyConfig]::AutoExit = 0

    # Return to Default Draw
    $EventArg.DrawDefault = $True

    Write-Verbose -Message "Exit DrawSubItem Event for `$GetListViewChoiceDialogMainListView"
  }
  #endregion ******** Function Start-GetListViewChoiceDialogMainListViewDrawSubItem ********
  $GetListViewChoiceDialogMainListView.add_DrawSubItem({Start-GetListViewChoiceDialogMainListViewDrawSubItem -Sender $This -EventArg $PSItem})

  foreach ($PropName in $Property)
  {
    [Void]$GetListViewChoiceDialogMainListView.Columns.Add($PropName, -2)
  }
  [Void]$GetListViewChoiceDialogMainListView.Columns.Add(" ", ($GetListViewChoiceDialogForm.Width * 2))
  
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
    [String]$DialogTitle = "$([MyConfig]::ScriptName)",
    [String]$WindowTitle = "$([MyConfig]::ScriptName) Info",
    [String]$InfoTitle = " << FCG Info Topics >> ",
    [String]$DefInfoTopic = "InfoIntro",
    [Int]$Width = 60,
    [Int]$Height = 24
  )
  Write-Verbose -Message "Enter Function Show-MyHelpDialog"

  #region >>>>>>>>>>>>>>>> Begin **** MyHelpDialog **** Begin <<<<<<<<<<<<<<<<

  # ************************************************
  # MyHelpDialog Form
  # ************************************************
  #region $MyHelpDialogForm = [System.Windows.Forms.Form]::New()
  $MyHelpDialogForm = [System.Windows.Forms.Form]::New()
  $MyHelpDialogForm.BackColor = [MyConfig]::Colors.Back
  $MyHelpDialogForm.Font = [MyConfig]::Font.Regular
  $MyHelpDialogForm.ForeColor = [MyConfig]::Colors.Fore
  $MyHelpDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  $MyHelpDialogForm.Icon = $FCGForm.Icon
  $MyHelpDialogForm.MaximizeBox = $False
  $MyHelpDialogForm.MinimizeBox = $False
  $MyHelpDialogForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * $Width), ([MyConfig]::Font.Height * $Height))
  $MyHelpDialogForm.Name = "MyHelpDialogForm"
  $MyHelpDialogForm.Owner = $FCGForm
  $MyHelpDialogForm.ShowInTaskbar = $False
  $MyHelpDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyHelpDialogForm.Text = $DialogTitle
  #endregion $MyHelpDialogForm = [System.Windows.Forms.Form]::New()

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

    [MyConfig]::AutoExit = 0

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

    [MyConfig]::AutoExit = 0

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

    [MyConfig]::AutoExit = 0

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
  #region $MyHelpDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $MyHelpDialogMainPanel = [System.Windows.Forms.Panel]::New()
  $MyHelpDialogForm.Controls.Add($MyHelpDialogMainPanel)
  $MyHelpDialogMainPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyHelpDialogMainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $MyHelpDialogMainPanel.Name = "MyHelpDialogMainPanel"
  $MyHelpDialogMainPanel.Text = "MyHelpDialogMainPanel"
  #endregion $MyHelpDialogMainPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $MyHelpDialogMainPanel Controls ********

  #region $MyHelpDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()
  $MyHelpDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()
  $MyHelpDialogMainPanel.Controls.Add($MyHelpDialogMainRichTextBox)
  $MyHelpDialogMainRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Bottom, Right")
  $MyHelpDialogMainRichTextBox.BackColor = [MyConfig]::Colors.TextBack
  $MyHelpDialogMainRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $MyHelpDialogMainRichTextBox.DetectUrls = $True
  $MyHelpDialogMainRichTextBox.Font = [MyConfig]::Font.Regular
  $MyHelpDialogMainRichTextBox.ForeColor = [MyConfig]::Colors.TextFore
  $MyHelpDialogMainRichTextBox.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $MyHelpDialogMainRichTextBox.MaxLength = [Int]::MaxValue
  $MyHelpDialogMainRichTextBox.Multiline = $True
  $MyHelpDialogMainRichTextBox.Name = "MyHelpDialogMainRichTextBox"
  $MyHelpDialogMainRichTextBox.ReadOnly = $True
  $MyHelpDialogMainRichTextBox.Rtf = ""
  $MyHelpDialogMainRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
  $MyHelpDialogMainRichTextBox.Size = [System.Drawing.Size]::New(($MyHelpDialogMainPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), ($MyHelpDialogMainPanel.ClientSize.Height - ($MyHelpDialogMainRichTextBox.Top + [MyConfig]::FormSpacer)))
  $MyHelpDialogMainRichTextBox.TabStop = $False
  $MyHelpDialogMainRichTextBox.Text = ""
  $MyHelpDialogMainRichTextBox.WordWrap = $False
  #endregion $MyHelpDialogMainRichTextBox = [System.Windows.Forms.RichTextBox]::New()

  #endregion ******** $MyHelpDialogMainPanel Controls ********

  # ************************************************
  # MyHelpDialogLeft MenuStrip
  # ************************************************
  #region $MyHelpDialogLeftMenuStrip = [System.Windows.Forms.MenuStrip]::New()
  $MyHelpDialogLeftMenuStrip = [System.Windows.Forms.MenuStrip]::New()
  $MyHelpDialogForm.Controls.Add($MyHelpDialogLeftMenuStrip)
  $MyHelpDialogForm.MainMenuStrip = $MyHelpDialogLeftMenuStrip
  $MyHelpDialogLeftMenuStrip.BackColor = [MyConfig]::Colors.Back
  $MyHelpDialogLeftMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left
  $MyHelpDialogLeftMenuStrip.Font = [MyConfig]::Font.Regular
  $MyHelpDialogLeftMenuStrip.ForeColor = [MyConfig]::Colors.Fore
  $MyHelpDialogLeftMenuStrip.ImageList = $FCGImageList
  $MyHelpDialogLeftMenuStrip.Name = "MyHelpDialogLeftMenuStrip"
  $MyHelpDialogLeftMenuStrip.ShowItemToolTips = $True
  $MyHelpDialogLeftMenuStrip.Text = "MyHelpDialogLeftMenuStrip"
  #endregion $MyHelpDialogLeftMenuStrip = [System.Windows.Forms.MenuStrip]::New()

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

    [MyConfig]::AutoExit = 0

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
  New-MenuLabel -Menu $MyHelpDialogLeftMenuStrip -Text $InfoTitle -Name "Info Topics" -Tag "Info Topics" -Font ([MyConfig]::Font.Bold)
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip

  forEach ($Key in $MyHelpDialogTopics.Keys)
  {
    (New-MenuItem -Menu $MyHelpDialogLeftMenuStrip -Text ($MyHelpDialogTopics[$Key]) -Name $Key -Tag $Key -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({ Start-MyHelpDialogLeftToolStripItemClick -Sender $This -EventArg $PSItem })
  }

  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip
  (New-MenuItem -Menu $MyHelpDialogLeftMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({ Start-MyHelpDialogLeftToolStripItemClick -Sender $This -EventArg $PSItem })
  New-MenuSeparator -Menu $MyHelpDialogLeftMenuStrip

  #region $MyHelpDialogTopPanel = [System.Windows.Forms.Panel]::New()
  $MyHelpDialogTopPanel = [System.Windows.Forms.Panel]::New()
  $MyHelpDialogForm.Controls.Add($MyHelpDialogTopPanel)
  $MyHelpDialogTopPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyHelpDialogTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
  $MyHelpDialogTopPanel.Name = "MyHelpDialogTopPanel"
  $MyHelpDialogTopPanel.Text = "MyHelpDialogTopPanel"
  #endregion $MyHelpDialogTopPanel = [System.Windows.Forms.Panel]::New()

  #region ******** $MyHelpDialogTopPanel Controls ********

  #region $MyHelpDialogTopLabel = [System.Windows.Forms.Label]::New()
  $MyHelpDialogTopLabel = [System.Windows.Forms.Label]::New()
  $MyHelpDialogTopPanel.Controls.Add($MyHelpDialogTopLabel)
  $MyHelpDialogTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top, Left, Right")
  $MyHelpDialogTopLabel.BackColor = [MyConfig]::Colors.TitleBack
  $MyHelpDialogTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyHelpDialogTopLabel.Font = [MyConfig]::Font.Title
  $MyHelpDialogTopLabel.ForeColor = [MyConfig]::Colors.TitleFore
  $MyHelpDialogTopLabel.Location = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::FormSpacer)
  $MyHelpDialogTopLabel.Name = "MyHelpDialogTopLabel"
  $MyHelpDialogTopLabel.Text = $WindowTitle
  $MyHelpDialogTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyHelpDialogTopLabel.Size = [System.Drawing.Size]::New(($MyHelpDialogTopPanel.ClientSize.Width - ([MyConfig]::FormSpacer * 2)), $MyHelpDialogTopLabel.PreferredHeight)
  #endregion $MyHelpDialogTopLabel = [System.Windows.Forms.Label]::New()

  $MyHelpDialogTopPanel.ClientSize = [System.Drawing.Size]::New($MyHelpDialogTopPanel.ClientSize.Width, ($MyHelpDialogTopLabel.Bottom + [MyConfig]::FormSpacer))

  #endregion ******** $MyHelpDialogTopPanel Controls ********

  # ************************************************
  # MyHelpDialogBtm StatusStrip
  # ************************************************
  #region $MyHelpDialogBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
  $MyHelpDialogBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
  $MyHelpDialogForm.Controls.Add($MyHelpDialogBtmStatusStrip)
  $MyHelpDialogBtmStatusStrip.BackColor = [MyConfig]::Colors.Back
  $MyHelpDialogBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
  $MyHelpDialogBtmStatusStrip.Font = [MyConfig]::Font.Regular
  $MyHelpDialogBtmStatusStrip.ForeColor = [MyConfig]::Colors.Fore
  $MyHelpDialogBtmStatusStrip.ImageList = $FCGImageList
  $MyHelpDialogBtmStatusStrip.Name = "MyHelpDialogBtmStatusStrip"
  $MyHelpDialogBtmStatusStrip.ShowItemToolTips = $True
  $MyHelpDialogBtmStatusStrip.Text = "MyHelpDialogBtmStatusStrip"
  #endregion $MyHelpDialogBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()

  New-MenuLabel -Menu $MyHelpDialogBtmStatusStrip -Text "Status" -Name "Status" -Tag "Status"

  #endregion ******** Controls for MyHelpDialog Form ********

  #endregion ================ End **** MyHelpDialog **** End ================

  [Void]$MyHelpDialogForm.ShowDialog($FCGForm)

  $MyHelpDialogForm.Dispose()

  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()

  Write-Verbose -Message "Exit Function Show-MyHelpDialog"
}
#endregion function Show-MyHelpDialog


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
      $TmpStart = [DateTime]::Now
      while (([DateTime]::Now - $TmpStart).TotalSeconds -le $AutoCloseWait)
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
  $RichTextBox.AppendText("$($Text): ")
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
  Write-RichTextBox -RichTextBox $RichTextBox -Text "Loading Form Controls Information" -Font ([MyConfig]::Font.Bold) -TextFore ([MyConfig]::Colors.TextTitle)
  
  $FCGCtrlControlsListBox.Items.AddRange(@(Get-MyFormControls))
  
  $RichTextBox.SelectionIndent = 20
  $RichTextBox.SelectionBullet = $True
  Write-RichTextBoxValue -RichTextBox $RichTextBox -Text "Form Controls Loaded" -Value ($FCGCtrlControlsListBox.Items.Count) -ValueFore ([MyConfig]::Colors.TextGood)
  
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



#endregion ================ FCG Custom Dialogs ================

#region >>>>>>>>>>>>>>>> Begin **** FCG **** Begin <<<<<<<<<<<<<<<<

#$Result = [System.Windows.Forms.MessageBox]::Show($FCGForm, "Message Text", [MyConfig]::ScriptName, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

$FCGFormComponents = [System.ComponentModel.Container]::New()

#region $FCGOpenFileDialog = [System.Windows.Forms.OpenFileDialog]::New()
$FCGOpenFileDialog = [System.Windows.Forms.OpenFileDialog]::New()
$FCGOpenFileDialog.CheckFileExists = $True
$FCGOpenFileDialog.CheckPathExists = $True
$FCGOpenFileDialog.RestoreDirectory = $False
$FCGOpenFileDialog.ValidateNames = $True
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


#region $FCGToolTip = [System.Windows.Forms.ToolTip]::New()
$FCGToolTip = [System.Windows.Forms.ToolTip]::New($FCGFormComponents)
$FCGToolTip.Active = $False
$FCGToolTip.AutomaticDelay = 500
$FCGToolTip.AutoPopDelay = 5000
$FCGToolTip.BackColor = [MyConfig]::Colors.Back
$FCGToolTip.ForeColor = [MyConfig]::Colors.Fore
$FCGToolTip.InitialDelay = 500
$FCGToolTip.IsBalloon = $False
$FCGToolTip.ReshowDelay = 100
$FCGToolTip.ShowAlways = $True
#$FCGToolTip.Tag = [System.Object]::New()
$FCGToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$FCGToolTip.ToolTipTitle = "$([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
$FCGToolTip.UseAnimation = $True
$FCGToolTip.UseFading = $True
#endregion $FCGToolTip = [System.Windows.Forms.ToolTip]::New()
#$FCGToolTip.SetToolTip($FormControl, "Form Control Help")

# ************************************************
# FCG ImageList
# ************************************************
#region $FCGImageList = [System.Windows.Forms.ImageList]::New()
$FCGImageList = [System.Windows.Forms.ImageList]::New($FCGFormComponents)
$FCGImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit
$FCGImageList.ImageSize = [System.Drawing.Size]::New(16, 16)
#endregion $FCGImageList = [System.Windows.Forms.ImageList]::New()

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
$FCGForm.BackColor = [MyConfig]::Colors.Back
$FCGForm.Font = [MyConfig]::Font.Regular
$FCGForm.ForeColor = [MyConfig]::Colors.Fore
$FCGForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$FCGForm.Icon = [System.Drawing.Icon]::New([System.IO.MemoryStream]::New([System.Convert]::FromBase64String($FCGFormIcon)))
$FCGForm.KeyPreview = $True
#$FCGForm.MainMenuStrip = [System.Windows.Forms.MenuStrip]::New()
$FCGForm.MaximizeBox = $True
$FCGForm.MinimizeBox = $True
$FCGForm.MinimumSize = [System.Drawing.Size]::New(([MyConfig]::Font.Width * [MyConfig]::FormMinWidth), ([MyConfig]::Font.Height * [MyConfig]::FormMinHeight))
$FCGForm.Name = "FCGForm"
$FCGForm.ShowIcon = $True
$FCGForm.ShowInTaskbar = $True
$FCGForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$FCGForm.TabStop = $True
$FCGForm.Tag = (-not [MyConfig]::Production)
$FCGForm.Text = "$([MyConfig]::ScriptName) - $([MyConfig]::ScriptVersion)"
$FCGForm.TopLevel = $True
$FCGForm.TopMost = $False
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
        $ScriptContents = $Script:MyInvocation.MyCommand.ScriptContents
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

  $HashTable = @{"ShowHeader" = $True; "Name" = "Item Name"; "Value" = "Item Value"}
  $ScriptBlock = { [CmdletBinding()] param ([System.Windows.Forms.RichTextBox]$RichTextBox, [HashTable]$HashTable) Display-InitiliazeFCGUtility -RichTextBox $RichTextBox -HashTable $HashTable }
  $DialogResult = Show-MyStatusDialog -ScriptBlock $ScriptBlock -DialogTitle "Initializing $([MyConfig]::ScriptName)" -ButtonMid "OK" -HashTable $HashTable
  
  $Host.EnterNestedPrompt()
  
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
$FCGTimer.Enabled = $False
$FCGTimer.Interval = [MyConfig]::AutoExitTic
$FCGTimer.Tag = @{}
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


# ************************************************
# FCGMain SplitContainer
# ************************************************
#region $FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGForm.Controls.Add($FCGMainSplitContainer)
$FCGMainSplitContainer.BackColor = [MyConfig]::Colors.Back
$FCGMainSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGMainSplitContainer.Enabled = $True
$FCGMainSplitContainer.FixedPanel = [System.Windows.Forms.FixedPanel]::Panel1
$FCGMainSplitContainer.Name = "FCGMainSplitContainer"
$FCGMainSplitContainer.Panel1MinSize = ([MyConfig]::Font.Width * [MyConfig]::PanMinWidth)
$FCGMainSplitContainer.Panel2MinSize = $FCGMainSplitContainer.Panel1MinSize
$FCGMainSplitContainer.SplitterDistance = $FCGMainSplitContainer.Panel1MinSize
$FCGMainSplitContainer.SplitterIncrement = [MyConfig]::FormSpacer
$FCGMainSplitContainer.SplitterWidth = [MyConfig]::FormSpacer
#$FCGMainSplitContainer.TabIndex = 0
$FCGMainSplitContainer.TabStop = $False
$FCGMainSplitContainer.Tag = $Null
$FCGMainSplitContainer.Visible = $True
#endregion $FCGMainSplitContainer = [System.Windows.Forms.SplitContainer]::New()

# ************************************************
# $FCGMainSplitContainer Panel1 Controls - Prefix, Controls, and Events
# ************************************************
#region ******** $FCGMainSplitContainer Panel1 Controls ********

$FCGMainSplitContainer.Panel1.Padding = [System.Windows.Forms.Padding]::New([MyConfig]::FormSpacer, 0, 0, 0)

# ************************************************
# FCGCtrls SplitContainer - Controls and Events
# ************************************************
#region $FCGCtrlSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGCtrlSplitContainer = [System.Windows.Forms.SplitContainer]::New()
$FCGMainSplitContainer.Panel1.Controls.Add($FCGCtrlSplitContainer)
$FCGCtrlSplitContainer.BackColor = [MyConfig]::Colors.Back
$FCGCtrlSplitContainer.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$FCGCtrlSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGCtrlSplitContainer.Enabled = $True
$FCGCtrlSplitContainer.Name = "FCGCtrlSplitContainer"
$FCGCtrlSplitContainer.Orientation = [System.Windows.Forms.Orientation]::Horizontal
$FCGCtrlSplitContainer.SplitterDistance = ([MyConfig]::Font.Width * [MyConfig]::PanMinWidth)
$FCGCtrlSplitContainer.SplitterIncrement = [MyConfig]::FormSpacer
$FCGCtrlSplitContainer.SplitterWidth = [MyConfig]::FormSpacer
#$FCGCtrlSplitContainer.TabIndex = 0
$FCGCtrlSplitContainer.TabStop = $False
#$FCGCtrlSplitContainer.Tag = $Null
$FCGCtrlSplitContainer.Visible = $True
#endregion $FCGCtrlSplitContainer = [System.Windows.Forms.SplitContainer]::New()


# ************************************************
# $FCGCtrlSplitContainer Panel1 Controls - Controls
# ************************************************
#region ******** $FCGCtrlSplitContainer Panel1 Controls ********

# ************************************************
# FCGCtrlControls GroupBox
# ************************************************
#region $FCGCtrlControlsGroupBox = [System.Windows.Forms.GroupBox]::New()
$FCGCtrlControlsGroupBox = [System.Windows.Forms.GroupBox]::New()
# Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
$FCGCtrlSplitContainer.Panel1.Controls.Add($FCGCtrlControlsGroupBox)
$FCGCtrlControlsGroupBox.BackColor = [MyConfig]::Colors.Back
$FCGCtrlControlsGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGCtrlControlsGroupBox.Enabled = $True
$FCGCtrlControlsGroupBox.Font = [MyConfig]::Font.Regular
$FCGCtrlControlsGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
$FCGCtrlControlsGroupBox.Name = "FCGCtrlControlsGroupBox"
$FCGCtrlControlsGroupBox.TabStop = $False
$FCGCtrlControlsGroupBox.Tag = $Null
$FCGCtrlControlsGroupBox.Text = "Form Controls"
$FCGCtrlControlsGroupBox.Visible = $True
#endregion $FCGCtrlControlsGroupBox = [System.Windows.Forms.GroupBox]::New()

#region ******** $FCGCtrlControlsGroupBox Controls ********

#region $FCGCtrlControlsListBox = [System.Windows.Forms.ListBox]::New()
$FCGCtrlControlsListBox = [System.Windows.Forms.ListBox]::New()
$FCGCtrlControlsGroupBox.Controls.Add($FCGCtrlControlsListBox)
$FCGCtrlControlsListBox.BackColor = [MyConfig]::Colors.TextBack
#$FCGCtrlControlsListBox.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGCtrlControlsListBox.DataSource = [System.Object]::New()
$FCGCtrlControlsListBox.DisplayMember = "Name"
$FCGCtrlControlsListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGCtrlControlsListBox.Enabled = $True
$FCGCtrlControlsListBox.Font = [MyConfig]::Font.Regular
$FCGCtrlControlsListBox.ForeColor = [MyConfig]::Colors.TextFore
$FCGCtrlControlsListBox.IntegralHeight = $False
#$FCGCtrlControlsListBox.ItemHeight = [MyConfig]::Font.Height
$FCGCtrlControlsListBox.Name = "FCGCtrlControlsListBox"
$FCGCtrlControlsListBox.Sorted = $True
$FCGCtrlControlsListBox.TabStop = $True
$FCGCtrlControlsListBox.Tag = @{ "SelectedIndex" = $Null }
$FCGCtrlControlsListBox.ValueMember = "FullName"
$FCGCtrlControlsListBox.Visible = $True
#endregion $FCGCtrlControlsListBox = [System.Windows.Forms.ListBox]::New()

#region ******** Function Start-FCGCtrlControlsListBoxMouseDown ********
function Start-FCGCtrlControlsListBoxMouseDown
{
  <#
    .SYNOPSIS
      MouseDown Event for the FCGCtrlControls ListBox Control
    .DESCRIPTION
      MouseDown Event for the FCGCtrlControls ListBox Control
    .PARAMETER Sender
       The ListBox Control that fired the MouseDown Event
    .PARAMETER EventArg
       The Event Arguments for the ListBox MouseDown Event
    .EXAMPLE
       Start-FCGCtrlControlsListBoxMouseDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter MouseDown Event for `$FCGCtrlControlsListBox"

  [MyConfig]::AutoExit = 0

  $TempIndex = $Sender.IndexFromPoint($EventArg.location)
  if (($TempIndex -gt -1) -and ($Sender.SelectedIndices -notcontains $TempIndex))
  {
    $Sender.SelectedItems.Clear()
    $Sender.SelectedIndex = $TempIndex
  }
  $TempIndex = $Null

  Write-Verbose -Message "Exit MouseDown Event for `$FCGCtrlControlsListBox"
}
#endregion ******** Function Start-FCGCtrlControlsListBoxMouseDown ********
$FCGCtrlControlsListBox.add_MouseDown({Start-FCGCtrlControlsListBoxMouseDown -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsListBoxSelectedIndexChanged ********
function Start-FCGCtrlControlsListBoxSelectedIndexChanged
{
  <#
    .SYNOPSIS
      SelectedIndexChanged Event for the FCGCtrlControls ListBox Control
    .DESCRIPTION
      SelectedIndexChanged Event for the FCGCtrlControls ListBox Control
    .PARAMETER Sender
       The ListBox Control that fired the SelectedIndexChanged Event
    .PARAMETER EventArg
       The Event Arguments for the ListBox SelectedIndexChanged Event
    .EXAMPLE
       Start-FCGCtrlControlsListBoxSelectedIndexChanged -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter SelectedIndexChanged Event for `$FCGCtrlControlsListBox"
  
  [MyConfig]::AutoExit = 0
    
  If ($Sender.Tag.SelectedIndex -ne $Sender.SelectedIndex)
  {
    $Sender.Tag.SelectedIndex = $Sender.SelectedIndex
    $FCGCtrlEventsCheckedListBox.Items.Clear()
    $FCGCtrlEventsCheckedListBox.Items.AddRange(@($Sender.SelectedItem.Events))
  }
  
  # $FCGCtrlEventsCheckedListBox
  
  Write-Verbose -Message "Exit SelectedIndexChanged Event for `$FCGCtrlControlsListBox"
}
#endregion ******** Function Start-FCGCtrlControlsListBoxSelectedIndexChanged ********
$FCGCtrlControlsListBox.add_SelectedIndexChanged({Start-FCGCtrlControlsListBoxSelectedIndexChanged -Sender $This -EventArg $PSItem})


#region $FCGCtrlEventsPictureBox = [System.Windows.Forms.PictureBox]::New()
$FCGCtrlEventsPictureBox = [System.Windows.Forms.PictureBox]::New()
$FCGCtrlControlsGroupBox.Controls.Add($FCGCtrlEventsPictureBox)
$FCGCtrlEventsPictureBox.BackColor = [MyConfig]::Colors.Back
$FCGCtrlEventsPictureBox.Dock = [System.Windows.Forms.DockStyle]::Top
$FCGCtrlEventsPictureBox.Enabled = $True
$FCGCtrlEventsPictureBox.Height = [MyConfig]::FormSpacer
$FCGCtrlEventsPictureBox.Name = "FCGCtrlEventsPictureBox"
$FCGCtrlEventsPictureBox.TabStop = $False
$FCGCtrlEventsPictureBox.Visible = $True
#endregion $FCGCtrlEventsPictureBox = [System.Windows.Forms.PictureBox]::New()


#region $FCGCtrlControlsTextBox = [System.Windows.Forms.TextBox]::New()
$FCGCtrlControlsTextBox = [System.Windows.Forms.TextBox]::New()
$FCGCtrlControlsGroupBox.Controls.Add($FCGCtrlControlsTextBox)
$FCGCtrlControlsTextBox.BackColor = [MyConfig]::Colors.TextBack
$FCGCtrlControlsTextBox.Dock = [System.Windows.Forms.DockStyle]::Top
$FCGCtrlControlsTextBox.Enabled = $True
$FCGCtrlControlsTextBox.Font = [MyConfig]::Font.Regular
$FCGCtrlControlsTextBox.ForeColor = [MyConfig]::Colors.TextHint
$FCGCtrlControlsTextBox.MaxLength = 50
$FCGCtrlControlsTextBox.Name = "FCGCtrlControlsTextBox"
$FCGCtrlControlsTextBox.ShortcutsEnabled = $False
$FCGCtrlControlsTextBox.TabStop = $True
$FCGCtrlControlsTextBox.Tag = @{ "HintText" = "Enter Optional Form Control Name."; "HintEnabled" = $True }
$FCGCtrlControlsTextBox.Text = $FCGCtrlControlsTextBox.Tag.HintText
$FCGCtrlControlsTextBox.Visible = $True
$FCGCtrlControlsTextBox.WordWrap = $False
#endregion $FCGCtrlControlsTextBox = [System.Windows.Forms.TextBox]::New()

#region ******** Function Start-FCGCtrlControlsTextBoxGotFocus ********
function Start-FCGCtrlControlsTextBoxGotFocus
{
  <#
    .SYNOPSIS
      GotFocus Event for the FCGCtrlControls TextBox Control
    .DESCRIPTION
      GotFocus Event for the FCGCtrlControls TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the GotFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox GotFocus Event
    .EXAMPLE
       Start-FCGCtrlControlsTextBoxGotFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter GotFocus Event for `$FCGCtrlControlsTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  if ($Sender.Tag.HintEnabled)
  {
    $Sender.Text = ""
    $Sender.Font = [MyConfig]::Font.Regular
    $Sender.ForeColor = [MyConfig]::Colors.TextFore
  }

  Write-Verbose -Message "Exit GotFocus Event for `$FCGCtrlControlsTextBox"
}
#endregion ******** Function Start-FCGCtrlControlsTextBoxGotFocus ********
$FCGCtrlControlsTextBox.add_GotFocus({Start-FCGCtrlControlsTextBoxGotFocus -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsTextBoxKeyDown ********
function Start-FCGCtrlControlsTextBoxKeyDown
{
  <#
    .SYNOPSIS
      KeyDown Event for the FCGCtrlControls TextBox Control
    .DESCRIPTION
      KeyDown Event for the FCGCtrlControls TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyDown Event
    .EXAMPLE
       Start-FCGCtrlControlsTextBoxKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyDown Event for `$FCGCtrlControlsTextBox"

  [MyConfig]::AutoExit = 0

  Write-Verbose -Message "Exit KeyDown Event for `$FCGCtrlControlsTextBox"
}
#endregion ******** Function Start-FCGCtrlControlsTextBoxKeyDown ********
$FCGCtrlControlsTextBox.add_KeyDown({Start-FCGCtrlControlsTextBoxKeyDown -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsTextBoxKeyPress ********
function Start-FCGCtrlControlsTextBoxKeyPress
{
  <#
    .SYNOPSIS
      KeyPress Event for the FCGCtrlControls TextBox Control
    .DESCRIPTION
      KeyPress Event for the FCGCtrlControls TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyPress Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyPress Event
    .EXAMPLE
       Start-FCGCtrlControlsTextBoxKeyPress -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyPress Event for `$FCGCtrlControlsTextBox"

  [MyConfig]::AutoExit = 0

    # 3 = Ctrl-C, 8 = Backspace, 22 = Ctrl-V, 24 = Ctrl-X
    # $ValidChars = "[\s\w\d\.\-_]"
    #$EventArg.Handled = (($EventArg.KeyChar -notmatch $ValidChars) -and ([Int]($EventArg.KeyChar) -notin (3, 8, 22, 24)))

  Write-Verbose -Message "Exit KeyPress Event for `$FCGCtrlControlsTextBox"
}
#endregion ******** Function Start-FCGCtrlControlsTextBoxKeyPress ********
$FCGCtrlControlsTextBox.add_KeyPress({Start-FCGCtrlControlsTextBoxKeyPress -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsTextBoxKeyUp ********
function Start-FCGCtrlControlsTextBoxKeyUp
{
  <#
    .SYNOPSIS
      KeyUp Event for the FCGCtrlControls TextBox Control
    .DESCRIPTION
      KeyUp Event for the FCGCtrlControls TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyUp Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyUp Event
    .EXAMPLE
       Start-FCGCtrlControlsTextBoxKeyUp -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyUp Event for `$FCGCtrlControlsTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  $Sender.Tag.HintEnabled = ($Sender.Text.Trim().Length -eq 0)

  Write-Verbose -Message "Exit KeyUp Event for `$FCGCtrlControlsTextBox"
}
#endregion ******** Function Start-FCGCtrlControlsTextBoxKeyUp ********
$FCGCtrlControlsTextBox.add_KeyUp({Start-FCGCtrlControlsTextBoxKeyUp -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsTextBoxLostFocus ********
function Start-FCGCtrlControlsTextBoxLostFocus
{
  <#
    .SYNOPSIS
      LostFocus Event for the FCGCtrlControls TextBox Control
    .DESCRIPTION
      LostFocus Event for the FCGCtrlControls TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the LostFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox LostFocus Event
    .EXAMPLE
       Start-FCGCtrlControlsTextBoxLostFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter LostFocus Event for `$FCGCtrlControlsTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  if ([String]::IsNullOrEmpty(($Sender.Text.Trim())))
  {
    $Sender.Text = $Sender.Tag.HintText
    $Sender.Tag.HintEnabled = $True
    $Sender.Font = [MyConfig]::Font.Hint
    $Sender.ForeColor = [MyConfig]::Colors.TextHint
  }
  else
  {
    $Sender.Tag.HintEnabled = $False
    $Sender.Font = [MyConfig]::Font.Regular
    $Sender.ForeColor = [MyConfig]::Colors.TextFore
  }

  Write-Verbose -Message "Exit LostFocus Event for `$FCGCtrlControlsTextBox"
}
#endregion ******** Function Start-FCGCtrlControlsTextBoxLostFocus ********
$FCGCtrlControlsTextBox.add_LostFocus({Start-FCGCtrlControlsTextBoxLostFocus -Sender $This -EventArg $PSItem})

# ************************************************
# FCGCtrlControls ContextMenuStrip
# ************************************************
#region $FCGCtrlControlsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
$FCGCtrlControlsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
$FCGCtrlControlsListBox.ContextMenuStrip = $FCGCtrlControlsContextMenuStrip
$FCGCtrlControlsContextMenuStrip.BackColor = [MyConfig]::Colors.Back
$FCGCtrlControlsContextMenuStrip.Enabled = $True
$FCGCtrlControlsContextMenuStrip.Font = [MyConfig]::Font.Regular
$FCGCtrlControlsContextMenuStrip.ForeColor = [MyConfig]::Colors.Fore
$FCGCtrlControlsContextMenuStrip.ImageList = $FCGImageList
$FCGCtrlControlsContextMenuStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
$FCGCtrlControlsContextMenuStrip.Name = "FCGCtrlControlsContextMenuStrip"
$FCGCtrlControlsContextMenuStrip.ShowCheckMargin = $False
$FCGCtrlControlsContextMenuStrip.ShowImageMargin = $True
$FCGCtrlControlsContextMenuStrip.ShowItemToolTips = $True
$FCGCtrlControlsContextMenuStrip.Tag = $False
$FCGCtrlControlsContextMenuStrip.Text = "FCGCtrlControlsContextMenuStrip"
#endregion $FCGCtrlControlsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()

#region ******** Function Start-FCGCtrlControlsContextMenuStripOpening ********
function Start-FCGCtrlControlsContextMenuStripOpening
{
  <#
    .SYNOPSIS
      Opening Event for the FCGCtrlControls ContextMenuStrip Control
    .DESCRIPTION
      Opening Event for the FCGCtrlControls ContextMenuStrip Control
    .PARAMETER Sender
       The ContextMenuStrip Control that fired the Opening Event
    .PARAMETER EventArg
       The Event Arguments for the ContextMenuStrip Opening Event
    .EXAMPLE
       Start-FCGCtrlControlsContextMenuStripOpening -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ContextMenuStrip]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Opening Event for `$FCGCtrlControlsContextMenuStrip"

  [MyConfig]::AutoExit = 0

  #$FCGBtmStatusStrip.Items["Status"].Text = "$($Sender.Name)"

  Write-Verbose -Message "Exit Opening Event for `$FCGCtrlControlsContextMenuStrip"
}
#endregion ******** Function Start-FCGCtrlControlsContextMenuStripOpening ********
$FCGCtrlControlsContextMenuStrip.add_Opening({Start-FCGCtrlControlsContextMenuStripOpening -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlControlsContextMenuStripItemClick ********
function Start-FCGCtrlControlsContextMenuStripItemClick
{
  <#
    .SYNOPSIS
      Click Event for the FCGCtrlControls ToolStripItem Control
    .DESCRIPTION
      Click Event for the FCGCtrlControls ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-FCGCtrlControlsContextMenuStripItemClick -Sender $Sender -EventArg $EventArg
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
  Write-Verbose -Message "Enter Click Event for `$FCGCtrlControlsContextMenuStripItem"

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

  Write-Verbose -Message "Exit Click Event for `$FCGCtrlControlsContextMenuStripItem"
}
#endregion ******** Function Start-FCGCtrlControlsContextMenuStripItemClick ********

(New-MenuItem -Menu $FCGCtrlControlsContextMenuStrip -Text "&Bug" -Name "Bug" -Tag "Bug" -ToolTip "Bug" -DisplayStyle "ImageAndText" -ImageKey "BugIcon" -PassThru).add_Click({Start-FCGCtrlControlsContextMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGCtrlControlsContextMenuStrip -Text "&Help" -Name "Help" -Tag "Help" -ToolTip "Help" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({Start-FCGCtrlControlsContextMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGCtrlControlsContextMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -ToolTip "Exit" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({Start-FCGCtrlControlsContextMenuStripItemClick -Sender $This -EventArg $PSItem})

#endregion ******** $FCGCtrlControlsGroupBox Controls ********

#endregion ******** $FCGCtrlSplitContainer Panel1 Controls ********


# ************************************************
# $FCGCtrlSplitContainer Panel2 Controls - Events
# ************************************************
#region ******** $FCGCtrlSplitContainer Panel2 Controls ********

# ************************************************
# FCGCtrlEvents GroupBox
# ************************************************
#region $FCGCtrlEventsGroupBox = [System.Windows.Forms.GroupBox]::New()
$FCGCtrlEventsGroupBox = [System.Windows.Forms.GroupBox]::New()
# Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
$FCGCtrlSplitContainer.Panel2.Controls.Add($FCGCtrlEventsGroupBox)
$FCGCtrlEventsGroupBox.BackColor = [MyConfig]::Colors.Back
$FCGCtrlEventsGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGCtrlEventsGroupBox.Enabled = $True
$FCGCtrlEventsGroupBox.Font = [MyConfig]::Font.Regular
$FCGCtrlEventsGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
#$FCGCtrlEventsGroupBox.Height = ([MyConfig]::Font.Height * 16) #[MyConfig]::EventsHeight)
$FCGCtrlEventsGroupBox.Name = "FCGCtrlEventsGroupBox"
$FCGCtrlEventsGroupBox.TabStop = $False
$FCGCtrlEventsGroupBox.Tag = $Null
$FCGCtrlEventsGroupBox.Text = "Form Control Events"
$FCGCtrlEventsGroupBox.Visible = $True
#endregion $FCGCtrlEventsGroupBox = [System.Windows.Forms.GroupBox]::New()

#region ******** $FCGCtrlEventsGroupBox Controls ********

#region $FCGCtrlEventsCheckedListBox = [System.Windows.Forms.CheckedListBox]::New()
$FCGCtrlEventsCheckedListBox = [System.Windows.Forms.CheckedListBox]::New()
$FCGCtrlEventsGroupBox.Controls.Add($FCGCtrlEventsCheckedListBox)
$FCGCtrlEventsCheckedListBox.BackColor = [MyConfig]::Colors.TextBack
$FCGCtrlEventsCheckedListBox.CheckOnClick = $True
#$FCGCtrlEventsCheckedListBox.ContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
#$FCGCtrlEventsCheckedListBox.DataSource = [System.Object]::New()
$FCGCtrlEventsCheckedListBox.DisplayMember = "Name"
$FCGCtrlEventsCheckedListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGCtrlEventsCheckedListBox.Enabled = $True
$FCGCtrlEventsCheckedListBox.Font = [MyConfig]::Font.Regular
$FCGCtrlEventsCheckedListBox.ForeColor = [MyConfig]::Colors.TextFore
$FCGCtrlEventsCheckedListBox.IntegralHeight = $False
#$FCGCtrlEventsCheckedListBox.ItemHeight = [MyConfig]::Font.Height
$FCGCtrlEventsCheckedListBox.Name = "FCGCtrlEventsCheckedListBox"
$FCGCtrlEventsCheckedListBox.ScrollAlwaysVisible = $False
$FCGCtrlEventsCheckedListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::One
$FCGCtrlEventsCheckedListBox.Sorted = $True
$FCGCtrlEventsCheckedListBox.TabStop = $True
$FCGCtrlEventsCheckedListBox.Tag = $Null
$FCGCtrlEventsCheckedListBox.ThreeDCheckBoxes = $False
$FCGCtrlEventsCheckedListBox.ValueMember = "AddName"
$FCGCtrlEventsCheckedListBox.Visible = $True
#endregion $FCGCtrlEventsCheckedListBox = [System.Windows.Forms.CheckedListBox]::New()

#region ******** Function Start-FCGCtrlEventsCheckedListBoxItemCheck ********
function Start-FCGCtrlEventsCheckedListBoxItemCheck
{
  <#
    .SYNOPSIS
      ItemCheck Event for the FCGCtrlEvents CheckedListBox Control
    .DESCRIPTION
      ItemCheck Event for the FCGCtrlEvents CheckedListBox Control
    .PARAMETER Sender
       The CheckedListBox Control that fired the ItemCheck Event
    .PARAMETER EventArg
       The Event Arguments for the CheckedListBox ItemCheck Event
    .EXAMPLE
       Start-FCGCtrlEventsCheckedListBoxItemCheck -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.CheckedListBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter ItemCheck Event for `$FCGCtrlEventsCheckedListBox"

  [MyConfig]::AutoExit = 0

  Write-Verbose -Message "Exit ItemCheck Event for `$FCGCtrlEventsCheckedListBox"
}
#endregion ******** Function Start-FCGCtrlEventsCheckedListBoxItemCheck ********
$FCGCtrlEventsCheckedListBox.add_ItemCheck({Start-FCGCtrlEventsCheckedListBoxItemCheck -Sender $This -EventArg $PSItem})

# ************************************************
# FCGCtrlEvents ContextMenuStrip
# ************************************************
#region $FCGCtrlEventsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
$FCGCtrlEventsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()
$FCGCtrlEventsCheckedListBox.ContextMenuStrip = $FCGCtrlEventsContextMenuStrip
$FCGCtrlEventsContextMenuStrip.BackColor = [MyConfig]::Colors.Back
$FCGCtrlEventsContextMenuStrip.Enabled = $True
$FCGCtrlEventsContextMenuStrip.Font = [MyConfig]::Font.Regular
$FCGCtrlEventsContextMenuStrip.ForeColor = [MyConfig]::Colors.Fore
$FCGCtrlEventsContextMenuStrip.ImageList = $FCGImageList
$FCGCtrlEventsContextMenuStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
$FCGCtrlEventsContextMenuStrip.Name = "FCGCtrlEventsContextMenuStrip"
$FCGCtrlEventsContextMenuStrip.ShowCheckMargin = $False
$FCGCtrlEventsContextMenuStrip.ShowImageMargin = $True
$FCGCtrlEventsContextMenuStrip.ShowItemToolTips = $True
$FCGCtrlEventsContextMenuStrip.Tag = $False
$FCGCtrlEventsContextMenuStrip.Text = "FCGCtrlEventsContextMenuStrip"
#endregion $FCGCtrlEventsContextMenuStrip = [System.Windows.Forms.ContextMenuStrip]::New()

#region ******** Function Start-FCGCtrlEventsContextMenuStripOpening ********
function Start-FCGCtrlEventsContextMenuStripOpening
{
  <#
    .SYNOPSIS
      Opening Event for the FCGCtrlEvents ContextMenuStrip Control
    .DESCRIPTION
      Opening Event for the FCGCtrlEvents ContextMenuStrip Control
    .PARAMETER Sender
       The ContextMenuStrip Control that fired the Opening Event
    .PARAMETER EventArg
       The Event Arguments for the ContextMenuStrip Opening Event
    .EXAMPLE
       Start-FCGCtrlEventsContextMenuStripOpening -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ContextMenuStrip]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Opening Event for `$FCGCtrlEventsContextMenuStrip"

  [MyConfig]::AutoExit = 0

  #$FCGBtmStatusStrip.Items["Status"].Text = "$($Sender.Name)"

  Write-Verbose -Message "Exit Opening Event for `$FCGCtrlEventsContextMenuStrip"
}
#endregion ******** Function Start-FCGCtrlEventsContextMenuStripOpening ********
$FCGCtrlEventsContextMenuStrip.add_Opening({Start-FCGCtrlEventsContextMenuStripOpening -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGCtrlEventsContextMenuStripItemClick ********
function Start-FCGCtrlEventsContextMenuStripItemClick
{
  <#
    .SYNOPSIS
      Click Event for the FCGCtrlEvents ToolStripItem Control
    .DESCRIPTION
      Click Event for the FCGCtrlEvents ToolStripItem Control
    .PARAMETER Sender
       The ToolStripItem Control that fired the Click Event
    .PARAMETER EventArg
       The Event Arguments for the ToolStripItem Click Event
    .EXAMPLE
       Start-FCGCtrlEventsContextMenuStripItemClick -Sender $Sender -EventArg $EventArg
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
  Write-Verbose -Message "Enter Click Event for `$FCGCtrlEventsContextMenuStripItem"

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

  Write-Verbose -Message "Exit Click Event for `$FCGCtrlEventsContextMenuStripItem"
}
#endregion ******** Function Start-FCGCtrlEventsContextMenuStripItemClick ********

(New-MenuItem -Menu $FCGCtrlEventsContextMenuStrip -Text "&Bug" -Name "Bug" -Tag "Bug" -ToolTip "Bug" -DisplayStyle "ImageAndText" -ImageKey "BugIcon" -PassThru).add_Click({Start-FCGCtrlEventsContextMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGCtrlEventsContextMenuStrip -Text "&Help" -Name "Help" -Tag "Help" -ToolTip "Help" -DisplayStyle "ImageAndText" -ImageKey "HelpIcon" -PassThru).add_Click({Start-FCGCtrlEventsContextMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGCtrlEventsContextMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -ToolTip "Exit" -DisplayStyle "ImageAndText" -ImageKey "ExitIcon" -PassThru).add_Click({Start-FCGCtrlEventsContextMenuStripItemClick -Sender $This -EventArg $PSItem})

#endregion ******** $FCGCtrlEventsGroupBox Controls ********

#endregion ******** $FCGCtrlSplitContainer Panel2 Controls ********

# ************************************************
# FCGMainPrefix GroupBox
# ************************************************
#region $FCGMainPrefixGroupBox = [System.Windows.Forms.GroupBox]::New()
$FCGMainPrefixGroupBox = [System.Windows.Forms.GroupBox]::New()
# Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
$FCGMainSplitContainer.Panel1.Controls.Add($FCGMainPrefixGroupBox)
$FCGMainPrefixGroupBox.BackColor = [MyConfig]::Colors.Back
$FCGMainPrefixGroupBox.Dock = [System.Windows.Forms.DockStyle]::Top
$FCGMainPrefixGroupBox.Enabled = $True
$FCGMainPrefixGroupBox.Font = [MyConfig]::Font.Regular
$FCGMainPrefixGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
$FCGMainPrefixGroupBox.Name = "FCGMainPrefixGroupBox"
$FCGMainPrefixGroupBox.Text = "Script Prefix Code"
$FCGMainPrefixGroupBox.Visible = $True
#endregion $FCGMainPrefixGroupBox = [System.Windows.Forms.GroupBox]::New()

#region ******** $FCGMainPrefixGroupBox Controls ********

#region $FCGMainPrefixTextBox = [System.Windows.Forms.TextBox]::New()
$FCGMainPrefixTextBox = [System.Windows.Forms.TextBox]::New()
$FCGMainPrefixGroupBox.Controls.Add($FCGMainPrefixTextBox)
$FCGMainPrefixTextBox.BackColor = [MyConfig]::Colors.TextBack
$FCGMainPrefixTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$FCGMainPrefixTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGMainPrefixTextBox.Enabled = $True
$FCGMainPrefixTextBox.Font = [MyConfig]::Font.Regular
$FCGMainPrefixTextBox.ForeColor = [MyConfig]::Colors.TextHint
$FCGMainPrefixTextBox.MaxLength = 5
$FCGMainPrefixTextBox.Name = "FCGMainPrefixTextBox"
$FCGMainPrefixTextBox.ShortcutsEnabled = $False
#$FCGMainPrefixTextBox.TabIndex = 0
$FCGMainPrefixTextBox.TabStop = $True
$FCGMainPrefixTextBox.Tag = @{ "HintText" = "Enter 3-5 Character Script Prefix Code."; "HintEnabled" = $True }
$FCGMainPrefixTextBox.Text = $FCGMainPrefixTextBox.Tag.HintText
$FCGMainPrefixTextBox.Visible = $True
$FCGMainPrefixTextBox.WordWrap = $False
#endregion $FCGMainPrefixTextBox = [System.Windows.Forms.TextBox]::New()

#region ******** Function Start-FCGMainPrefixTextBoxGotFocus ********
function Start-FCGMainPrefixTextBoxGotFocus
{
  <#
    .SYNOPSIS
      GotFocus Event for the FCGMainPrefix TextBox Control
    .DESCRIPTION
      GotFocus Event for the FCGMainPrefix TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the GotFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox GotFocus Event
    .EXAMPLE
       Start-FCGMainPrefixTextBoxGotFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter GotFocus Event for `$FCGMainPrefixTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  if ($Sender.Tag.HintEnabled)
  {
    $Sender.Text = ""
    $Sender.Font = [MyConfig]::Font.Regular
    $Sender.ForeColor = [MyConfig]::Colors.TextFore
  }

  Write-Verbose -Message "Exit GotFocus Event for `$FCGMainPrefixTextBox"
}
#endregion ******** Function Start-FCGMainPrefixTextBoxGotFocus ********
$FCGMainPrefixTextBox.add_GotFocus({Start-FCGMainPrefixTextBoxGotFocus -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGMainPrefixTextBoxKeyDown ********
function Start-FCGMainPrefixTextBoxKeyDown
{
  <#
    .SYNOPSIS
      KeyDown Event for the FCGMainPrefix TextBox Control
    .DESCRIPTION
      KeyDown Event for the FCGMainPrefix TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyDown Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyDown Event
    .EXAMPLE
       Start-FCGMainPrefixTextBoxKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyDown Event for `$FCGMainPrefixTextBox"

  [MyConfig]::AutoExit = 0

  Write-Verbose -Message "Exit KeyDown Event for `$FCGMainPrefixTextBox"
}
#endregion ******** Function Start-FCGMainPrefixTextBoxKeyDown ********
$FCGMainPrefixTextBox.add_KeyDown({Start-FCGMainPrefixTextBoxKeyDown -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGMainPrefixTextBoxKeyPress ********
function Start-FCGMainPrefixTextBoxKeyPress
{
  <#
    .SYNOPSIS
      KeyPress Event for the FCGMainPrefix TextBox Control
    .DESCRIPTION
      KeyPress Event for the FCGMainPrefix TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyPress Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyPress Event
    .EXAMPLE
       Start-FCGMainPrefixTextBoxKeyPress -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyPress Event for `$FCGMainPrefixTextBox"

  [MyConfig]::AutoExit = 0

    # 3 = Ctrl-C, 8 = Backspace, 22 = Ctrl-V, 24 = Ctrl-X
    # $ValidChars = "[\s\w\d\.\-_]"
    #$EventArg.Handled = (($EventArg.KeyChar -notmatch $ValidChars) -and ([Int]($EventArg.KeyChar) -notin (3, 8, 22, 24)))

  Write-Verbose -Message "Exit KeyPress Event for `$FCGMainPrefixTextBox"
}
#endregion ******** Function Start-FCGMainPrefixTextBoxKeyPress ********
$FCGMainPrefixTextBox.add_KeyPress({Start-FCGMainPrefixTextBoxKeyPress -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGMainPrefixTextBoxKeyUp ********
function Start-FCGMainPrefixTextBoxKeyUp
{
  <#
    .SYNOPSIS
      KeyUp Event for the FCGMainPrefix TextBox Control
    .DESCRIPTION
      KeyUp Event for the FCGMainPrefix TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the KeyUp Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox KeyUp Event
    .EXAMPLE
       Start-FCGMainPrefixTextBoxKeyUp -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyUp Event for `$FCGMainPrefixTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  $Sender.Tag.HintEnabled = ($Sender.Text.Trim().Length -eq 0)

  Write-Verbose -Message "Exit KeyUp Event for `$FCGMainPrefixTextBox"
}
#endregion ******** Function Start-FCGMainPrefixTextBoxKeyUp ********
$FCGMainPrefixTextBox.add_KeyUp({Start-FCGMainPrefixTextBoxKeyUp -Sender $This -EventArg $PSItem})

#region ******** Function Start-FCGMainPrefixTextBoxLostFocus ********
function Start-FCGMainPrefixTextBoxLostFocus
{
  <#
    .SYNOPSIS
      LostFocus Event for the FCGMainPrefix TextBox Control
    .DESCRIPTION
      LostFocus Event for the FCGMainPrefix TextBox Control
    .PARAMETER Sender
       The TextBox Control that fired the LostFocus Event
    .PARAMETER EventArg
       The Event Arguments for the TextBox LostFocus Event
    .EXAMPLE
       Start-FCGMainPrefixTextBoxLostFocus -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By kensw
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TextBox]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter LostFocus Event for `$FCGMainPrefixTextBox"

  [MyConfig]::AutoExit = 0

  # $TextBox.Tag = @{ "HintText" = ""; "HintEnabled" = $True }
  if ([String]::IsNullOrEmpty(($Sender.Text.Trim())))
  {
    $Sender.Text = $Sender.Tag.HintText
    $Sender.Tag.HintEnabled = $True
    $Sender.Font = [MyConfig]::Font.Hint
    $Sender.ForeColor = [MyConfig]::Colors.TextHint
  }
  else
  {
    $Sender.Tag.HintEnabled = $False
    $Sender.Font = [MyConfig]::Font.Regular
    $Sender.ForeColor = [MyConfig]::Colors.TextFore
  }

  Write-Verbose -Message "Exit LostFocus Event for `$FCGMainPrefixTextBox"
}
#endregion ******** Function Start-FCGMainPrefixTextBoxLostFocus ********
$FCGMainPrefixTextBox.add_LostFocus({Start-FCGMainPrefixTextBoxLostFocus -Sender $This -EventArg $PSItem})

$FCGMainPrefixGroupBox.ClientSize = [System.Drawing.Size]::New(($($FCGMainPrefixGroupBox.Controls[$FCGMainPrefixGroupBox.Controls.Count - 1]).Right + [MyConfig]::FormSpacer), ($($FCGMainPrefixGroupBox.Controls[$FCGMainPrefixGroupBox.Controls.Count - 1]).Bottom + [MyConfig]::FormSpacer))

#endregion ******** $FCGMainPrefixGroupBox Controls ********

#endregion ******** $FCGMainSplitContainer Panel1 Controls ********

# ************************************************
# $FCGMainSplitContainer Panel2 Controls - Code
# ************************************************
#region ******** $FCGMainSplitContainer Panel2 Controls ********

$FCGMainSplitContainer.Panel2.Padding = [System.Windows.Forms.Padding]::New(0, 0, [MyConfig]::FormSpacer, 0)

# ************************************************
# FCGMainCode GroupBox
# ************************************************
#region $FCGMainCodeGroupBox = [System.Windows.Forms.GroupBox]::New()
$FCGMainCodeGroupBox = [System.Windows.Forms.GroupBox]::New()
# Location of First Control = [System.Drawing.Point]::New([MyConfig]::FormSpacer, [MyConfig]::Font.Height)
$FCGMainSplitContainer.Panel2.Controls.Add($FCGMainCodeGroupBox)
$FCGMainCodeGroupBox.BackColor = [MyConfig]::Colors.Back
$FCGMainCodeGroupBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGMainCodeGroupBox.Enabled = $True
$FCGMainCodeGroupBox.Font = [MyConfig]::Font.s
$FCGMainCodeGroupBox.ForeColor = [MyConfig]::Colors.GroupFore
$FCGMainCodeGroupBox.Name = "FCGMainCodeGroupBox"
$FCGMainCodeGroupBox.TabStop = $False
$FCGMainCodeGroupBox.Tag = $Nulls
$FCGMainCodeGroupBox.Text = "My Generated Form Code"
$FCGMainCodeGroupBox.Visible = $True
#endregion $FCGMainCodeGroupBox = [System.Windows.Forms.GroupBox]::New()

#region ******** $FCGMainCodeGroupBox Controls ********

#region $FCGMainCodeTextBox = [System.Windows.Forms.TextBox]::New()
$FCGMainCodeTextBox = [System.Windows.Forms.TextBox]::New()
$FCGMainCodeGroupBox.Controls.Add($FCGMainCodeTextBox)
$FCGMainCodeTextBox.BackColor = [MyConfig]::Colors.TextBack
$FCGMainCodeTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$FCGMainCodeTextBox.Enabled = $True
$FCGMainCodeTextBox.Font = [System.Drawing.Font]::New("Courier New", [MyConfig]::FontSize, [System.Drawing.FontStyle]::Regular)
$FCGMainCodeTextBox.ForeColor = [MyConfig]::Colors.TextFore
$FCGMainCodeTextBox.Multiline = $True
$FCGMainCodeTextBox.Name = "FCGMainCodeTextBox"
$FCGMainCodeTextBox.ReadOnly = $True
$FCGMainCodeTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$FCGMainCodeTextBox.TabStop = $True
$FCGMainCodeTextBox.Tag = $Null
$FCGMainCodeTextBox.Text = $Null
$FCGMainCodeTextBox.Visible = $True
$FCGMainCodeTextBox.WordWrap = $False
#endregion $FCGMainCodeTextBox = [System.Windows.Forms.TextBox]::New()

#endregion ******** $FCGMainCodeGroupBox Controls ********

#endregion ******** $FCGMainSplitContainer Panel2 Controls ********


# ************************************************
# FCGTop MenuStrip
# ************************************************
#region $FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()
$FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()
$FCGForm.Controls.Add($FCGTopMenuStrip)
$FCGForm.MainMenuStrip = $FCGTopMenuStrip
$FCGTopMenuStrip.BackColor = [MyConfig]::Colors.Back
$FCGTopMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Top
$FCGTopMenuStrip.Enabled = $True
$FCGTopMenuStrip.Font = [MyConfig]::Font.Regular
$FCGTopMenuStrip.ForeColor = [MyConfig]::Colors.Fore
$FCGTopMenuStrip.ImageList = $FCGImageList
$FCGTopMenuStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
$FCGTopMenuStrip.Name = "FCGTopMenuStrip"
$FCGTopMenuStrip.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
$FCGTopMenuStrip.ShowItemToolTips = $False
$FCGTopMenuStrip.TabStop = $False
$FCGTopMenuStrip.Visible = $True
#endregion $FCGTopMenuStrip = [System.Windows.Forms.MenuStrip]::New()

$FCGTopMenuStripItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "FCG" -Name "FCG" -Tag "FCG" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru

#region Function Start-FCGTopMenuStripItemClick
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
    "ControlOnly"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "ControlCustom"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "FormPanel"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "FormSplit"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "ControlEvents"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "EncodeImage"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "ExtractIcon"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "EncodeFile"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "CommonFunctions"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "WindowsAPIs"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "RunSpacePools"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "SourceCode"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "PlaceHolder"
    {
      $FCGBtmStatusStrip.Items["Status"].Text = $Sender.Name
      Break
    }
    "Help"
    {
      Show-MyHelpDialog
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
#endregion Function Start-FCGTopMenuStripItemClick

#region ---- FCG Main Menu Items ----

(New-MenuItem -Menu $FCGTopMenuStrip -Text "E&xit" -Name "Exit" -Tag "Exit" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "ExitIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $FCGTopMenuStrip -Text "&Help" -Name "Help" -Tag "Help" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "HelpIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

$TmpMenuItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "Library" -Name "Library" -Tag "Library" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru
$TmpMenuItem.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
$TmpMenuItem.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No
(New-MenuItem -Menu $TmpMenuItem -Text "Common Functions" -Name "CommonFunctions" -Tag "CommonFunctions" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Windows APIs" -Name "WindowsAPIs" -Tag "WindowsAPIs" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "RunSpace Pools" -Name "RunSpacePools" -Tag "RunSpacePools" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Source Code" -Name "SourceCode" -Tag "SourceCode" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

$TmpMenuItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "Custom Dialogs" -Name "CustomDialogs" -Tag "CustomDialogs" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru
$TmpMenuItem.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
$TmpMenuItem.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No
(New-MenuItem -Menu $TmpMenuItem -Text "Place Holder" -Name "PlaceHolder" -Tag "PlaceHolder" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Place Holder" -Name "PlaceHolder" -Tag "PlaceHolder" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Place Holder" -Name "PlaceHolder" -Tag "PlaceHolder" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

$TmpMenuItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "Encode Data" -Name "EncodeData" -Tag "EncodeData" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru
$TmpMenuItem.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
$TmpMenuItem.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No
(New-MenuItem -Menu $TmpMenuItem -Text "Encode Image" -Name "EncodeImage" -Tag "EncodeImage" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Extract Icon" -Name "ExtractIcon" -Tag "ExtractIcon" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Encode File" -Name "EncodeFile" -Tag "EncodeFile" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

$TmpMenuItem = New-MenuItem -Menu $FCGTopMenuStrip -Text "Generate Code" -Name "GenerateCode" -Tag "GenerateCode" -DisplayStyle "ImageAndText" -TextImageRelation "TextBeforeImage" -ImageKey "FCGFormIcon" -PassThru
$TmpMenuItem.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
$TmpMenuItem.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No
(New-MenuItem -Menu $TmpMenuItem -Text "Control Only" -Name "ControlOnly" -Tag "ControlOnly" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Control with Customizations" -Name "ControlCustom" -Tag "ControlCustom" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Form GUI with Panel" -Name "FormPanel" -Tag "FormPanel" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $TmpMenuItem -Text "Form GUI with SplitContainer" -Name "FormSplit" -Tag "FormSplit" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})
New-MenuSeparator -Menu $TmpMenuItem
(New-MenuItem -Menu $TmpMenuItem -Text "Control Events" -Name "ControlEvents" -Tag "ControlEvents" -DisplayStyle "ImageAndText" -ImageKey "FCGFormIcon" -PassThru).add_Click({Start-FCGTopMenuStripItemClick -Sender $This -EventArg $PSItem})

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
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Status Dialog 01"
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
      }
      Else
      {
        # Failed
        $FCGBtmStatusStrip.Items["Status"].Text = "Failed Status Dialog 02"
      }
      #endregion Show Status Dialog 02
      Break
    }
    "UserAlert01"
    {
      #region Show User Alert 01
      $FCGBtmStatusStrip.Items["Status"].Text = "Show User Alert 01"
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

$FCGTopMenuStripItem.DropDownDirection = [System.Windows.Forms.ToolStripDropDownDirection]::BelowRight
$FCGTopMenuStripItem.DropDown.RightToLeft = [System.Windows.Forms.RightToLeft]::No
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

#endregion ==== FCG Main Menu Items ====

# ************************************************
# FCGBtm StatusStrip
# ************************************************
#region $FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
$FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()
$FCGForm.Controls.Add($FCGBtmStatusStrip)
$FCGBtmStatusStrip.BackColor = [MyConfig]::Colors.Back
$FCGBtmStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
$FCGBtmStatusStrip.Enabled = $True
$FCGBtmStatusStrip.Font = [MyConfig]::Font.Regular
$FCGBtmStatusStrip.ForeColor = [MyConfig]::Colors.Fore
$FCGBtmStatusStrip.ImageList = $FCGImageList
$FCGBtmStatusStrip.ImageScalingSize = [System.Drawing.Size]::New(16, 16)
$FCGBtmStatusStrip.Name = "FCGBtmStatusStrip"
$FCGBtmStatusStrip.ShowItemToolTips = $False
$FCGBtmStatusStrip.SizingGrip = $True
$FCGBtmStatusStrip.TabStop = $False
$FCGBtmStatusStrip.Visible = $True
#endregion $FCGBtmStatusStrip = [System.Windows.Forms.StatusStrip]::New()

New-MenuLabel -Menu $FCGBtmStatusStrip -Text "Status" -Name "Status" -Tag "Status"

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
$FCGFormComponents.Dispose()
$FCGForm.Dispose()
# *********************
# Add Form Code here...
# *********************

#endregion ******** Start Form  ********

if ([MyConfig]::Production)
{
  [System.Environment]::Exit(0)
}
