ifeq ($(OS),Windows_NT)
SHELL := pwsh.exe
else
SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

PRODUCT_NAME ?= UiPathStudioCommunity
DAYS_OLD ?= 200

IMPORT_CMD := Import-Module .\scripts\powershell\ChocolateyUiPathPackager\ChocolateyUiPathPackager.psd1 -Force -WarningAction SilentlyContinue;

# Directories
CHOCO_PKG_DIR := manual
BUILDS_DIR := builds

NEW_VERSION_FOLDERS := $(wildcard $(CHOCO_PKG_DIR)/$(PRODUCT_NAME)_*/BuildFlagFile.gitignore)

# Define build and push targets based on found .nuspec files
BUILD_TARGETS := $(NEW_VERSION_FOLDERS:%BuildFlagFile.gitignore=%/build)
# PUSH_TARGETS := $(NEW_VERSION_FOLDERS:%BuildFlagFile.gitignore=%/push)

# Find all .nupkg files for the PRODUCT_NAME within BUILDS_DIR
NUPKG_FILES := $(wildcard $(BUILDS_DIR)/$(PRODUCT_NAME)*.nupkg)
# Define push targets based on found .nupkg files
PUSH_TARGETS := $(NUPKG_FILES:%=%.push)

.PHONY: all clean build-packages publish-packages clean2debug

new-versions:
	@Write-Host "new-versions"
	@$(IMPORT_CMD) Get-UiPathVersions -ProductName '$(PRODUCT_NAME)' -DaysOld '$(DAYS_OLD)'
	@Write-Host "createchocolateypackages"
	@$(IMPORT_CMD) New-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'


all: new-versions build-packages publish-packages
	@Write-Host "all"
	@Write-Host "BUILD_TARGETS: $(BUILD_TARGETS)"
	@Write-Host "PUSH_TARGETS: $(PUSH_TARGETS)"

# # Default target to build and push all packages
# all: clean2debug getuipathversions createchocolateypackages buildchocolateypackages pushchocolateypackages
# 	@Write-Host "all"
# 	@Write-Host "BUILD_TARGETS: $(BUILD_TARGETS)"

build-packages: $(BUILD_TARGETS)
	@Write-Host "buildchocolateypackages"

%/build:
	@Write-Host "Building Chocolatey package for version in $*"
	@Write-Host "ProductName: $(PRODUCT_NAME)"
	@Write-Host "BuildsDirectory: $(BUILDS_DIR)"
	@$(IMPORT_CMD) Build-ChocolateyPackage -ProductName '$(PRODUCT_NAME)' -PackageLocation '$*' -BuildsDirectory '$(BUILDS_DIR)'


publish-packages:
	@Write-Host "publish-packages"
	$(eval NUPKG_FILES = $(wildcard $(BUILDS_DIR)/$(PRODUCT_NAME)*.nupkg))
	$(foreach nupkg,$(NUPKG_FILES),.\Push-ChocolateyPackage.ps1 -NupkgFile $(nupkg) -TargetRepository $(TARGET_REPOSITORY);)


# publish-packages: $(PUSH_TARGETS)
# 	@Write-Host "publish-packages"
# 	@Write-Host "PUSH_TARGETS: $(PUSH_TARGETS)"

# # Adjusted push rule to work with specific .nupkg files
# $(BUILDS_DIR)/%.nupkg.push:
# 	@Write-Host "Pushing Chocolatey package $*"
# 	@$(IMPORT_CMD) Push-ChocolateyPackage -ProductName '$(PRODUCT_NAME)' -NupkgFile '$(BUILDS_DIR)/$*.nupkg'

clean2debug:
	@Write-Host "clean2debug"
	@Remove-Item -Path ".\manual\UiPathStudio_23.10*" -Recurse -Force -ErrorAction SilentlyContinue
	@Remove-Item -Path ".\manual\UiPathStudioCommunity_23.10*" -Recurse -Force -ErrorAction SilentlyContinue
	@#/usr/bin/bash -c 'for dir in manual/UiPathStudio*_*; do find "$$dir" -type f -exec touch -t 202301010000 {} \;; done'
	@#/usr/bin/bash -c 'find manual/UiPathStudio*_* -type f -name "marker" -exec rm {} \;'
	@Get-ChildItem -Path 'manual/UiPathStudio*.*' -Filter 'marker' -File -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
	@Get-ChildItem -Path 'builds/' -Filter 'uipath*' -File -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue


# getuipathversions:
# 	@Write-Host "getuipathversions"
# 	@$(IMPORT_CMD) Get-UiPathVersions -ProductName '$(PRODUCT_NAME)' -DaysOld '$(DAYS_OLD)'

# createchocolateypackages:
# 	@Write-Host "createchocolateypackages"
# 	@$(IMPORT_CMD) New-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'



# .PHONY: getuipathversions createchocolateypackages buildchocolateypackages all clean



# IMPORT_CMD := Import-Module .\scripts\powershell\ChocolateyUiPathPackager\ChocolateyUiPathPackager.psd1 -Force -WarningAction SilentlyContinue;




# buildchocolateypackages:
# 	@$(IMPORT_CMD) Build-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

# pushchocolateypackages:
# 	@$(IMPORT_CMD) Push-ChocolateyPackages -ProductName '$(PRODUCT_NAME)'

# uipath: getuipathversions createchocolateypackages buildchocolateypackages pushchocolateypackages


# clean:
# 	@Remove-Item -Path ".\data\*.csv" -Force -ErrorAction SilentlyContinue
# 	@Remove-Item -Path ".\builds\*" -Force -ErrorAction SilentlyContinue
# 	@Remove-Item -Path ".\manual\UiPathStudio_*" -Recurse -Force -ErrorAction SilentlyContinue
# 	@Remove-Item -Path ".\manual\UiPathStudioCommunity_*" -Recurse -Force -ErrorAction SilentlyContinue
