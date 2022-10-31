function mklink { cmd.exe /c mklink.exe $args }

$env:WINFETCH_CONFIG_PATH = "$env:HOME\.config\winfetch\config.ps1"

## Add vim to $PATH
$vim_dir = Get-ChildItem -Path "C:\Program Files\Vim\" -Attribute 'Directory' -ErrorAction silentlycontinue | Select-Object -ExpandProperty FullName | Select -Last 1

if (${vim_dir}) {
	$env:PATH = "${vim_dir};" + $env:PATH
}

## Functions
Remove-Alias -Name ls
function ls { get-childitem -path $args[0] | format-wide -property name }
