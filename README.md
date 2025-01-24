# **Client Deployment Using PowerShell**

Automate the deployment and configuration of **RustDesk clients** with this PowerShell-based solution. This script is ideal for environments requiring remote access management with custom server configurations and fallback mechanisms.

---

## **🎯 Features**
- **Automated Installation**: Downloads and installs the latest RustDesk client silently.
- **Custom Configuration**: Prepares the client to connect to your own rendezvous and relay servers.
- **Predefined Passwords**: Automatically sets a secure password for remote access.
- **Version Control**: Skips reinstallation if the desired version is already installed.
- **Fallback Mechanism**: Includes a `silentlycontinu.cmd` file to ensure compatibility with environments where PowerShell scripts cannot be executed directly.
- **Detailed Logs**: Generates log files for tracking the installation process.

---

## **🚀 How It Works**
1. **Version Check**: Determines if the installed version matches the desired version (`1.3.7`). If it does, the script exits to avoid redundant installations.
2. **Silent Installation**: Downloads and installs RustDesk in the background if an update is required.
3. **Server Configuration**: Configures the client to use your custom rendezvous and relay servers.
4. **Password Setup**: Automatically applies a predefined secure password for remote connections.
5. **Fallback Support**: Copies the included `silentlycontinu.cmd` file to the `%temp%` directory and executes it if `.ps1` files are restricted.

---

## **📄 Included Files**
- **`rustdesk_deployment.ps1`**: The main PowerShell script for automating installation and configuration.
- **`silentlycontinu.cmd`**: A fallback CMD file to ensure execution in restricted environments.

---

## **📋 Requirements**
- Windows with PowerShell 5.1 or higher.
- Administrator privileges.
- Internet access to download the RustDesk installer.
- Access to custom rendezvous and relay servers.

---

## **📆 Latest Update**
- **Last Updated**: January 23, 2025  

---

## **💬 Feedback & Contributions**
Your feedback is invaluable! If you encounter issues or have suggestions for improvements, feel free to:
1. Open an issue in this repository.
2. Submit a pull request with your proposed changes.

---

## **📜 License**
This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the script as needed.

---
