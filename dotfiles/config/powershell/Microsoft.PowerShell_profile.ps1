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

# Check if tmux session
if (dir env:TMUX -erroraction silentlycontinue) {
    $isTmux = 'true'
}

## Function to compare terminal width to a string and append that string to the prompt

## Create pure-looking prompt
function prompt {
    # Store exit code of previous command for prompt color
    $exit_code = $global:LASTEXITCODE
    $global:LASTEXITCODE = $exit_code

    # Use PWD for Tmux stuff and update the PWD environment variable
    $global:OLDPWD = $global:PWD
    $global:PWD = $(Get-Location -PSProvider FileSystem).ProviderPath
    $env:PWD = $global:PWD
    if ($isTmux -eq 'true') {
        tmux setenv -g PWD $env:PWD
    }
   
    # If git is installed
    if (get-command git -erroraction silentlycontinue) { 
        $git_branch = git branch --show-current 2> $null
        $global:LASTEXITCODE = 0
    }

    # If kubectl is installed
    if (get-command kubectl -erroraction silentlycontinue) { 
        $kubectl_context = kubectl config current-context 2> $null
        $global:LASTEXITCODE = 0
    }

    # Get current terminal_width
    $terminal_width = (Get-Host).UI.RawUI.BufferSize.Width
    
    # Replace $HOME with ~ in working_dir (and "\" with "/" if on Windows)
    $home_directory = $env:HOME
    $working_dir = (get-location).Path
    if ($working_dir.contains($home_directory)) {
        $working_dir = $working_dir.Replace($HOME, "~")
    }
    if ($isWindows) {
        $working_dir = $working_dir.Replace("\", "/")
    }

    # If working_dir is longer than terminal_width, use short working_dir
    if (${working_dir}.Length -gt $terminal_width) {
        $working_dir = "./$(Split-Path -leaf -path (Get-Location))"
    }

    ## If last command succeeded
    if ( $exit_code -eq 0 ) {
        ## Set prompt_cursor_color to white
        $prompt_cursor_color = "37m"
    } else {
        ## Set prompt_cursor_color to red, when last command failed
        $prompt_cursor_color = "31m"
    }

    # Values that will always be visible in prompt
    $working_dir_prompt = "$([char]27)[34m${working_dir}"
    $prompt_cursor = "$([char]27)[$prompt_cursor_color❯ "

    # Array to add optional values to
    $optional_prompt_values = @()
    # Values that may or may not be visible in my prompt, based on terminal width
    # (Make sure that checks for null or empty values are here)
    if ($git_branch -ne $null -and $git_branch -ne '') {
        $git_branch_prompt = "$([char]27)[92m${git_branch}"
        $optional_prompt_values += $git_branch_prompt
    }
    if ($env:AWS_PROFILE) {
        $aws_profile_prompt = "$([char]27)[33m${env:AWS_PROFILE}"
        $optional_prompt_values += $aws_profile_prompt
    }
    if ($kubectl_context -ne $null -and $kubectl_context -ne '') {
	# Get the last string after "/" character in AWS context to clean up
	if ($kubectl_context.contains("arn:aws")) {
            $kubectl_context = $kubectl_context.split('/')[1]
	}
        $kubectl_context_prompt = "$([char]27)[36m${kubectl_context}"
        $optional_prompt_values += $kubectl_context_prompt
    }

    # Define line_1 to append desired values shown in prompt, based on terminal width
    $line_1 = "${working_dir_prompt}"

    # Define function to append stuff to line_1
    function append_to_prompt {
        param(
            [string]$prompt_line,
            [string]$new_value,
            [int]$max_length
        )
	# Only move forward if new_value is not empty
	if ($new_value -ne $Null -and $new_value -ne '') {
            # Check if adding the new value will make the prompt too long
            if (($prompt_line.Length + $new_value.Length + 1) -le $max_length) {
                # Append the new value to the prompt line
                if ($prompt_line.Length -gt 0) {
                    # Add a separator character if the prompt line is not empty
                    $prompt_line += " "
                }
                $prompt_line += $new_value
            }
        }	
        return $prompt_line
    }

    # For each optional value, append it to line_1 if there is room
    foreach ($value in $optional_prompt_values) {
        $line_1 = append_to_prompt $line_1 $value $terminal_width
    }

    $prompt = "$line_1 `r`n$prompt_cursor"
    return $prompt
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

# Everything not Windows
if (-not (${isWindows})) {
    . ~/.config/powershell/not-windows.ps1
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

function marp-template {
    if (-not ($args[0])) {
        echo 'Usage: marp-template filename.md'
    } else {
        $file_path = $args[0]
	if (-not (test-path ${file_path})) {
            new-item -itemtype file -path ${file_path} > $null 
            add-content -path ${file_path} -value "---"
            add-content -path ${file_path} -value "marp: true"
            add-content -path ${file_path} -value "title: Slide Title"
            add-content -path ${file_path} -value "description: Slide description"
            add-content -path ${file_path} -value "paginate: true"
            add-content -path ${file_path} -value "_paginate: false"
            add-content -path ${file_path} -value "---"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "# <!--fit--> Title of my presentation!"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "#### \*Description of presentation\*"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "<footer>"
            add-content -path ${file_path} -value "https://github.com/heywoodlh/repo-name"
            add-content -path ${file_path} -value "</footer>"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "-------------------------------------------------"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "### Spencer Heywood"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "Blog: __https://the-empire.systems__"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "Github: __https://github.com/heywoodlh/__"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "<footer>"
            add-content -path ${file_path} -value "https://github.com/heywoodlh/repo-name/"
            add-content -path ${file_path} -value "</footer>"
            add-content -path ${file_path} -value ""
            add-content -path ${file_path} -value "-------------------------------------------------"
	}
        vim "${file_path}"
    }
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

function source {
    . $args[0]
}

function ssh-unlock {
    bw get item ssh/id_rsa | jq -r .notes | ssh-add -t 4h -
}

function tf {
    terraform $args
}

function which {
    $command_name = $args[0]
    $command_type = get-command -erroraction silentlycontinue ${command_name} | select-object -expandproperty commandtype 
    if (${command_type} -eq 'Application') {
	get-command ${command_name} | select-object -expandproperty source
    } else {
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
