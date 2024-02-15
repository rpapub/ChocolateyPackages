# ChocolateyUiPathPackager PowerShell Module

## Overview

The ChocolateyUiPathPackager PowerShell module provides a set of cmdlets to automate the creation, management, and deployment of Chocolatey packages for UiPath Studio products. With this module, you can streamline the process of generating Chocolatey packages for different versions of UiPath Studio, manage environment variables, build packages, and push them to a target repository.

## Features

- **Get-UiPathStudioVersionInfo**: Retrieves version information for UiPath Studio products and generates a CSV file containing available versions.
- **Create-ChocolateyPackages**: Generates Chocolatey packages for specified UiPath Studio products using version information from a CSV file and templates.
- **Build-ChocolateyPackages**: Builds Chocolatey packages for specified UiPath Studio products.
- **Import-EnvironmentVariables**: Imports environment variables from a .env file in the current directory.
- **Push-ChocolateyPackages**: Pushes Chocolatey packages for specified UiPath Studio products to a target repository.

## Requirements

- Windows PowerShell 5.1 or later
- Chocolatey package manager
- NuGet CLI (for pushing packages)

## Installation

```powershell
# Install from the PowerShell Gallery (requires PowerShellGet)
Install-Module -Name ChocolateyUiPathPackager -Scope CurrentUser
```

## Usage

### Get-UiPathStudioVersionInfo

This function retrieves version information for UiPath Studio products from a specified URL and generates a CSV file containing the available versions within a specified timeframe.

```powershell
Get-UiPathStudioVersionInfo -ProductName "UiPathStudioCommunity" -DaysOld 60
```

### Create-ChocolateyPackages

Generate Chocolatey packages for the specified product name using version information from a CSV file and templates.

```powershell
Create-ChocolateyPackages -productName "UiPathStudioCommunity"
```

### Build-ChocolateyPackages

Build Chocolatey packages for the specified product name.

```powershell
Build-ChocolateyPackages -productName "UiPathStudioCommunity"
```

### Push-ChocolateyPackages

Push Chocolatey packages for a specified product to a target repository.

**Note:** Before using this function, ensure you have a valid API key for myget.org stored in a .env file with the key-value pair `API_KEY_MYGET=your_api_key`.

```powershell
Push-ChocolateyPackages -productName "UiPathStudioCommunity" -target "test"
```

## Contributing

Contributions to this PowerShell module are welcome! If you find any issues or have ideas for improvements, please submit them through the [GitHub repository](https://github.com/rpapub).

## License

This PowerShell module is licensed under the [CC-BY License](LICENSE).

## Source Code

The source code for this module can be found on [GitHub](https://github.com/rpapub).
