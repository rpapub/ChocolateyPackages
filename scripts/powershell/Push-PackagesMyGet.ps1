# Parse command-line arguments
param (
    [string]$productName,
    [string]$target
)

# Load the .env file
$envFile = ".env"
if (Test-Path $envFile) {
    $envConfig = Get-Content $envFile | ForEach-Object {
        if ($_ -match '\s*([^=]+)\s*=\s*(.+)') {
            Set-Item -Path "env:\$($Matches[1])" -Value $Matches[2]
        }
    }
}
else {
    Write-Error "Error: .env file not found."
    exit 1
}

# Check if the required environment variables are set
if (-not (Test-Path env:API_KEY_MYGET)) {
    Write-Error "Error: API_KEY_MYGET environment variable not set."
    exit 1
}

# Define the target URLs
$targets = @{
    dev  = "https://www.myget.org/F/project-basturma-chocolatey-alpha/api/v2/package"
    prod = "https://www.myget.org/F/project-basturma-chocolatey-packages/api/v2/package"
}

# Check if the target is valid
if (-not $targets.ContainsKey($target)) {
    Write-Error "Error: Invalid target specified. Available targets: $($targets.Keys -join ', ')"
    exit 1
}

# Convert productName to lowercase for consistent casing
$productNameLowerCase = $productName.ToLower()

# Push the packages for the specified product name to the target
$packageFiles = Get-ChildItem -Path "." -Filter "$productNameLowerCase*.nupkg" -Recurse
foreach ($packageFile in $packageFiles) {
    nuget push $packageFile.FullName $env:API_KEY_MYGET -Source $targets[$target]
}
