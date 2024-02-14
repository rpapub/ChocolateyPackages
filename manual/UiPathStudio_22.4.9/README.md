# UiPathStudio 22.4.9

Welcome to the UiPathStudio 22.4.9 Chocolatey Package!

## About Chocolatey

[Chocolatey](https://chocolatey.org/) is a package manager for Windows that enables you to quickly and easily install, update, and manage software packages from the command line or via a GUI. It automates the process of software installation and configuration, making it a convenient tool for developers, sysadmins, and power users.

## Installation of Chocolatey

If you haven't already installed Chocolatey, you can do so by following the instructions on the [Chocolatey website](https://chocolatey.org/install).

## Installation of UiPathStudio 22.4.9

To install UiPathStudio 22.4.9 using Chocolatey, follow these steps:

1. **Open Command Prompt as Administrator:** Right-click on the Command Prompt icon and select "Run as administrator" to open an elevated command prompt.

2. **Run the Chocolatey Installation Command:** Copy and paste the following command into the command prompt and press Enter:

   - For the **test** source:

     ```shell
     choco install uipathstudio --version 22.4.9 --source https://www.myget.org/F/project-basturma-chocolatey-beta/api/v2
     ```

   - For the **prod** source:
     ```shell
     choco install uipathstudio --version 22.4.9 --source https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2
     ```

   This command will instruct Chocolatey to download and install UiPathStudio version 22.4.9.

3. **Follow the Installation Wizard:** Once the installation command has completed, follow any on-screen prompts to complete the installation process.

## Uninstallation

To uninstall UiPathStudio 22.4.9 using Chocolatey, run the following command in an elevated command prompt:

```shell
choco uninstall uipathstudio --version 22.4.9
```

Follow any on-screen prompts to complete the uninstallation process.

## Legal Information

- **Ownership:** UiPathStudio is a product developed and owned by UiPath Inc.

- **Licensing:** The use of UiPathStudio is subject to the terms and conditions of the [UiPath End User License Agreement (EULA)](https://www.uipath.com/legal/trust-center/eula).

- **Disclaimer:** This Chocolatey package is provided as-is without any warranties, express or implied. The maintainers of this package are not affiliated with UiPath Inc., and any issues or concerns related to the usage of UiPathStudio should be directed to UiPath's official support channels.

## Reporting Issues

If you encounter any issues or have suggestions for improvement, please [open an issue](https://github.com/rpapub/ChocolateyPackages/issues) on the GitHub repository. I welcome your feedback and will do our best to address any problems promptly.

## Additional Information

For more information about UiPathStudio or for troubleshooting tips, please refer to the [official UiPath documentation](https://docs.uipath.com/studio/).
