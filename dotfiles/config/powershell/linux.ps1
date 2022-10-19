function ansibuild { cd ${HOME}/opt/ansible && sudo ansible-playbook playbooks/workstation/workstation.yml }

function ls {
    $ls_bin = which ls; 
    invoke-expression "$ls_bin --color=tty $args"
}

function open {
    xdg-open $args
}

## Gnome stuff
if ( $env:DESKTOP_SESSION -eq 'gnome' )
{
    ## Map caps lock to super key
    get-command gsettings > $null
    if ($?)
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

## NixOS stuff
if ($isNixOS)
{
    function sudo { /run/wrappers/bin/sudo $args }
}
