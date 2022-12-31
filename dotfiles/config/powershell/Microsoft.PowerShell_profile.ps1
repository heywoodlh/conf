## NixOS stuff must be loaded first so $PATH is setup right
if (get-content -erroraction silentlycontinue /etc/os-release | select-string 'ID=nixos')
{
    $isNixOS = 'true'
}

## NixOS Path
if ($isNixOS) 
{
    $env:PATH = "$env:HOME/bin:" + $env:PATH + ":/home/$env:USER/.nix-profile/bin:/etc/profiles/per-user/$env:USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
}

## Add ~/bin to PATH

if (test-path ~/bin) {
    $env:PATH = "${HOME}/bin:" + $env:PATH
}

## Create pure-looking prompt
function prompt {
    $exit_code = $global:LASTEXITCODE

    if (git rev-parse --is-inside-work-tree) {
	$git_branch = $(git branch --show-current)
    } else {
	$git_branch = ''
    }

    $working_dir = Split-Path -leaf -path (Get-Location)

    $global:LASTEXITCODE = $exit_code
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

# Predictive Intellisense
Set-PSReadLineOption -PredictionSource History

# Vi edit mode
Set-PSReadLineOption -EditMode vi -ViModeIndicator cursor

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

# Stuff not to save in dotfiles repo
if (test-path ~/.config/powershell/custom.ps1) {
    . ~/.config/powershell/custom.ps1
}

# Lima docker stuff
if (test-path ~/.lima/docker/sock/docker.sock) {
    . ~/.config/powershell/lima.ps1
}

# Custom powershell config to workstation

# Create tmp directory
New-Item -Path "~/tmp" -ItemType Directory 2>&1>$null

# Bash-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Prompt colors
Set-PSReadlineOption -Colors @{
    Type = "DarkCyan"
    Member = "Gray"
    String = "DarkGray"
    Number = "Yellow"
    Comment = "DarkGreen"
    Command = "Cyan"
    Keyword = "Cyan"
    Operator = "Gray"
    Variable = "Magenta"
    Parameter = "Gray"
}


# Cross-platform functions
function asp {
    $aws_profiles = get-content ~/.aws/config | Select-String '\[profile'
    $aws_profiles = "$aws_profiles".replace('[profile ','').replace(']','')

    if ( $args[0] ) {
	$profile = $args[0]
	${aws_profiles} | select-string ${profile} 2>&1>$null 
	if ( $? )
	{
		$selection = $profile	
	} else 
	{
		write-output "No profile named '${profile}'"
	}
    } else
    {
	$selection = $aws_profiles -split ' ' | fzf
    }
    $env:AWS_PROFILE = ${selection}
}

function gpsup {
    git push --set-upstream origin $(git branch --show-current)
}

function maintains {
    vim ~/opt
}

function mkvirtualenv {
    if (-not ($args[0])) {
        echo 'Usage: mkvirtualenv [name]'
    } else {
        $env_path = $args[0]
	$env_name = split-path ${env_path} -leafbase
	# Create virtualenv
	python3 -m venv ${env_path}
	# Activate virtualenv
	cd ${env_name}
	. ./bin/Activate.ps1
    }
}

function pbcopy { 
    set-clipboard -Value $input
}

function source {
    . $args[0]
}

function ssh-unlock { ssh-add -t 1h $env:HOME/.ssh/tyranny/id_rsa }

function which {
    $command_name = $args[0]
    $command_type = get-command -erroraction silentlycontinue ${command_name} | select-object -expandproperty commandtype 
    if (${command_type} -eq 'Application')
    {
	get-command ${command_name} | select-object -expandproperty source
    } else
    {
	${command_type}
    }
}

## Larger, specific functions will be placed in ./functions folder
## For each .ps1 file in ~/.config/powershell/functions dot source it
Get-ChildItem -Path ~/.config/powershell/functions -Filter *.ps1 | ForEach-Object { . $_.FullName }

## Import stuff specific to work last
if (test-path ~/.config/powershell/work.ps1) {
    . ~/.config/powershell/work.ps1
}

## Set vim as EDITOR
$env:EDITOR = "vim"

## Disable paging in AWS
$env:AWS_PAGER = ""
