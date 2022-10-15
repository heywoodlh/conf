function ansibuild { cd ${HOME}/opt/ansible && sudo ansible-playbook playbooks/workstation/workstation.yml }

function ls { /bin/ls --color=tty $args }

## Gnome stuff
if ( [Environment]::GetEnvironmentVariable('GNOME_SHELL_SESSION_MODE') )
{
    ## Map caps lock to super key
    if (get-command gsettings)
    {
	$caps_super=gsettings get org.gnome.desktop.input-sources xkb-options | grep caps | grep super
	if ($caps_super -eq $null)
	{
	    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:super']"
	}
    } 
}

## Add Homebrew to $PATH
$env:PATH = "/home/linuxbrew/.linuxbrew/bin:${HOME}/.linuxbrew/bin:" + $env:PATH
