@echo off
powershell Set-ExecutionPolicy RemoteSigned

REM Validar si el archivo ya existe en %temp%
if exist "%temp%\rustdesk4.ps1" (
    del /f /q "%temp%\rustdesk4.ps1"
    echo Archivo existente eliminado.
)

REM Copiar el nuevo archivo
xcopy \\mavi02\ANTIVIRUS\rustdesk4.ps1 %temp% /Y

REM Ejecutar el archivo copiado con PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\rustdesk4.ps1"

