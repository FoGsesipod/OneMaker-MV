#region Functions
function Get-RpgMaker-Installation {
    $rpgmakerSteamAppID = "363890"

    $steam = (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Valve\Steam -Name "InstallPath").InstallPath
    $libraryFolders = Get-Content -Raw -Path "$steam\steamapps\libraryfolders.vdf"

    $result = $libraryFolders -match '"path"\s*"([^"]*)"\n[^{]+\s*"apps"\s*{[^{]*"363890"'

    if ($result) {
        $manifestSearchPath = $Matches.1 -replace "\\\\", "\"
        $manifestLocation = "$manifestSearchPath\steamapps\appmanifest_$rpgmakerSteamAppID.acf"

        $manifest = Get-Content -Raw -Path $manifestLocation
        $result = $manifest -match '"installdir"'

        if ($result) {
            $enginePath = "RPG Maker MV"
            $enginePath = "$manifestSearchPath\steamapps\common\$enginePath\"

            return $enginePath
        }
    }

    $enginePath = Read-Host -Prompt "We were unable to find an RPG Maker MV installation. Please specify the path"
    return $enginePath
}

function Get-LatestVersion {
    try {
        $response = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing -ErrorAction Stop

        $releaseInfo = ConvertFrom-Json $response.Content

        return $releaseInfo.tag_name
    }
    catch {
        Write-Error "Error fetching latest releases infromation from GitHub: $_"
        exit
    }
}

function Get-ManifestVersion {
    if ($oldInstall) {
        try {
            $manifestPath = Join-Path -Path $hijackRoot -ChildPath "manifest.json"

            if (-not (Test-Path -Path $manifestPath)) {
                return $null
            }

            $manifestContent = Get-Content -Path $manifestPath -Raw
            $manifest = ConvertFrom-Json -InputObject $manifestContent

            if ($manifest.PSObject.properties.Name -contains "version") {
                return $manifest.version
            }
            else {
                return $null
            }
        }
        catch {
            Write-Error "Error fetching current installations version information: $_"
            return $null
        }
    }
}

function Compare-Versions {
    if (-not $latestVersion -or -not $currentVersion) {
        return "Unknown"
    }

    try {
        $latestObject = [version]$latestVersion
        $currentObject = [version]$currentVersion

        if ($currentObject -lt $latestObject) {
            return "Outdated"
        }
        elseif ($currentObject -gt $latestObject) {
            return "Newer"
        }
        else {
            return "Match"
        }
    }
    catch {
        return "Unknown"
    }
}

function Show-UpdatePrompt {
    if ($compareResult -eq "Outdated" -or $compareResult -eq "Unknown") {
        return
    }
    elseif ($compareResult -eq "Match") {
        do {
            $prompt = Read-Host -Prompt "Latest version of OneMaker MV is already installed, would you like to reinstall? [Y/N]"
            $choice = $prompt.ToLower()
        } until ($choice -in @("y", "n"))

        if ($choice -eq "n") {
            exit
        }
    }
    elseif ($compareResult -eq "Newer") {
        do {
            $prompt = Read-Host -Prompt "You seem to have a newer version than the Github... Would you like to downgrade your installation? [Y/N]"
            $choice = $prompt.ToLower()
        } until ($choice -in @("y", "n"))

        if ($choice -eq "n") {
            exit
        }
    }
}

