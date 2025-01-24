$ErrorActionPreference = 'SilentlyContinue'

# Ruta del archivo de log
$logFile = "C:\Temp\rustdesk_install.log"

# Función para escribir en el archivo de log
function Write-Log {
    param([string]$message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

# Contraseña predefinida
$rustdesk_pw2 = 'PASSWORD'

# Configuración personalizada de RustDesk
$rustdesk_cfg = "rendezvous_server = 'DOMAIN/IP:21116' `nnat_type = 1`nserial = 0`n`n[options]`ncustom-rendezvous-server = 'DOMAIN/IP'`nkey = 'PUBLICKEY'`nwhitelist = '1.1.1.1,2.2.2.2,3.3.0.0/16'`ndirect-server = 'Y'`ndirect-access-port = '21118'"

# Registrar inicio de script
Write-Log "Inicio de la ejecución del script."

# Ejecutar como administrador si no lo es
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Log "No tiene privilegios de administrador. Intentando ejecutar como administrador."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""; 
    Exit;
}

# Verificar la versión de RustDesk instalada
$rdver = ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk\").Version)

# Comprobar si ya tienes la última versión
if ($rdver -eq "1.3.7")
{
    Write-Log "RustDesk $rdver es la versión más reciente."
    Exit
}

# Crear directorio temporal si no existe
if (!(Test-Path C:\Temp))
{
    New-Item -ItemType Directory -Force -Path C:\Temp > $null
}

cd C:\Temp

# Descargar el archivo de instalación
Write-Log "Descargando RustDesk versión 1.3.7."
Invoke-WebRequest "https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.exe" -Outfile "rustdesk.exe"

# Instalar RustDesk en modo silencioso
Write-Log "Iniciando instalación de RustDesk."
Start-Process .\rustdesk.exe --silent-install
Start-Sleep -seconds 20


# Detener el servicio de RustDesk antes de aplicar configuración
Write-Log "Deteniendo el servicio de RustDesk..."
net stop rustdesk

# Obtener el nombre de usuario actual
$username = ((Get-WMIObject -ClassName Win32_ComputerSystem).Username).Split('\')[1]

# Eliminar archivo de configuración anterior y crear uno nuevo para el usuario
$UserConfigPath = "C:\Users\$username\AppData\Roaming\RustDesk\config\RustDesk2.toml"
Remove-Item $UserConfigPath -ErrorAction SilentlyContinue
New-Item $UserConfigPath -Force
Set-Content $UserConfigPath $rustdesk_cfg

# Eliminar archivo de configuración anterior para el servicio local y crear uno nuevo
$LocalServiceConfigPath = "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml"
Remove-Item $LocalServiceConfigPath -ErrorAction SilentlyContinue
New-Item $LocalServiceConfigPath -Force
Set-Content $LocalServiceConfigPath $rustdesk_cfg

# Iniciar nuevamente el servicio de RustDesk
Write-Log "Iniciando el servicio de RustDesk..."
net start rustdesk

Write-Log "RustDesk configurado correctamente."
# Configurar contraseña
Write-Log "Definiendo contraseña."
Start-Process -FilePath ".\rustdesk.exe" -ArgumentList "--password "$rustdesk_pw2"" -Wait
Start-Sleep -seconds 20
Write-Log "Contraseña: $rustdesk_pw2"

Write-Output "..............................................."
Write-Output "RustDesk configurado correctamente.
Write-Output "..............................................."

