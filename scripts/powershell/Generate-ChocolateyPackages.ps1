param (
    [Parameter(Mandatory = $true)]
    [string]$productName
)

function Generate-ChocolateyPackages {
    # Define the repository URL
    $repositoryUrl = 'https://github.com/rpapub/ChocolateyPackages/blob/main'
    # Convert to lowercase and remove non-alphabetic characters
    $packageId = $productName.ToLower() -replace "[^a-z]"

    # Define paths
    $csvPath = ".\data\${productName}.csv"
    $templateDir = ".\templates\${productName}"
    $outputDir = ".\manual"

    # Read CSV file
    $versions = Import-Csv $csvPath

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
        $readmeFile = Join-Path -Path $versionDir -ChildPath "README.md"

        # Skip creating directories if they already exist
        if (-not (Test-Path $versionDir)) {
            # Create version-specific directories
            $null = New-Item -Path $versionDir -ItemType Directory -Force
            $null = New-Item -Path $toolsDir -ItemType Directory -Force

            # Copy template files
            Copy-Item -Path "$templateDir\${productName}.nuspec" -Destination $nuspecFile -Force
            Copy-Item -Path "$templateDir\chocolateyinstall.ps1" -Destination $installScript -Force
            Copy-Item -Path "$templateDir\README.md" -Destination $readmeFile -Force

            # Define the URL path for uipathstudio.nuspec
            $sanitizedOutputDir = $outputDir -replace '\\', '/'
            $relativePath = "${productName}_$versionNumber/${productName}.nuspec"
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
                $_ -replace '{PRODUCTNAME_PLACEHOLDER}', $productName `
                    -replace '{VERSION_PLACEHOLDER}', $versionNumber `
                    -replace '{NUGET_PACKAGEID_PLACEHOLDER}', "$packageId"
            } | Set-Content $readmeFile
        }
    }
}

# Call the function with the provided product name
Generate-ChocolateyPackages -productName $productName
