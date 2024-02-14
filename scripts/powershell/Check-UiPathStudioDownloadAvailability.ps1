# Define base URL and product name
$baseURL = "https://download.uipath.com/versions"
$productName = "UiPathStudioCommunity"

# Explicitly set major, minor, and patch levels
$majorVersions = @(20, 21, 22, 23, 24) # Explicit list of major versions
$minorVersions = @(4, 10) # Only include minor versions 4 and 10
$patchLevels = @("", ".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9", ".10", ".11", ".12") # Explicit list of patch levels

# Find the lowest major version and initialize the fallback year with it added to 2000
$lowestMajorVersion = [Linq.Enumerable]::Min([int[]]$majorVersions)
$initialYear = 2000 + $lowestMajorVersion
$fallbackYear = $initialYear

# Initialize the list to store output data
$outputData = @()

# Generate URLs and collect data
foreach ($majorVersion in $majorVersions) {
    foreach ($minorVersion in $minorVersions) {
        foreach ($patchLevel in $patchLevels) {
            $version = "$majorVersion.$minorVersion$patchLevel"
            $url = "$baseURL/$version/$productName.msi"
            try {
                # Make a HEAD request
                $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
                
                # Proceed only if the status code is 200
                if ($response.StatusCode -eq 200) {
                    $lastModified = $response.Headers["Last-Modified"]
                    
                    # Try to parse the Last-Modified date to get the year
                    if ($lastModified) {
                        $parsedDate = [datetime]::Parse($lastModified)
                        $lastModifiedYear = $parsedDate.Year
                        $fallbackYear = $lastModifiedYear # Update fallback year with the last successful year
                    }
                    else {
                        $lastModifiedYear = $fallbackYear # Use fallback year
                    }

                    # Add data to output list
                    $outputData += [PSCustomObject]@{
                        Version          = $version
                        VersionedURL     = $url
                        LastModifiedYear = $lastModifiedYear
                    }
                }
            }
            catch {
                # If the request fails or the status code is not 200, do not add to output
            }
        }
    }
}

# Output the data to a CSV file
$outputData | Export-Csv -Path ".\data\UiPathStudioCommunity.csv" -NoTypeInformation

Write-Host "CSV file has been created: .\data\UiPathStudioCommunity.csv"



<#

