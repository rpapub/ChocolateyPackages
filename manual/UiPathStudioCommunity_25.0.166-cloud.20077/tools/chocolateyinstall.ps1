
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.uipath.com/versions/25.0.166-cloud.20077/UiPathStudioCommunity.msi'
$url64 = ''

$pp = Get-PackageParameters

# Set defaults and parse user-provided package parameters
$addLocal        = $pp['ADDLOCAL']        ?: 'DesktopFeature,Studio,Robot,RegisterService'
$nugetOptions    = $pp['NUGET_OPTIONS']
$packagesFolder  = $pp['PACKAGES_FOLDER']
$clientId        = $pp['CLIENT_ID']
$clientSecret    = $pp['CLIENT_SECRET']
$serviceUrl      = $pp['SERVICE_URL']
$orchestratorUrl = $pp['ORCHESTRATOR_URL']
$telemetry       = $pp['TELEMETRY_ENABLED']
$enablePip       = $pp['ENABLE_PIP']

$silentArgs = "/Q /norestart"

if ($nugetOptions)    { $silentArgs += " NUGET_OPTIONS=$nugetOptions" }
if ($packagesFolder)  { $silentArgs += " PACKAGES_FOLDER=`"$packagesFolder`"" }
if ($clientId)        { $silentArgs += " CLIENT_ID=$clientId" }
if ($clientSecret)    { $silentArgs += " CLIENT_SECRET=$clientSecret" }
if ($serviceUrl)      { $silentArgs += " SERVICE_URL=`"$serviceUrl`"" }
if ($orchestratorUrl) { $silentArgs += " ORCHESTRATOR_URL=`"$orchestratorUrl`"" }
if ($telemetry)       { $silentArgs += " TELEMETRY_ENABLED=$telemetry" }
if ($enablePip)       { $silentArgs += " ENABLE_PIP=$enablePip" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  url64bit       = $url64

  softwareName   = 'UiPath Studio Community'

  checksum       = ''
  checksumType   = 'sha256'
  checksum64     = ''
  checksumType64 = 'sha256'

  silentArgs     = $silentArgs
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

















