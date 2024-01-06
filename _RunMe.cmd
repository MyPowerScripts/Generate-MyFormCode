@Echo off

Set MyApp=Generate_MyFormCode_6.1.1.3

"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy ByPass -File "%~dp0%MyApp%.ps1"

::Pause