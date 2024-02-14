param (
    [Parameter(Mandatory = $true)]
    [string]$productName
)

<#
.SYNOPSIS
Generate Chocolatey packages for the specified product name using version information from a CSV file and templates.

.DESCRIPTION
This function automates the process of generating Chocolatey packages for a given product name. It reads version information from a CSV file and creates version-specific directories and files, including NuSpec files, chocolateyinstall.ps1 scripts, and README.md files. Placeholders in these files are replaced with version-specific information and package IDs. The function ensures that each version is processed only if it does not already have a corresponding directory in the output location.

.PARAMETER productName
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
function Generate-ChocolateyPackages {
    # Define the repository URL
    $repositoryUrl = 'https://github.com/rpapub/ChocolateyPackages/'

    # Define paths
    $csvPath = ".\data\${productName}.csv"
    $templateDir = ".\templates\${productName}"
    $outputDir = ".\manual"

    # Read CSV file
    $versions = Import-Csv $csvPath

    # Check if there are 2 or more lines in the CSV file
    if ($versions.Count -lt 2) {
        Write-Host "Exiting: No versions registered in the CSV file. At least one line besides the header required."
        exit 0
    }

    # Iterate over each version
    foreach ($version in $versions) {
        $versionNumber = $version.Version
        $versionedUrl = $version.VersionedURL
        $lastModifiedYear = $version.LastModifiedYear

        # Define version-specific directories and files
        $versionDir = Join-Path -Path $outputDir -ChildPath "${productName}_$versionNumber"
        $toolsDir = Join-Path -Path $versionDir -ChildPath "tools"
        $nuspecFile = Join-Path -Path $versionDir -ChildPath "${productName}.nuspec"
        $installScript = Join-Path -Path $toolsDir -ChildPath "chocolateyinstall.ps1"

        # Skip creating directories if they already exist
        if (-not (Test-Path $versionDir)) {
            # Create version-specific directories
            $null = New-Item -Path $versionDir -ItemType Directory -Force
            $null = New-Item -Path $toolsDir -ItemType Directory -Force

            # Copy template files
            Copy-Item -Path "$templateDir\${productName}.nuspec" -Destination $nuspecFile -Force
            Copy-Item -Path "$templateDir\chocolateyinstall.ps1" -Destination $installScript -Force

            # Define the URL path for uipathstudio.nuspec
            $sanitizedOutputDir = $outputDir -replace '\\', '/'
            $relativePath = "$versionNumber/${productName}.nuspec"
            $urlPath = "$sanitizedOutputDir/$relativePath"

            # Construct the complete URL
            $urlPath = $urlPath -replace '\./', ''
            $nuspecUrl = "$repositoryUrl$urlPath"

            # Replace placeholders in nuspec file
            (Get-Content $nuspecFile) | ForEach-Object {
                $_ -replace '{VERSION_PLACEHOLDER}', $versionNumber `
                    -replace '{COPYRIGHTYEAR_PLACEHOLDER}', "$lastModifiedYear" `
                    -replace '{PACKAGE_SOURCE_URL}', "$nuspecUrl"
            } | Set-Content $nuspecFile

            # Replace URL placeholder in chocolateyinstall.ps1
            (Get-Content $installScript) | ForEach-Object {
                $_ -replace '{URL_PLACEHOLDER}', $versionedUrl
            } | Set-Content $installScript
        }
    }
}

# Call the function with the provided product name
Generate-ChocolateyPackages -productName $productName
