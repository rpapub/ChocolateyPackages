param (
    [Parameter(Mandatory = $true)]
    [string]$productName,

    [Parameter(Mandatory = $true)]
    [int]$daysOld
)

function Get-UiPathStudioVersionInfo {
    param (
        [string]$ProductName,
        [int]$DaysOld
    )

    $baseURL = "https://download.uipath.com/versions"
    $fileExtension = ".msi"

    $majorVersions = @(20, 21, 22, 23, 24)
    $minorVersions = @(4, 10)
    $patchLevels = @("", ".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9", ".10", ".11", ".12")

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

    $csvFilePath = ".\data\$ProductName.csv"
    $outputData | Export-Csv -Path $csvFilePath -NoTypeInformation

    $urlsFound = $outputData.Count
    Write-Host "CSV file has been created: $csvFilePath with $urlsFound URLs found."
}

# Call the function with the productName and daysOld parameters
Get-UiPathStudioVersionInfo -ProductName $productName -DaysOld $daysOld
