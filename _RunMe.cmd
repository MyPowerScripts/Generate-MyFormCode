@Echo off

::Set MyApp=Generate_MyFormCode_5.0.0.4
Set MyApp=Generate_MyFormCode_6.0.0.4

::"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy ByPass -File "%~dp0%MyApp%.ps1"
"C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -ExecutionPolicy ByPass -File "%~dp0%MyApp%.ps1"

Pause