function Get-LatestRelease {
    if (!(Test-Path -Path $workingDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $workingDirectory | Out-Null
    }

    try {
        Write-Host "Attempting to Download Latest Release"
        $latestRelease = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing | ConvertFrom-Json

        $downloadUrl = $null
        foreach ($asset in $latestRelease.assets) {
            if ($asset.name -cmatch $targetFileName) {
                $downloadUrl = $asset.browser_download_url
                break;
            }
        }

        if ($downloadUrl) {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFilePath -UseBasicParsing

            Write-Host "Successfully Downloaded Latest Release."

            if ($targetFileName -like '*.zip') {
                try {
                    Expand-Archive -Path $outputFilePath -DestinationPath $workingDirectory -Force
                    Write-Host "Successfully Extracted Latest Release."

                    Remove-Item -Path $outputFilePath -Force

                }
                catch {
                    Write-Error "Failed to Extract Latest Release: $_"
                    Read-Host -Prompt "Installation failed. Press Enter to exit"
                    exit
                }
            }
        }
    }
    catch {
        Write-Error "Failed to Downloaded the Latest Release: $_"
        Read-Host -Prompt "Installation failed. Press Enter to exit"
        exit
    }
}

function Update-CoreFiles {
    if (Test-Path -Path $QT5Core) {
        Copy-Item -Path $QT5Core -Destination $rpgMakerRoot -Force
        Write-Host "Updated QT5Core.dll"
    }
    else {
        Write-Warning "QT5Core.dll not found in latest release."
    }

    if (Test-Path -Path $hijackRcc) {
        Copy-Item -Path $hijackRcc -Destination $rpgMakerRoot -Force
        Write-Host "Updated hijack.rcc"
    }
    else {
        Write-Warning "hijack.rcc not found in latest release."
    }
}

function Show-Selection {
    if ($oldInstall) {
        $userReplacedFont = Join-Path -Path $fontsDirectory -ChildPath "mplus-1c-regular.ttf"
        if (Test-Path -Path $userReplacedFont) {
            do {
                $resetFonts = Read-Host -Prompt "Do you want to reset the font? [Y/N]"
                $response = $resetFonts.ToLower()
            } until ($response -in @("y", "n"))

            if ($resetFonts -eq "n") {
                $removeFonts = $false
            }
        }
        do {
            $updateSplash = Read-Host -Prompt "Do you want to update the Splash image? [Y/N]"
            $response = $updateSplash.ToLower()
        } until ($response -in @("y", "n"))

        if ($response -eq "y") {
            $replaceSplash = $true
        }
        do {
            $updateImage = Read-Host -Prompt "Do you want to replace the default Image Packs? [Y/N]"
            $response = $updateImage.ToLower()
        } until ($response -in @("y", "n")) 

        if ($response -eq "y") {
            $replaceImages = $true
        }
    }
    
    return $removeFonts, $replaceSplash, $replaceImages
}

function Remove-ResourceRedirects {
    $excludes = if ($replacements[0]) {
        @("Images") 
    }
    else {
        @("Fonts", "Images")
    }

    if ($oldInstall) {
        if ($replacements[1]) {
            Remove-Item -Path $splashFolder -Recurse -Force
            Write-Host "Removed Splash"
        }
        if ($replacements[2]) {
            Get-ChildItem -Path $imageFolder -Directory |
            ForEach-Object {
                foreach ($key in $imagePacks) {
                    if ($_.Name -eq $key) {
                        Remove-Item -Path $_.FullName -Recurse -Force
                        
                    }
                }
            }
        }
        
        Get-ChildItem -Path $qmlDirectory -Directory -Exclude $excludes |
        ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
        Write-Host "Removed _hijack_root files."
    }
}

function Install-ResourceRedirects {
    if ($oldInstall) {
        if ($replacements[1]) {
            $newSplashFolder = Join-Path -Path $newHijackRoot -ChildPath "splash"
            Copy-Item -Path $newSplashFolder -Destination $splashFolder -Recurse -Force
            Write-Host "Updated Splash"
        }
        if ($replacements[2]) {
            Get-ChildItem -Path $newImageFolder -Directory |
            ForEach-Object {
                Copy-Item -Path $_.FullName -Destination $imageFolder -Recurse -Force
            }
            Write-Host "Updated Image Packs"
        }

        Get-ChildItem -Path $newQmlDirectory -Directory -Exclude "Images" |
        ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $qmlDirectory -Recurse -Force
        }

        $manifestUpdate = Join-Path $newHijackRoot -ChildPath "manifest.json"
        Copy-Item -Path $manifestUpdate -Destination $hijackRoot
        Write-Host "Installed Latest _hijack_root files"
    }
    else {
        Copy-Item -Path $newHijackRoot -Destination $rpgMakerRoot -Recurse
    }
}

function Clear-Working {
    Remove-Item -Path $workingDirectory -Recurse -Force
}

#endregion

#region Main Script

# Setup the github repository.
$apiUrl = "https://api.github.com/repos/FoGsesipod/OneMaker-MV/releases/latest"

# Get RPG Maker MV's Installation Directory.
$rpgMakerRoot = Get-RpgMaker-Installation

# Setup the destination `_hijack_root`. Detect if OneMaker MV is already installed.
$hijackRoot = Join-Path -Path $rpgMakerRoot -ChildPath "_hijack_root"
$oldInstall = Test-Path -Path $hijackRoot

# Obtain the latest version from Github and the installed version
$latestVersion = Get-LatestVersion
$currentVersion = Get-ManifestVersion

# Compare the versions, if the versions match or are newer, ask if the user wants to reinstall.
$compareResult = Compare-Versions
Show-UpdatePrompt

# Create the Working folder, the latest zip file name, and the output path for the download.
$workingDirectory = Join-Path -Path $PSScriptRoot -ChildPath "Working"
$targetFileName = "OneMaker-MV.zip"
$outputFilePath = Join-Path -Path $workingDirectory -ChildPath $targetFileName

# Download the latest release's zip, extracting it to the Working directory, then finally delete the zip.
Get-LatestRelease

# Copy and replace the core files into RPG Maker's directory.
$QT5Core = Join-Path -Path $workingDirectory -ChildPath "QT5Core.dll"
$hijackRcc = Join-Path -Path $workingDirectory -ChildPath "hijack.rcc"
Update-CoreFiles

# Setup the latest releases `_hijack_root` and `qml`.
$newHijackRoot = Join-Path -Path $workingDirectory -ChildPath "_hijack_root"
$newQmlDirectory = Join-Path -Path $newHijackRoot -ChildPath "qml"

# Setup the destination `qml` and the `Fonts` directories.
$qmlDirectory = Join-Path -Path $hijackRoot -ChildPath "qml"
$fontsDirectory = Join-Path -Path $qmlDirectory -ChildPath "Fonts"

# Prompt the user if they would like to reset the global Font, Replace the Splash.png, and Replace the Images folder.
$removeFonts = $true
$replaceSplash = $false
$replaceImages = $false
$replacements = Show-Selection

# Setup existing Splash and Images folder
$splashFolder = Join-Path -Path $hijackRoot -ChildPath "splash"
$imageFolder = Join-Path -Path $qmlDirectory -ChildPath "Images"

# Get the updated Image Pack folders
$newImageFolder = Join-Path -Path $newQmlDirectory -ChildPath "Images"
$imagePacks = Get-ChildItem -Path $newImageFolder -Directory

# Remove all qml files, and the Font/Splash/Images folder if the user specified. Then Install the new versions.
Remove-ResourceRedirects
Install-ResourceRedirects

# Cleanup the Working directory.
Clear-Working

# Completed.
Read-Host -Prompt "Installation completed. Press Enter to exit"

#endregion