param (
    [Parameter(Mandatory = $true)]
    [string]$productName
)

function Get-UiPathStudioVersionInfo {
    param (
        [string]$ProductName
    )

    $baseURL = "https://download.uipath.com/versions"
    $fileExtension = ".msi" # File extension can be hardcoded

    $majorVersions = @(20, 21, 22, 23, 24) # Explicit list of major versions
    $minorVersions = @(4, 10) # Only include minor versions 4 and 10
    $patchLevels = @("", ".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9", ".10", ".11", ".12") # Explicit list of patch levels

    $lowestMajorVersion = [Linq.Enumerable]::Min([int[]]$majorVersions)
    $initialYear = 2000 + $lowestMajorVersion
    $fallbackYear = $initialYear

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
                            $fallbackYear = $lastModifiedYear
                        }
                        else {
                            $lastModifiedYear = $fallbackYear
                        }

                        $outputData += [PSCustomObject]@{
                            Version          = $version
                            VersionedURL     = $url
                            LastModifiedYear = $lastModifiedYear
                        }
                    }
                }
                catch {
                    # Handling exceptions or non-200 status codes by not adding to output
                }
            }
        }
    }

    $csvFilePath = ".\data\$ProductName.csv"
    $outputData | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Host "CSV file has been created: $csvFilePath"
}

# Call the function with the productName parameter
Get-UiPathStudioVersionInfo -ProductName $productName
