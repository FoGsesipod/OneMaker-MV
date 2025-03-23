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

function Get-LatestRelease {
    if (!(Test-Path -Path $workingDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $workingDirectory | Out-Null
    }

    $apiUrl = "https://api.github.com/repos/FoGsesipod/OneMaker-MV/releases/latest"

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
                Expand-Archive -Path $outputFilePath -DestinationPath $workingDirectory -Force
                
                try {
                    Remove-Item -Path $outputFilePath -Force
                    Write-Host "Successfully Extracted Latest Release."
                }
                catch {
                    Write-Error "Failed to remove downloaded zip: $_"
                }
            }
        }
    }
    catch {
        Write-Error "Failed to Downloaded the Latest Release: $_"
    }
}

function Update-CoreFIles {
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

function Remove-ResourceRedirects {
    if ($oldInstall) {
        if ($replaceSplash) {
            Remove-Item -Path $splashFolder -Recurse -Force
            Write-Host "Removed Splash"
        }
        if ($replaceImages) {
            Remove-Item -Path $imageFolder -Recurse -Force
            Write-Host "Removed Images"
        }
        
        Get-ChildItem -Path $qmlDirectory -Directory -Exclude "Images" |
        ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
        Write-Host "Removed old _hijack_root files."
    }
}

function Install-ResourceRedirects {
    if ($oldInstall) {
        $newQmlDirectory = Join-Path -Path $newHijackRoot -ChildPath "qml"

        if ($replaceSplash) {
            $newSplashFolder = Join-Path -Path $newHijackRoot -ChildPath "Splash"
            Copy-Item -Path $newSplashFolder -Destination $splashFolder -Recurse -Force
            Write-Host "Installed new Splash"
        }
        if ($replaceImages) {
            $newImageFolder = Join-Path -Path $newQmlDirectory -ChildPath "Images"
            Copy-Item -Path $newImageFolder -Destination $imageFolder -Recurse -Force
            Write-Host "Installed new Images"
        }

        Get-ChildItem -Path $newQmlDirectory -Directory -Exclude "Images" |
        ForEach-Object {
            Copy-Item -Path $newQmlDirectory -Destination $hijackRoot -Recurse -Force
        }
        Write-Host "Installed new _hijack_root files"
    }
    else {
        Copy-Item -Path $newHijackRoot -Destination $rpgMakerRoot -Recurse
    }
}

function Cleanup {
    Remove-Item -Path $workingDirectory -Recurse -Force
}

$rpgMakerRoot = Get-RpgMaker-Installation

$workingDirectory = Join-Path -Path $PSScriptRoot -ChildPath "Working"
$targetFileName = "OneMaker-MV.zip"
$outputFilePath = Join-Path -Path $workingDirectory -ChildPath $targetFileName
Get-LatestRelease

$QT5Core = Join-Path -Path $workingDirectory -ChildPath "QT5Core.dll"
$hijackRcc = Join-Path -Path $workingDirectory -ChildPath "hijack.rcc"
Update-CoreFIles

$hijackRoot = Join-Path -Path $rpgMakerRoot -ChildPath "_hijack_root"
$newHijackRoot = Join-Path -Path $workingDirectory -ChildPath "_hijack_root"
$oldInstall = Test-Path -Path $hijackRoot

$replaceSplash = $false
if ($oldInstall) {
    do {
        $updateSplash = Read-Host -Prompt "Do you want to update the Splash image? [Y/N]"
        $response = $updateSplash.ToLower()
    } until ($response -in @("y", "n"))

    if ($response -eq "y") {
        $replaceSplash = $true
    }
}
$replaceImages = $false
if ($oldInstall) {
    do {
        $updateImage = Read-Host -Prompt "Do you want to replace your Images folder? [Y/N]"
        $response = $updateImage.ToLower()
    } until ($response -in @("y", "n")) 

    if ($response -eq "y") {
        $replaceImages = $true
    }
}

$qmlDirectory = Join-Path -Path $hijackRoot -ChildPath "qml"
$imageFolder = Join-Path -Path $qmlDirectory -ChildPath "Images"
$splashFolder = Join-Path -Path $hijackRoot -ChildPath "Splash"
Remove-ResourceRedirects
Install-ResourceRedirects

CleanUp

Read-Host -Prompt "Installation completed. Press Enter to exit"