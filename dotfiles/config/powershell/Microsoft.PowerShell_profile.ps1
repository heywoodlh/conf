clear-host

$env:POWERSHELL_UPDATECHECK_OPTOUT = true
$env:POWERSHELL_TELEMETRY_OPTOUT = true

## Create pure-looking prompt
function prompt {
    $exit_code = $LASTEXITCODE

    if (git branch --show-current) {
	$git_branch = $(git branch --show-current)
    } else {
	$git_branch = ''
    }

    $working_dir = Split-Path -leaf -path (Get-Location)

    ## If last command succeeded, show white prompt, otherwise show red
    if ( $exit_code -eq 0 ) {
	"$([char]27)[34m./${working_dir} $([char]27)[92m${git_branch}`r`n$([char]27)[37m❯ "
    } else
    {
	"$([char]27)[34m./${working_dir} $([char]27)[92m${git_branch}`r`n$([char]27)[31m❯ "
    }
}

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
#load_module awspowershell 

# Predictive Intellisense
Set-PSReadLineOption -PredictionSource History

# Linux config setup
if (${isLinux}) {
    . ~/.config/powershell/linux.ps1
}

# MacOS config setup
if (${isMacOS}) {
    . ~/.config/powershell/macos.ps1
}

# Windows config setup
if (${isWindows}) {
    . ~/.config/powershell/windows.ps1
}

# Docker setup
if (get-command docker -erroraction 'silentlycontinue') {
    . ~/.config/powershell/docker.ps1
}

# Create tmp directory
New-Item -Path "~/tmp" -ItemType Directory 2>&1>$null

# Bash-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Cross-platform functions
function ssh-unlock { ssh-add -t 1h ~/.ssh/id_rsa }

function pbcopy { 
    set-clipboard -Value $input
}

function gpsup {
    git push --set-upstream origin $(git branch --show-current)
}

function asp {
    $aws_profiles = get-content ~/.aws/config | Select-String '\[profile'
    $aws_profiles = "$aws_profiles".replace('[profile ','').replace(']','')

    $selection = $aws_profiles -split ' ' | fzf
    $env:AWS_PROFILE = ${selection}
}
