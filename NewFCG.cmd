@Echo off

Set MyApp=NewFCG

"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy ByPass -File "%~dp0%MyApp%.ps1"

Pause