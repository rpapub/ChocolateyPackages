<#
.SYNOPSIS
Retrieve version information for UiPath products from a specified URL and generate a CSV file containing the available versions within a specified timeframe.

.DESCRIPTION
This function retrieves version information for UiPath products from a specified URL, filtering based on a cutoff date to consider only versions released within a specified timeframe. It iterates through possible major, minor, and patch versions, constructs URLs for each version, and sends HEAD requests to determine if the version exists and is accessible. If a version is found and falls within the specified timeframe, the version number, versioned URL, and last modified date are added to the output. The function then exports this version information to a CSV file.

.PARAMETER ProductName
The name of the product for which Chocolatey packages are generated. Tested with UiPathStudio and UiPathStudioCommunity.

.PARAMETER daysOld
The number of days to consider for filtering on newer versions of the product. Default is 90 days.

.NOTES
Version:        0.1.0
Author:         Christian Prior-Mamulyan
Creation Date:  2024-02-15
License:        CC-BY
Sourcecode:     https://github.com/rpapub

.EXAMPLE
Get-UiPathVersions -ProductName "UiPathStudioCommunity" -DaysOld 60
Retrieves version information for the UiPath Studio Community edition, considering versions released within the last 60 days.

.EXAMPLE
Get-UiPathVersions -ProductName "UiPathStudio" -DaysOld 8
Retrieves version information for the UiPath Studio product, considering versions released within the last 8 days.

#>
function Get-UiPathVersions {
    param (
        [string]$ProductName,
        [int]$DaysOld
    )

    $baseURL = "https://download.uipath.com/versions"
    $fileExtension = ".msi"

    $majorVersions = @(20, 21, 22, 23, 24, 25)

    $minorVersions = @(4, 10)
    $patchLevels = @("", ".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9", ".10", ".11", ".12", ".13", ".14", ".15", ".16", ".17", ".18")

    $currentDate = Get-Date
    $cutoffDate = $currentDate.AddDays(-$DaysOld)

    $outputData = @()

    foreach ($majorVersion in $majorVersions) {
        foreach ($minorVersion in $minorVersions) {
            foreach ($patchLevel in $patchLevels) {
                $version = "$majorVersion.$minorVersion$patchLevel"
                $url = "$baseURL/$version/$ProductName$fileExtension"
                try {
                    $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
                    
                    if ($response.StatusCode -eq 200) {
                        $lastModified = $response.Headers["Last-Modified"]
                        
                        if ($lastModified) {
                            $parsedDate = [datetime]::Parse($lastModified)
                            $lastModifiedYear = $parsedDate.Year

                            if ($parsedDate -gt $cutoffDate) {
                                $outputData += [PSCustomObject]@{
                                    Version      = $version
                                    VersionedURL = $url
                                    LastModified = $parsedDate.ToString("yyyy-MM-dd")
                                }
                            }
                        }
                    }
                }
                catch {
                    # Handling exceptions or non-200 status codes by not adding to output
                }
            }
        }
    }

    if ($outputData.Count -gt 0) {
        $csvFilePath = ".\data\$ProductName.csv"
        $outputData | Export-Csv -Path $csvFilePath -NoTypeInformation
        $urlsFound = $outputData.Count
        Write-Host "CSV file has been created: $csvFilePath with $urlsFound URLs found."
        exit 0
    }
    else {
        Write-Host "No URLs found for $ProductName within the last $DaysOld days."
        Write-Warning "FIXME exit 0 or exit 1?"
        exit 0
    }
}

<#
.SYNOPSIS
Generate Chocolatey packages for the specified product name using version information from a CSV file and templates.

.DESCRIPTION
This function automates the process of generating Chocolatey packages for a given product name. It reads version information from a CSV file and creates version-specific directories and files, including NuSpec files, chocolateyinstall.ps1 scripts, and README.md files. Placeholders in these files are replaced with version-specific information and package IDs. The function ensures that each version is processed only if it does not already have a corresponding directory in the output location.

.PARAMETER ProductName
Specifies the name of the product for which Chocolatey packages are generated.

.NOTES
Version:        0.1.0
Author:         Christian Prior-Mamulyan
Creation Date:  2024-02-15
License:        CC-BY
Sourcecode:     https://github.com/rpapub

