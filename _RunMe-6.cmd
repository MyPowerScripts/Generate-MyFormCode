@Echo off

Set MyApp=Generate-MyFormCode-6.1.1.4

"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy ByPass -File "%~dp0%MyApp%.ps1"

::Pause