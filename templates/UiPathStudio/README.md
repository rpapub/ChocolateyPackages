# {PRODUCTNAME_PLACEHOLDER} {VERSION_PLACEHOLDER}

Welcome to the {PRODUCTNAME_PLACEHOLDER} {VERSION_PLACEHOLDER} Chocolatey Package!

## About Chocolatey

[Chocolatey](https://chocolatey.org/) is a package manager for Windows that enables you to quickly and easily install, update, and manage software packages from the command line or via a GUI. It automates the process of software installation and configuration, making it a convenient tool for developers, sysadmins, and power users.

## Installation of Chocolatey

If you haven't already installed Chocolatey, you can do so by following the instructions on the [Chocolatey website](https://chocolatey.org/install).

## Installation of {PRODUCTNAME_PLACEHOLDER} {VERSION_PLACEHOLDER}

To install {PRODUCTNAME_PLACEHOLDER} {VERSION_PLACEHOLDER} using Chocolatey, follow these steps:

1. **Open Command Prompt as Administrator:** Right-click on the Command Prompt icon and select "Run as administrator" to open an elevated command prompt.

2. **Run the Chocolatey Installation Command:** Copy and paste the following command into the command prompt and press Enter:

   - For the **test** source:

     ```shell
     choco install {NUGET_PACKAGEID_PLACEHOLDER} --version {VERSION_PLACEHOLDER} --source https://www.myget.org/F/project-basturma-chocolatey-beta/api/v2
     ```

   - For the **prod** source:
     ```shell
     choco install {NUGET_PACKAGEID_PLACEHOLDER} --version {VERSION_PLACEHOLDER} --source https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2
     ```

   This command will instruct Chocolatey to download and install {PRODUCTNAME_PLACEHOLDER} version {VERSION_PLACEHOLDER}.

3. **Follow the Installation Wizard:** Once the installation command has completed, follow any on-screen prompts to complete the installation process.

## Uninstallation

To uninstall {PRODUCTNAME_PLACEHOLDER} {VERSION_PLACEHOLDER} using Chocolatey, run the following command in an elevated command prompt:

```shell
choco uninstall {NUGET_PACKAGEID_PLACEHOLDER} --version {VERSION_PLACEHOLDER}
```

Follow any on-screen prompts to complete the uninstallation process.

## Legal Information

- **Ownership:** {PRODUCTNAME_PLACEHOLDER} is a product developed and owned by UiPath Inc.

- **Licensing:** The use of {PRODUCTNAME_PLACEHOLDER} is subject to the terms and conditions of the [UiPath End User License Agreement (EULA)](https://www.uipath.com/legal/trust-center/eula).

- **Disclaimer:** This Chocolatey package is provided as-is without any warranties, express or implied. The maintainers of this package are not affiliated with UiPath Inc., and any issues or concerns related to the usage of {PRODUCTNAME_PLACEHOLDER} should be directed to UiPath's official support channels.

## Reporting Issues

If you encounter any issues or have suggestions for improvement, please [open an issue](https://github.com/rpapub/ChocolateyPackages/issues) on the GitHub repository. I welcome your feedback and will do our best to address any problems promptly.

## Additional Information

For more information about {PRODUCTNAME_PLACEHOLDER} or for troubleshooting tips, please refer to the [official UiPath documentation](https://docs.uipath.com/studio/).
