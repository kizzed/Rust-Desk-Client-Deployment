@echo off
powershell Set-ExecutionPolicy RemoteSigned

REM Validate if the file already exists in %temp%
if exist "%temp%\rustdesk4.ps1" (
    del /f /q "%temp%\rustdesk4.ps1"
    echo Existing file deleted.
)

REM Copy the new file
xcopy \\you\route\file.ps1 %temp% /Y

REM Run the copied file with PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\rustdesk4.ps1"


