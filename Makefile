SHELL := pwsh.exe
.SHELLFLAGS := -NoProfile -Command

rnd:
	.\scripts\powershell\Build-ChocolateyPackages -productName "UiPathStudioCommunity"
	.\scripts\powershell\Build-ChocolateyPackages -productName "UiPathStudio"

all:
	.\scripts\powershell\Check-UiPathDownloadAvailability.ps1 -productName "UiPathStudioCommunity"
	.\scripts\powershell\Check-UiPathDownloadAvailability.ps1 -productName "UiPathStudio"
	.\scripts\powershell\Generate-ChocolateyPackages.ps1 -productName "UiPathStudioCommunity"
	.\scripts\powershell\Generate-ChocolateyPackages.ps1 -productName "UiPathStudio"
	.\scripts\powershell\Build-ChocolateyPackages -productName "UiPathStudioCommunity"
	.\scripts\powershell\Build-ChocolateyPackages -productName "UiPathStudio"
	.\scripts\powershell\Push-PackagesMyGet.ps1 -productName "UiPathStudioCommunity" -target "test"
	.\scripts\powershell\Push-PackagesMyGet.ps1 -productName "UiPathStudio" -target "test"


