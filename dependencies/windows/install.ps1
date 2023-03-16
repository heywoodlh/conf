# This script will install my Windows config
$current_directory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$dotfiles_directory = "${HOME}\opt\conf"

function check_command () {
    $command = $args[0]
    while (!(Get-Command $command -ErrorAction SilentlyContinue)) {
        Write-Host "Waiting for $command to be available in the PATH..."
        Start-Sleep -Seconds 1
    }
    write-output "$command is installed"
}

function test-symlink($filePath) {
    # For Windows check if file is symlink using dir
    if ($isWindows) {
        (Get-ItemProperty "${filePath}").LinkType 2>$null
        $global:symcheck_code = $?
    } 
    # For everything not Windows, use BASH to check symlink
    else {
        bash -c "test -L ${filePath}"
        $global:symcheck_code = $?
    }
}

if (-not (get-command choco.exe -errorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Start-Process -Wait powershell -Verb RunAs -ArgumentList '-Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString(''https://chocolatey.org/install.ps1''))"'
    # Wait until chocolatey is installed
    $env:PATH += "C:\ProgramData\chocolatey\bin;"
    check_command choco.exe
}

write-output "chocolatey is installed, continuing with installing choco packages"

Start-Process -Wait powershell -Verb RunAs -ArgumentList "choco install ${current_directory}\packages.config --yes --acceptlicense"

# Create symlink for Windows Terminal settings
if (! test-symlink $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
    if (test-path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
        move-item $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.bak
        new-item -itemtype SymbolicLink -path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -target "${dotfiles_directory}\dotfiles\config\windows-terminal\settings.json"
    }
}
new-item -itemtype directory -path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -erroraction silentlycontinue
copy-item -v ${current_directory}\..\..\dotfiles\config\windows-terminal\settings.json "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$python_version="311"
$env:PATH += "C:\Python${python_version}\Scripts;"
# Wait until python is installed
if (-not (get-command py.exe -errorAction SilentlyContinue)) {
    Start-Process -Wait powershell -Verb RunAs -ArgumentList "choco install python${python_version} --yes --acceptlicense"
    write-output "Waiting for python to be installed"
    check_command py.exe
}

# Install peru
if (-not (get-command peru.exe -errorAction SilentlyContinue)) {
    check_command pip.exe
    Start-Process -Wait powershell -Verb RunAs -ArgumentList "pip.exe install peru"
    # Wait until peru is installed
    check_command peru.exe
}

# Install dotfiles
cd ${dotfiles_directory}; peru sync
powershell -ExecutionPolicy Bypass -File ${dotfiles_directory}\setup.ps1

# Additional scripts
## User interface preferences
Start-Process -Wait powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File ${current_directory}\scripts\user-interface.ps1"
## Privacy
Start-Process -Wait powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File ${current_directory}\scripts\privacy.bat"
