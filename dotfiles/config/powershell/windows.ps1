$env:HOME = "${env:HOMEDRIVE}${env:HOMEPATH}"

function mklink { cmd.exe /c mklink.exe $args }

$env:WINFETCH_CONFIG_PATH = "$env:HOME\.config\winfetch\config.ps2"

## Set Komorebi config path
$Env:KOMOREBI_CONFIG_env:HOME = "$env:HOME\.config\komorebi"

## Add vim to $PATH
$vim_dir = Get-ChildItem -Path "C:\Program Files\Vim\" -Attribute 'Directory' -ErrorAction silentlycontinue | Select-Object -ExpandProperty FullName | Select -Last 1

if (${vim_dir}) {
	$env:PATH = "${vim_dir};" + $env:PATH
}

## Add GNUWin32 executables to $PATH
$env:PATH = "C:\Program Files (x86)\GnuWin32\bin;" + $env:PATH

## Functions
Remove-Alias -Name ls -ErrorAction silentlycontinue
function ls { get-childitem -path $args[0] | format-wide -property name }

function conf { 
    docker pull heywoodlh/conf
    docker run -it --rm -v "//var/run/docker.sock://var/run/docker.sock" -v ${HOME}:/home/heywoodlh -v ${HOME}:/mnt/host/c/Users/$env:USER -w /home/heywoodlh -e LANG=en_US.UTF-8 heywoodlh/conf -NoLogo -c tmux
}

function pbcopy {
    clip.exe
}
