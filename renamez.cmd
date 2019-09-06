@echo off
SET rscript="%~dpn0.ps1"
SET filepath=%1
powershell.exe -ExecutionPolicy ByPass -file %rscript% %filepath%
pause
