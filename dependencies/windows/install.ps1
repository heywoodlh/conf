# This script will install my Windows config
$current_directory = Split-Path -Parent $MyInvocation.MyCommand.Definition

if (-not (get-command choco.exe -errorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Start-Process powershell -Verb RunAs -ArgumentList '-Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString(''https://chocolatey.org/install.ps1''))"'
}

Start-Process powershell -Verb RunAs -ArgumentList "choco install ${current_directory}\packages.config --yes --acceptlicense"

if (-not (get-command winget.exe -errorAction SilentlyContinue)) {
    Write-Host "Installing winget"
    # get latest download url
    $url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $url = (Invoke-WebRequest -Uri $url).Content | ConvertFrom-Json |
            Select-Object -ExpandProperty "assets" |
            Where-Object "browser_download_url" -Match '.msixbundle' |
            Select-Object -ExpandProperty "browser_download_url"
    # download
    Invoke-WebRequest -Uri $url -OutFile "Setup.msix" -UseBasicParsing
    # install
    Add-AppxPackage -Path "Setup.msix"
    # delete file
    Remove-Item "Setup.msix"
}

# Install winget packages
Start-Process powershell -Verb RunAs -ArgumentList "winget import -i ${current_directory}\winget.json --ignore-unavailable --accept-package-agreements --accept-source-agreements"

# Setup Windows Terminal config
new-item -ItemType Directory -Path "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
cp -v ${current_directory}\..\..\dotfiles\config\windows-terminal\settings.json "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