.EXAMPLE
Generate-ChocolateyPackages -productName "UiPathStudioCommunity"
Generates Chocolatey packages for UiPath Studio Community editions.

#>
function New-ChocolateyPackages {
    param (
        [string]$ProductName
    )
    # Define the repository URL
    $repositoryUrl = 'https://github.com/rpapub/ChocolateyPackages/blob/main'
    # Convert to lowercase and remove non-alphabetic characters
    $packageId = $ProductName.ToLower() -replace "[^a-z]"

    # Define paths
    $csvPath = ".\data\${ProductName}.csv"
    $templateDir = ".\templates\${ProductName}"
    $outputDir = ".\manual"

    # Check if the CSV file exists
    if (-not (Test-Path $csvPath)) {
        Write-Host "Error: CSV file '$csvPath' not found. Exiting."
        exit 1
    }

    # Read CSV file
    $versions = Import-Csv $csvPath

    # Check if there are 2 or more lines in the CSV file
    if ($versions.Count -lt 1) {
        Write-Host "Exiting: No versions registered in the CSV file. At least one line besides the header required."
        exit 0
    }

    # Iterate over each version
    foreach ($version in $versions) {
        $versionNumber = $version.Version
        $versionedUrl = $version.VersionedURL
        $lastModifiedYear = $version.LastModifiedYear

        # Define version-specific directories and files
        $versionDir = Join-Path -Path $outputDir -ChildPath "${ProductName}_$versionNumber"
        $toolsDir = Join-Path -Path $versionDir -ChildPath "tools"
        $nuspecFile = Join-Path -Path $versionDir -ChildPath "${ProductName}.nuspec"
        $installScript = Join-Path -Path $toolsDir -ChildPath "chocolateyinstall.ps1"
        $readmeFile = Join-Path -Path $versionDir -ChildPath "README.md"
        $markerfile = Join-Path -Path $versionDir -ChildPath "BuildFlagFile.gitignore"

        # Skip creating directories if they already exist
        if (-not (Test-Path $versionDir)) {
            # Create version-specific directories
            $null = New-Item -Path $versionDir -ItemType Directory -Force
            $null = New-Item -Path $toolsDir -ItemType Directory -Force

            # Copy template files
            Copy-Item -Path "$templateDir\${ProductName}.nuspec" -Destination $nuspecFile -Force
            Copy-Item -Path "$templateDir\chocolateyinstall.ps1" -Destination $installScript -Force
            Copy-Item -Path "$templateDir\README.md" -Destination $readmeFile -Force
            Copy-Item -Path "$templateDir\..\marker" -Destination $markerfile -Force

            # Define the URL path for uipathstudio.nuspec
            $sanitizedOutputDir = $outputDir -replace '\\', '/'
            $relativePath = "${ProductName}_$versionNumber/${ProductName}.nuspec"
            $urlPath = "$sanitizedOutputDir/$relativePath"

            # Construct the complete URL
            $urlPath = $urlPath -replace '\./', ''
            $nuspecUrl = "$repositoryUrl/$urlPath"

            # Replace placeholders in nuspec file
            (Get-Content $nuspecFile) | ForEach-Object {
                $_ -replace '{VERSION_PLACEHOLDER}', $versionNumber `
                    -replace '{COPYRIGHTYEAR_PLACEHOLDER}', "$lastModifiedYear" `
                    -replace '{PACKAGE_SOURCE_URL}', "$nuspecUrl" `
                    -replace '{NUGET_PACKAGEID_PLACEHOLDER}', "$packageId"
            } | Set-Content $nuspecFile

            # Replace URL placeholder in chocolateyinstall.ps1
            (Get-Content $installScript) | ForEach-Object {
                $_ -replace '{URL_PLACEHOLDER}', $versionedUrl
            } | Set-Content $installScript

            # Replace URL placeholder in README.md
            (Get-Content $readmeFile) | ForEach-Object {
                $_ -replace '{PRODUCTNAME_PLACEHOLDER}', $ProductName `
                    -replace '{VERSION_PLACEHOLDER}', $versionNumber `
                    -replace '{NUGET_PACKAGEID_PLACEHOLDER}', "$packageId"
            } | Set-Content $readmeFile
        }
    }
}

<#
.SYNOPSIS
Builds Chocolatey packages for the specified product name.

.DESCRIPTION
This function builds Chocolatey packages for the specified product name. It searches for directories containing the product name in the 'manual' directory relative to the current location, packs each directory into a Chocolatey package using 'choco pack', and moves the resulting .nupkg files to the 'builds' directory.

.PARAMETER ProductName
The name of the product for which Chocolatey packages will be built.

.NOTES
Version:        0.1.0
Author:         Christian Prior-Mamulyan
Creation Date:  2024-02-15
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>

function Build-ChocolateyPackages {
    param (
        [string]$ProductName
    )

    # Set the root directory
    $rootDir = $PWD

    # Set the paths relative to the root directory
    $packageDir = Join-Path -Path $rootDir -ChildPath "manual"
    $buildsDir = Join-Path -Path $rootDir -ChildPath "builds"

    # Create the builds directory if it doesn't exist
    if (-not (Test-Path -Path $buildsDir)) {
        New-Item -Path $buildsDir -ItemType Directory
    }

    # Get the list of directories containing the specified product name
    $packageDirs = Get-ChildItem -Path $packageDir -Directory -Filter "${ProductName}_*"

    # Change into each directory, pack the Chocolatey package, and move the resulting nupkg file to buildsDir
    foreach ($dir in $packageDirs) {
        # Change into the directory
        Set-Location -Path $dir.FullName

        # Check if the nupkg file already exists in the builds directory
        $nupkgFileExists = Test-Path -Path (Join-Path -Path $buildsDir -ChildPath "$($dir.Name).nupkg")

        if (-not $nupkgFileExists) {
            # Run choco pack
            choco pack
            
            # Move the resulting nupkg files to buildsDir
            $nupkgFiles = Get-ChildItem -Path . -Filter "*.nupkg"
            foreach ($nupkgFile in $nupkgFiles) {
                Move-Item -Path $nupkgFile.FullName -Destination $buildsDir -Force
            }
        }
    }
}

function Build-ChocolateyPackage {
    param (
        [string]$ProductName,
        [string]$PackageLocation,
        [string]$BuildsDirectory  # This is relative to the Makefile, not PackageLocation
    )

    # Ensure the package location exists
    if (-not (Test-Path -Path $PackageLocation)) {
        Write-Error "Package location does not exist: $PackageLocation"
        exit 1
    }

    # Convert to an absolute path for the BuildsDirectory based on the current PWD
    $absoluteBuildsDir = Join-Path -Path (Get-Location) -ChildPath $BuildsDirectory

    # Ensure the builds directory exists, create it if it doesn't
    if (-not (Test-Path -Path $absoluteBuildsDir)) {
        New-Item -Path $absoluteBuildsDir -ItemType Directory | Out-Null
    }

    # Change directory to where the Chocolatey package spec (nuspec file) resides
    Push-Location -Path $PackageLocation

    # Check for the presence of a .nuspec file
    $nuspecFiles = Get-ChildItem -Path . -Filter "*.nuspec" -File
    if ($nuspecFiles.Count -eq 0) {
        Pop-Location
        Write-Error "No .nuspec file found in $PackageLocation"
        exit 1
    }

    try {
        # Run choco pack command in the current directory
        choco pack
        
        # Move the resulting nupkg file to the specified builds directory
        $nupkgFiles = Get-ChildItem -Path . -Filter "*.nupkg" -File
        foreach ($file in $nupkgFiles) {
            Move-Item -Path $file.FullName -Destination $absoluteBuildsDir -Force
        }
        Write-Host "Package for $ProductName built and moved to $absoluteBuildsDir"
    }
    catch {
        Write-Error "Failed to pack the Chocolatey package: $_"
        exit 1
    }
    finally {
        Pop-Location
    }
}

<#
.SYNOPSIS
Imports environment variables from the .env file in the current directory.

.DESCRIPTION
This function imports environment variables from the .env file in the current directory. It reads the .env file line by line, parsing each line to extract key-value pairs separated by an equal sign (=). It sets these key-value pairs as environment variables for the current session.

.NOTES
This function assumes that the .env file is formatted correctly, with one key-value pair per line and each pair separated by an equal sign.

.EXAMPLE
Import-EnvironmentVariables
Imports environment variables from the .env file in the current directory.

#>
function Import-EnvironmentVariables {
    $envVariables = @{}

    $envFile = ".env"
    if (Test-Path $envFile) {
        $envConfig = Get-Content $envFile | ForEach-Object {
            if ($_ -match '\s*([^=]+)\s*=\s*(.+)') {
                $envVariables[$Matches[1]] = $Matches[2]
            }
        }
    }
    else {
        Write-Error "Error: .env file not found."
        exit 1
    }

    return $envVariables
}

<#
.SYNOPSIS
Pushes Chocolatey packages for a specified product to a target repository.

.DESCRIPTION
This function pushes Chocolatey packages for a specified product to a target repository. It accepts the product name and an optional target parameter. If the target parameter is not provided, it defaults to "test". It loads environment variables, including the API key, and retrieves the target URL based on the specified target parameter. It then pushes the packages to the target repository using the NuGet CLI tool.

.PARAMETER ProductName
The name of the product for which Chocolatey packages will be pushed.

.PARAMETER target
The target repository to which the Chocolatey packages will be pushed. Default is "test".

.EXAMPLE
Push-ChocolateyPackages -productName "MyProduct" -target "prod"
Pushes Chocolatey packages for the product "MyProduct" to the production repository.

.EXAMPLE
Push-ChocolateyPackages -productName "MyProduct"
Pushes Chocolatey packages for the product "MyProduct" to the test repository (default target).

#>
function Push-ChocolateyPackages {
    param (
        [string]$ProductName,
        [string]$target = "test"
    )

    # Load environment variables
    $envVariables = Import-EnvironmentVariables

    # Define the target URLs
    $targets = @{
        dev  = "https://www.myget.org/F/project-basturma-chocolatey-alpha/api/v2/package"
        test = "https://www.myget.org/F/project-basturma-chocolatey-beta/api/v2/package"
        prod = "https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2/package"
    }

    # Check if the target is valid
    if (-not $targets.ContainsKey($target)) {
        Write-Error "Error: Invalid target specified. Available targets: $($targets.Keys -join ', ')"
        exit 1
    }

    # Convert ProductName to lowercase for consistent casing
    $productNameLowerCase = $ProductName.ToLower()

    # Push the packages for the specified product name to the target
    $packageFiles = Get-ChildItem -Path "./builds" -Filter "$productNameLowerCase.*.*.*.nupkg" -Recurse
    foreach ($packageFile in $packageFiles) {
        nuget push $packageFile.FullName $envVariables['MYGET_API_KEY'] -Source $targets[$target] -SkipDuplicate
    }
}

function Push-ChocolateyPackage {
    param (
        [string]$NupkgFile,  # Path to the .nupkg file to push
        [string]$TargetRepository = "test"
    )

    # Load environment variables
    $envVariables = Import-EnvironmentVariables

    # Define the target URLs
    $targets = @{
        dev  = "https://www.myget.org/F/project-basturma-chocolatey-alpha/api/v2/package"
        test = "https://www.myget.org/F/project-basturma-chocolatey-beta/api/v2/package"
        prod = "https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2/package"
    }

    # Check if the target is valid
    if (-not $targets.ContainsKey($TargetRepository)) {
        Write-Error "Error: Invalid target specified. Available targets: $($targets.Keys -join ', ')"
        exit 1
    }

    # Check if the .nupkg file exists
    if (Test-Path -Path $NupkgFile) {
        try {
            # Push the package to the target repository
            nuget push $NupkgFile -ApiKey $envVariables['MYGET_API_KEY'] -Source $targets[$TargetRepository] -SkipDuplicate
            Write-Host "Successfully pushed $(Split-Path $NupkgFile -Leaf) to the $TargetRepository repository."
        }
        catch {
            Write-Error "Failed to push the package due to an error: $_"
            exit 1
        }
    } else {
        Write-Error "Error: .nupkg file does not exist: $NupkgFile"
        exit 1
    }
}

