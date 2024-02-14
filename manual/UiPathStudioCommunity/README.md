# UiPath Studio Chocolatey Package

This directory contains the necessary files for creating and using a Chocolatey package to install UiPath Studio. Chocolatey is a package manager that streamlines the installation process.

## Prerequisites

Before proceeding, ensure you have the following prerequisites:

1. **Chocolatey**: Chocolatey package manager must be installed on your system. You can download and install it from [Chocolatey's official website](https://chocolatey.org/).

## Installation Steps

Follow these steps to install UiPath Studio using Chocolatey:

1. Pack the Chocolatey package: Run the following command to pack the Chocolatey package:

   ```powershell
   cd '<path_to_directory>'
   choco pack
   ```

   This command creates a `.nupkg` file in the current directory. This file is used to install UiPath Studio using Chocolatey.

2. **Install UiPath Studio**: Run the Chocolatey installation command with the appropriate arguments to install UiPath Studio. Use the following command as a template and customize it as needed:

   ```powershell
   choco install uipathstudio -y --source '<path_to_directory>' --install-arguments="'Command Line Parameters'"
   ```

   - `-y`: Automatically confirms prompts.
   - `--source`: Specify the path to this directory.
   - `--install-arguments`: Include the installation arguments as specified in the [UiPath documentation](https://docs.uipath.com/studio/standalone/2021.10/user-guide/command-line-parameters).

   Example:

   ```powershell
   choco install uipathstudio -y --source 'D:\github.com\rpapub\ChocolateyPackages\manual\uipathstudio\' --install-arguments="'TELEMETRY_ENABLED=0'"

   choco install uipathstudio -y --source 'D:\github.com\rpapub\ChocolateyPackages\manual\uipathstudio\' --install-arguments="'TELEMETRY_ENABLED=0'" --verbose --debug

   choco install uipathstudio -y --source 'D:\github.com\rpapub\ChocolateyPackages\manual\uipathstudio\' --install-arguments="'ADDLOCAL=DesktopFeature,Studio,Robot,ExcelAddin,ChromeExtension,EdgeExtension ENABLE_PIP=1 TELEMETRY_ENABLED=0'"
   ```

3. **Wait for Installation**: Wait for the installation process to complete. It may take some time depending on your system's performance and the installation options selected.

4. **Launch UiPath Studio**: Once the installation is successful, you can launch UiPath Studio from the Start Menu.

## Uninstallation

To uninstall UiPath Studio, you can use the following Chocolatey command:

```powershell
choco uninstall uipathstudio
```
