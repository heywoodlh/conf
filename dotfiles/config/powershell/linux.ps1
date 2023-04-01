function open {
    xdg-open $args
}

function pbcopy {
    $input | xclip -selection clipboard
}

## Gnome stuff
if ( $env:DESKTOP_SESSION -eq 'gnome' )
{
    ## Map caps lock to super key
    get-command gsettings > $null
    if ($?)
    {
	$caps_super=gsettings get org.gnome.desktop.input-sources xkb-options | grep caps | grep ctrl_super
	if ($caps_super -eq $null)
	{
	    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:super']"
	}
    } 
}

## Add tfenv to $PATH
$env:PATH = "${HOME}/bin/tfenv/bin:" + $env:PATH

## Add Homebrew to $PATH
$env:PATH = "/home/linuxbrew/.linuxbrew/bin:${HOME}/.linuxbrew/bin:" + $env:PATH

## NixOS stuff
if ($isNixOS)
{
    function sudo { /run/wrappers/bin/sudo $args }
    # Stuff specific to GNOME on NixOS
    if ( $env:DESKTOP_SESSION -eq 'gnome' )
    {
	# Disable Super+P keyboard shortcut
        Start-Job -ScriptBlock {
	    nix-shell -p glib gnome.mutter --command 'env XDG_DATA_DIRS=$GSETTINGS_SCHEMAS_PATH gsettings set org.gnome.mutter.keybindings switch-monitor "[]"'
        } > $null
    }
    # Functions to install nixos configs
    function nixos-switch {
        sudo nixos-rebuild switch --flake github:heywoodlh/nixos-configs#$(hostname)
    }
    
    function nixos-desktop {
        sudo nixos-rebuild switch --flake github:heywoodlh/nixos-configs#$(hostname) -p current
    }

}

# Start ssh agent if connected over SSH
if ($env:SSH_CONNECTION) {
    $ssh_agent_output = $(ssh-agent -s)
    $env:SSH_AUTH_SOCK = $ssh_agent_output | grep SSH_AUTH_SOCK | cut -d "=" -f 2 | cut -d ";" -f1
    $env:SSH_AGENT_PID = $ssh_agent_output | grep SSH_AGENT_PID | cut -d "=" -f 2 | cut -d ";" -f1
}
