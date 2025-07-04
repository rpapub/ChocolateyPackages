# UiPathStudioCommunity 25.0.166-cloud.20077

Welcome to the UiPathStudioCommunity 25.0.166-cloud.20077 Chocolatey Package!

## About Chocolatey

[Chocolatey](https://chocolatey.org/) is a package manager for Windows that enables you to quickly and easily install, update, and manage software packages from the command line or via a GUI. It automates the process of software installation and configuration, making it a convenient tool for developers, sysadmins, and power users.

## Installation of Chocolatey

If you haven't already installed Chocolatey, you can do so by following the instructions on the [Chocolatey website](https://chocolatey.org/install).

## Installation of UiPathStudioCommunity 25.0.166-cloud.20077

To install UiPathStudioCommunity 25.0.166-cloud.20077 using Chocolatey, follow these steps:

1. **Open Command Prompt as Administrator:** Right-click on the Command Prompt icon and select "Run as administrator" to open an elevated command prompt.

2. **Run the Chocolatey Installation Command:** Copy and paste the following command into the command prompt and press Enter:

  - For the **test** source:

    ```shell
    choco install uipathstudiocommunity --version 25.0.166-cloud.20077 --source https://www.myget.org/F/project-basturma-chocolatey-beta/api/v2
    ```

  - For the **prod** source:
    ```shell
    choco install uipathstudiocommunity --version 25.0.166-cloud.20077 --source https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2
    ```

  This command will instruct Chocolatey to download and install UiPathStudioCommunity version 25.0.166-cloud.20077.

3. **Optionally configure installation:**

  You can pass installation parameters via `--params`. Example:

  ```shell
  choco install uipathstudiocommunity --version 25.0.166-cloud.20077 --params '"/ADDLOCAL=Studio,Robot /NUGET_OPTIONS=DisableOnlineFeeds /PACKAGES_FOLDER=C:\RPA\Packages /CLIENT_ID=abc /CLIENT_SECRET=xyz /SERVICE_URL=https://demo.uipath.com /ORCHESTRATOR_URL=https://demo.uipath.com/org/tenant /TELEMETRY_ENABLED=0 /ENABLE_PIP=1"'
  ```

Supported parameters:

* `ADDLOCAL`
* `NUGET_OPTIONS`
* `PACKAGES_FOLDER`
* `CLIENT_ID`
* `CLIENT_SECRET`
* `SERVICE_URL`
* `ORCHESTRATOR_URL`
* `TELEMETRY_ENABLED`
* `ENABLE_PIP`

## Uninstallation

To uninstall UiPathStudioCommunity 25.0.166-cloud.20077 using Chocolatey, run the following command in an elevated command prompt:

```shell
choco uninstall uipathstudiocommunity --version 25.0.166-cloud.20077
```

Follow any on-screen prompts to complete the uninstallation process.

## Legal Information

- **Ownership:** UiPathStudioCommunity is a product developed and owned by UiPath Inc.

- **Licensing:** The use of UiPathStudioCommunity is subject to the terms and conditions of the [UiPath End User License Agreement (EULA)](https://www.uipath.com/legal/trust-center/eula).

- **Disclaimer:** This Chocolatey package is provided as-is without any warranties, express or implied. The maintainers of this package are not affiliated with UiPath Inc., and any issues or concerns related to the usage of UiPathStudioCommunity should be directed to UiPath's official support channels.

## Reporting Issues

If you encounter any issues or have suggestions for improvement, please [open an issue](https://github.com/rpapub/ChocolateyPackages/issues) on the GitHub repository. I welcome your feedback and will do our best to address any problems promptly.

## Additional Information

For more information about UiPathStudioCommunity or for troubleshooting tips, please refer to the [official UiPath documentation](https://docs.uipath.com/studio/).
