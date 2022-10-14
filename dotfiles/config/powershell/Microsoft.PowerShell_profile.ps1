$env:POWERSHELL_UPDATECHECK_OPTOUT = true
$env:POWERSHELL_TELEMETRY_OPTOUT = true

## Function for installing/loading modules
function load_module ($module_name) {
    if (get-module | where-object {$_.name -eq ${module_name}}) {
        write-host "module ${module_name} is already imported."
    }
    else {
        if (get-module -listavailable | where-object {$_.name -eq ${module_name}}) {
            import-module ${module_name} 
        }
        else {
	    import-module powershellget
            if (find-module -name ${module_name} | where-object {$_.name -eq ${module_name}}) {
                install-module -name ${module_name} -force -scope currentuser
                import-module ${module_name} 
            }
        }
    }
}

## Install/load modules
load_module pure-pwsh
load_module posh-git 
load_module awspowershell 
load_module psfzf

# Configure PSFzf - set to 'Ctrl+r' like in Unix version
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Predictive Intellisense
Set-PSReadLineOption -PredictionSource History

# Linux config setup
if (${isLinux}) {
    . ~/.config/powershell/linux.ps1
}

# MacOS config setup
#if (${isMacOS}) {
#    . ~/.config/powershell/macos.ps1
#}

# Windows config setup
#if (${isWindows}) {
#    . ~/.config/powershell/windows.ps1
#}

# Docker setup
if (get-command docker) {
    . ~/.config/powershell/docker.ps1
}

# Create tmp directory
New-Item -Path "~/tmp" -ItemType Directory 2> $null

# Bash-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Cross-platform functions
function ssh-unlock { ssh-add -t 1h ~/.ssh/id_rsa }