# This script will install my Windows config
$current_directory = Split-Path -Parent $MyInvocation.MyCommand.Definition

if (-not (get-command choco.exe -errorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Start-Process powershell -Verb RunAs -ArgumentList '-Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString(''https://chocolatey.org/install.ps1''))"'
    # Wait until chocolatey is installed
    write-output "Waiting for chocolatey to be installed"
    do {
        get-command choco.exe *> $null
    } while ($LastExitCode -ne 0)
}

write-output "chocolatey is installed, continuing with installing choco packages"

Start-Process powershell -Verb RunAs -ArgumentList "choco install ${current_directory}\packages.config --yes --acceptlicense"

# Install winget if not installed
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
    # Wait until winget is installed
    write-output "Waiting for winget to be installed"
    do {
        get-command winget.exe *> $null
    } while ($LastExitCode -ne 0)
}
write-output "winget is installed, continuing with installing winget packages"

# Install winget packages
Start-Process powershell -Verb RunAs -ArgumentList "winget import -i ${current_directory}\winget.json --ignore-unavailable --accept-package-agreements --accept-source-agreements"

# Setup Windows Terminal config
new-item -itemtype directory -path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -erroraction silentlycontinue
copy-item -v ${current_directory}\..\..\dotfiles\config\windows-terminal\settings.json "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Wait until python is installed
if (-not (get-command py.exe -errorAction SilentlyContinue)) {
    Start-Process powershell -Verb RunAs -ArgumentList "choco install python311 --yes --acceptlicense"
    write-output "Waiting for python to be installed"
    do {
      get-command py.exe *> $null
    } while ($LastExitCode -ne 0)
}
write-output "python is installed, continuing with installing python packages"

# Install peru
Start-Process powershell -Verb RunAs -ArgumentList "py.exe -m pip install peru"
# Wait until peru is installed
write-output "Waiting for peru to be installed"
do {
    get-command peru *> $null
} while ($LastExitCode -ne 0)
write-output "peru is installed, continuing with installing dotfiles"

# Install dotfiles
Start-Process powershell -Verb RunAs -ArgumentList "cd ${current_directory}..\..\; peru sync" -Wait
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File ${current_directory}\..\..\setup.ps1"

# Additional scripts
## User interface preferences
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File ${current_directory}\scripts\user-interface.ps1"
## Privacy
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File ${current_directory}\scripts\privacy.bat"
