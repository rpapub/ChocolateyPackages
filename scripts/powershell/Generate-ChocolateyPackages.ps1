param (
    [Parameter(Mandatory = $true)]
    [string]$productName
)

function Generate-ChocolateyPackages {
    # Define the repository URL
    $repositoryUrl = 'https://github.com/rpapub/ChocolateyPackages/'

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
