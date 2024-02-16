ifeq ($(OS),Windows_NT)
SHELL := pwsh.exe
else
SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

PRODUCT_NAME ?= UiPathStudioCommunity
DAYS_OLD ?= 9

IMPORT_CMD := Import-Module .\scripts\powershell\ChocolateyUiPathPackager\ChocolateyUiPathPackager.psd1 -Force -WarningAction SilentlyContinue;


.PHONY: getuipathversions createchocolateypackages buildchocolateypackages all clean


getuipathversions:
	@$(IMPORT_CMD) Get-UiPathVersions -ProductName '$(PRODUCT_NAME)' -DaysOld '$(DAYS_OLD)'

createchocolateypackages:
	@$(IMPORT_CMD) New-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

buildchocolateypackages:
	@$(IMPORT_CMD) Build-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

pushchocolateypackages:
	@$(IMPORT_CMD) Push-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

uipath: getuipathversions createchocolateypackages buildchocolateypackages pushchocolateypackages


clean:
	@Remove-Item -Path ".\data\*.csv" -Force -ErrorAction SilentlyContinue
	@Remove-Item -Path ".\builds\*" -Force -ErrorAction SilentlyContinue
	@Remove-Item -Path ".\manual\UiPathStudio_*" -Recurse -Force -ErrorAction SilentlyContinue
	@Remove-Item -Path ".\manual\UiPathStudioCommunity_*" -Recurse -Force -ErrorAction SilentlyContinue
