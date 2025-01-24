Client Deployment Using PowerShell
Hello everyone! 👋

I wanted to share a PowerShell script I developed for automating the deployment and configuration of RustDesk clients. This script is particularly useful for environments where you need to manage remote access efficiently and with custom server configurations.

🎯 Features:
Automated Installation: Downloads and installs the latest RustDesk client silently.
Custom Configuration: Automatically configures rendezvous and relay servers.
Predefined Settings: Sets a custom password for secure remote access.
Version Control: Verifies if the latest version is installed before proceeding with updates.

🚀 How It Works:
Version Check: The script first checks if the installed version matches the desired one (1.3.7). If it does, the script exits to avoid unnecessary reinstallation.
Silent Installation: If the version differs, it downloads and installs RustDesk in the background.
Custom Server Setup: Configures the rendezvous and relay servers to match your infrastructure.
Password Definition: Sets a secure password for remote sessions.
Logging: Outputs logs to C:\Temp\rustdesk_install.log for easy troubleshooting.

💻 Requirements:
PowerShell 5.1 or higher.
Administrator privileges.
Access to your custom RustDesk servers.
