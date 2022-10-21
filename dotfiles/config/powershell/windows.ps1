function mklink { cmd.exe /c mklink.exe $args }

## Add vim to $PATH
$vim_dir = Get-ChildItem -Path "C:\Program Files\Vim\" -Attribute 'Directory' -ErrorAction silentlycontinue | Select-Object -ExpandProperty FullName | Select -Last 1

if (${vim_dir}) {
	$env:PATH = "${vim_dir};" + $env:PATH
}
