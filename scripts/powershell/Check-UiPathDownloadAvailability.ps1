param (
    [Parameter(Mandatory = $true)]
    [string]$productName,

    [Parameter(Mandatory = $false)]
    [int]$daysOld = 90
)

<#
.SYNOPSIS
Retrieve version information for UiPath Studio products from a specified URL and generate a CSV file containing the available versions within a specified timeframe.

.DESCRIPTION
This function retrieves version information for UiPath Studio products from a specified URL, filtering based on a cutoff date to consider only versions released within a specified timeframe. It iterates through possible major, minor, and patch versions, constructs URLs for each version, and sends HEAD requests to determine if the version exists and is accessible. If a version is found and falls within the specified timeframe, the version number, versioned URL, and last modified date are added to the output. The function then exports this version information to a CSV file.

.PARAMETER productName
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
Get-UiPathStudioVersionInfo -ProductName "UiPathStudioCommunity" -DaysOld 60
Retrieves version information for the UiPath Studio Community edition, considering versions released within the last 60 days.

.EXAMPLE
Get-UiPathStudioVersionInfo -ProductName "UiPathStudio" -DaysOld 8
Retrieves version information for the UiPath Studio product, considering versions released within the last 8 days.

#>
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