https://download.uipath.com/versions/20.4.1/UiPathStudio.msi
https://download.uipath.com/versions/20.4.3/UiPathStudio.msi
https://download.uipath.com/versions/20.4.4/UiPathStudio.msi
https://download.uipath.com/versions/20.4.5/UiPathStudio.msi
https://download.uipath.com/versions/20.10.0/UiPathStudio.msi
https://download.uipath.com/versions/20.10.2/UiPathStudio.msi
https://download.uipath.com/versions/20.10.3/UiPathStudio.msi
https://download.uipath.com/versions/20.10.4/UiPathStudio.msi
https://download.uipath.com/versions/20.10.6/UiPathStudio.msi
https://download.uipath.com/versions/20.10.7/UiPathStudio.msi
https://download.uipath.com/versions/20.10.8/UiPathStudio.msi
https://download.uipath.com/versions/20.10.9/UiPathStudio.msi
https://download.uipath.com/versions/20.10.10/UiPathStudio.msi
https://download.uipath.com/versions/20.10.11/UiPathStudio.msi
https://download.uipath.com/versions/20.10.12/UiPathStudio.msi
https://download.uipath.com/versions/20.10.13/UiPathStudio.msi
https://download.uipath.com/versions/20.10.14/UiPathStudio.msi
https://download.uipath.com/versions/20.10.15/UiPathStudio.msi
https://download.uipath.com/versions/21.4.3/UiPathStudio.msi
https://download.uipath.com/versions/21.4.4/UiPathStudio.msi
https://download.uipath.com/versions/21.4.5/UiPathStudio.msi
https://download.uipath.com/versions/21.4.6/UiPathStudio.msi
https://download.uipath.com/versions/21.10.0/UiPathStudio.msi
https://download.uipath.com/versions/21.10.2/UiPathStudio.msi
https://download.uipath.com/versions/21.10.3/UiPathStudio.msi
https://download.uipath.com/versions/21.10.4/UiPathStudio.msi
https://download.uipath.com/versions/21.10.5/UiPathStudio.msi
https://download.uipath.com/versions/21.10.6/UiPathStudio.msi
https://download.uipath.com/versions/21.10.7/UiPathStudio.msi
https://download.uipath.com/versions/21.10.8/UiPathStudio.msi
https://download.uipath.com/versions/21.10.9/UiPathStudio.msi
https://download.uipath.com/versions/21.10.10/UiPathStudio.msi
https://download.uipath.com/versions/22.4.0/UiPathStudio.msi
https://download.uipath.com/versions/22.4.1/UiPathStudio.msi
https://download.uipath.com/versions/22.4.3/UiPathStudio.msi
https://download.uipath.com/versions/22.4.4/UiPathStudio.msi
https://download.uipath.com/versions/22.4.5/UiPathStudio.msi
https://download.uipath.com/versions/22.4.6/UiPathStudio.msi
https://download.uipath.com/versions/22.4.7/UiPathStudio.msi
https://download.uipath.com/versions/22.4.8/UiPathStudio.msi
https://download.uipath.com/versions/22.4.9/UiPathStudio.msi
https://download.uipath.com/versions/22.10.1/UiPathStudio.msi
https://download.uipath.com/versions/22.10.2/UiPathStudio.msi
https://download.uipath.com/versions/22.10.3/UiPathStudio.msi
https://download.uipath.com/versions/22.10.4/UiPathStudio.msi
https://download.uipath.com/versions/22.10.5/UiPathStudio.msi
https://download.uipath.com/versions/22.10.7/UiPathStudio.msi
https://download.uipath.com/versions/22.10.8/UiPathStudio.msi
https://download.uipath.com/versions/22.10.9/UiPathStudio.msi
https://download.uipath.com/versions/22.10.10/UiPathStudio.msi
https://download.uipath.com/versions/22.10.11/UiPathStudio.msi
https://download.uipath.com/versions/22.10.12/UiPathStudio.msi
https://download.uipath.com/versions/22.10.13/UiPathStudio.msi
https://download.uipath.com/versions/23.4/UiPathStudio.msi
https://download.uipath.com/versions/23.4.0/UiPathStudio.msi
https://download.uipath.com/versions/23.4.1/UiPathStudio.msi
https://download.uipath.com/versions/23.4.2/UiPathStudio.msi
https://download.uipath.com/versions/23.4.3/UiPathStudio.msi
https://download.uipath.com/versions/23.4.4/UiPathStudio.msi
https://download.uipath.com/versions/23.4.5/UiPathStudio.msi
https://download.uipath.com/versions/23.4.6/UiPathStudio.msi
https://download.uipath.com/versions/23.4.7/UiPathStudio.msi
https://download.uipath.com/versions/23.10.0/UiPathStudio.msi
https://download.uipath.com/versions/23.10.1/UiPathStudio.msi
https://download.uipath.com/versions/23.10.2/UiPathStudio.msi
https://download.uipath.com/versions/23.10.3/UiPathStudio.msi
https://download.uipath.com/versions/23.10.4/UiPathStudio.msi

https://download.uipath.com/versions/21.10.0/UiPathStudioCommunity.msi
https://download.uipath.com/versions/21.10.2/UiPathStudioCommunity.msi
https://download.uipath.com/versions/21.10.3/UiPathStudioCommunity.msi
https://download.uipath.com/versions/21.10.4/UiPathStudioCommunity.msi
https://download.uipath.com/versions/21.10.5/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.4.0/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.4.1/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.4.3/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.4.4/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.10.1/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.10.2/UiPathStudioCommunity.msi
https://download.uipath.com/versions/22.10.3/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.4.0/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.4.1/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.4.2/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.10.0/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.10.1/UiPathStudioCommunity.msi
https://download.uipath.com/versions/23.10.2/UiPathStudioCommunity.msi
#>