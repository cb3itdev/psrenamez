@echo off
SET scrptloc=%~dp0
SET rscript="%scrptloc%renamez.ps1"
SET filepath=%1
powershell.exe -ExecutionPolicy ByPass -file %rscript% %filepath%
pause
