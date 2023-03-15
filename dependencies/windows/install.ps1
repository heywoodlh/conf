# This script will install my Windows config
$current_directory = Split-Path -Parent $MyInvocation.MyCommand.Definition

if (-not (get-command choco.exe -errorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Start-Process powershell -Verb RunAs -ArgumentList '-Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString(''https://chocolatey.org/install.ps1''))"'
}

# Wait until chocolatey is installed
write-output "Waiting for chocolatey to be installed"
do {
    Start-Process powershell -ArgumentList 'get-command choco.exe' -Wait -WindowStyle Hidden
} while ($LastExitCode -ne 0)
write-output "chocolatey is installed, continuing with installing choco packages"

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
    Invoke-WebRequest -Uri $url -OutFile "${current_directory}\Setup.msix" -UseBasicParsing
    # install
    Start-Process powershell -Verb RunAs -ArgumentList "Add-AppxPackage -Path ${current_directory}\Setup.msix"
    # delete file
    Remove-Item "${current_directory}\Setup.msix"
}

# Wait until winget is installed
write-output "Waiting for chocolatey to be installed"
do {
    Start-Process powershell -ArgumentList 'get-command winget.exe' -Wait -WindowStyle Hidden
} while ($LastExitCode -ne 0)

# Install winget packages
Start-Process powershell -Verb RunAs -ArgumentList "winget import -i ${current_directory}\winget.json --ignore-unavailable --accept-package-agreements --accept-source-agreements"

# Setup Windows Terminal config
new-item -itemtype directory -path "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -erroraction silentlycontinue
copy-item -v ${current_directory}\..\..\dotfiles\config\windows-terminal\settings.json "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Additional scripts
## Privacy
Start-Process powershell -Verb RunAs -ArgumentList "${current_directory}\scripts\privacy.bat"
