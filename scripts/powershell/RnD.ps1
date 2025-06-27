$baseUrl = "https://download.uipath.com/versions"
$products = @(
    "UiPathStudioCommunity",
    "UiPathStudio",
    "UiPathAssistant",
    "UiPathRobot",
    "UiPathStudioX"
)

$suffixes = @(
    "cloud",
    "enterprise",
    "suite",
    "lts",
    "community",
    ""  # no suffix
)

$major = 25
$minorRange = 0..1
$patchRange = 160..165
$buildRange = 20070..20075
$fileExtension = ".msi"

foreach ($product in $products) {
    Write-Host "`n🔍 Testing product: $product" -ForegroundColor Cyan

    foreach ($minor in $minorRange) {
        foreach ($patch in $patchRange) {
            foreach ($suffix in $suffixes) {
                foreach ($build in $buildRange) {
                    $version = if ($suffix -ne "") {
                        "$major.$minor.$patch-$suffix.$build"
                    } else {
                        "$major.$minor.$patch.$build"
                    }

                    $url = "$baseUrl/$version/$product$fileExtension"

                    try {
                        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
                        if ($response.StatusCode -eq 200) {
                            Write-Host "✅ Found: $product $version"
                            Write-Host "    $url"
                        }
                    } catch {
                        # skip silently
                    }

                    Start-Sleep -Milliseconds 100
                }
            }
        }
    }
}
