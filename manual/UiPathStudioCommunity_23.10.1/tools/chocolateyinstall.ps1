
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.uipath.com/versions/23.10.1/UiPathStudioCommunity.msi'
$url64 = ''

$pp = Get-PackageParameters

$silentArgs = "/Q /norestart"

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

















