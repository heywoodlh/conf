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
	$caps_super=gsettings get org.gnome.desktop.input-sources xkb-options | grep caps | grep ctrl_modifier 
	if ($caps_super -eq $null)
	{
	    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
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
    # Function to install nixos configs
    function nixos-switch {
        sudo nixos-rebuild switch --flake github:heywoodlh/nixos-configs#$(hostname)
    }

}
