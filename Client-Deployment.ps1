$ErrorActionPreference = 'SilentlyContinue'

# Path to the log file
$logFile = "C:\Temp\rustdesk_install.log"

# Function to write to the log file
function Write-Log {
    param([string]$message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

# Predefined password
$rustdesk_pw2 = 'PASSWORD'

# Custom RustDesk configuration
$rustdesk_cfg = "rendezvous_server = 'DOMAIN/IP:21116' `nnat_type = 1`nserial = 0`n`n[options]`ncustom-rendezvous-server = 'DOMAIN/IP'`nkey = 'PUBLICKEY'`nwhitelist = '1.1.1.1,2.2.2.2,3.3.0.0/16'`ndirect-server = 'Y'`ndirect-access-port = '21118'"

# Log the start of the script
Write-Log "Starting script execution."

# Run as administrator if not already
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Log "Not running with administrator privileges. Attempting to run as administrator."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""; 
    Exit;
}

# Check the installed version of RustDesk
$rdver = ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk\").Version)

# Check if the latest version is already installed
if ($rdver -eq "1.3.7")
{
    Write-Log "RustDesk $rdver is the latest version."
    Exit
}

# Create a temporary directory if it doesn't exist
if (!(Test-Path C:\Temp))
{
    New-Item -ItemType Directory -Force -Path C:\Temp > $null
}

cd C:\Temp

# Download the installer file
Write-Log "Downloading RustDesk version 1.3.7."
Invoke-WebRequest "https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.exe" -Outfile "rustdesk.exe"

# Install RustDesk silently
Write-Log "Starting RustDesk installation."
Start-Process .\rustdesk.exe --silent-install
Start-Sleep -seconds 20

# Stop RustDesk service before applying configuration
Write-Log "Stopping RustDesk service..."
net stop rustdesk

# Get the current username
$username = ((Get-WMIObject -ClassName Win32_ComputerSystem).Username).Split('\')[1]

# Remove the previous configuration file and create a new one for the user
$UserConfigPath = "C:\Users\$username\AppData\Roaming\RustDesk\config\RustDesk2.toml"
Remove-Item $UserConfigPath -ErrorAction SilentlyContinue
New-Item $UserConfigPath -Force
Set-Content $UserConfigPath $rustdesk_cfg

# Remove the previous configuration file for the local service and create a new one
$LocalServiceConfigPath = "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml"
Remove-Item $LocalServiceConfigPath -ErrorAction SilentlyContinue
New-Item $LocalServiceConfigPath -Force
Set-Content $LocalServiceConfigPath $rustdesk_cfg

# Restart RustDesk service
Write-Log "Starting RustDesk service..."
net start rustdesk

Write-Log "RustDesk configured successfully."
# Set the password
Write-Log "Setting password."
Start-Process -FilePath ".\rustdesk.exe" -ArgumentList "--password "$rustdesk_pw2"" -Wait
Start-Sleep -seconds 20
Write-Log "Password: $rustdesk_pw2"

Write-Output "..............................................."
Write-Output "RustDesk configured successfully."
Write-Output "..............................................."


