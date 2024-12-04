ifeq ($(OS),Windows_NT)
SHELL := pwsh.exe
else
SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

PRODUCT_NAME ?= UiPathStudioCommunity
DAYS_OLD ?= 33

IMPORT_CMD := Import-Module .\scripts\powershell\ChocolateyUiPathPackager\ChocolateyUiPathPackager.psd1 -Force -WarningAction SilentlyContinue;

# Directories
CHOCO_PKG_DIR := manual
BUILDS_DIR := builds

NEW_VERSION_FOLDERS := $(wildcard $(CHOCO_PKG_DIR)/$(PRODUCT_NAME)_*/BuildFlagFile.gitignore)
BUILD_TARGETS := $(NEW_VERSION_FOLDERS:%BuildFlagFile.gitignore=%/build)

new-versions:
	@Write-Host "new-versions"
	@$(IMPORT_CMD) Get-UiPathVersions -ProductName '$(PRODUCT_NAME)' -DaysOld '$(DAYS_OLD)'
	@Write-Host "createchocolateypackages"
	@$(IMPORT_CMD) New-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

all: new-versions build-packages publish-packages
	@Write-Host "all completed"

build-packages: $(BUILD_TARGETS)
	@Write-Host "buildchocolateypackages"

%/build:
	@if (!(Test-Path -Path $(BUILDS_DIR))) { New-Item -ItemType Directory -Path $(BUILDS_DIR) | Out-Null }
	@Write-Host "Building Chocolatey package for version in $*"
	@Write-Host "ProductName: $(PRODUCT_NAME)"
	@Write-Host "BuildsDirectory: $(BUILDS_DIR)"
	@$(IMPORT_CMD) Build-ChocolateyPackage -ProductName '$(PRODUCT_NAME)' -PackageLocation '$*' -BuildsDirectory '$(BUILDS_DIR)'

publish-packages:
	@Write-Host "publish-packages"
	@Get-ChildItem -Path '$(BUILDS_DIR)/$(PRODUCT_NAME)*.nupkg' | ForEach-Object { $(IMPORT_CMD); Push-ChocolateyPackage -NupkgFile $$_ -TargetRepository 'test'; }

print-vars:
	@echo "NEW_VERSION_FOLDERS: $(NEW_VERSION_FOLDERS)"
	@echo "BUILD_TARGETS: $(BUILD_TARGETS)"

clean:
	@Write-Host "clean"
	@Remove-Item -Path ".\manual\UiPathStudio_*" -Recurse -Force -ErrorAction SilentlyContinue
	@Remove-Item -Path ".\manual\UiPathStudioCommunity_*" -Recurse -Force -ErrorAction SilentlyContinue
	@#/usr/bin/bash -c 'for dir in manual/UiPathStudio*_*; do find "$$dir" -type f -exec touch -t 202301010000 {} \;; done'
	@#/usr/bin/bash -c 'find manual/UiPathStudio*_* -type f -name "marker" -exec rm {} \;'
	@Get-ChildItem -Path 'manual/UiPathStudio*.*' -Filter 'marker' -File -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
	@Get-ChildItem -Path 'builds/' -Filter 'uipath*' -File -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
