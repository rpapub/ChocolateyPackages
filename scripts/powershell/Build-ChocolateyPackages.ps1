param (
    [Parameter(Mandatory = $true)]
    [string]$productName
)

function Build-ChocolateyPackages {
    param (
        [string]$productName
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
    $packageDirs = Get-ChildItem -Path $packageDir -Directory -Filter "${productName}_*"

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

# Call the function with the specified product name
Build-ChocolateyPackages -productName $productName
