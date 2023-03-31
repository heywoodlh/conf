## If MacOS supports secure enclave
ioreg -l | grep -q AppleANS
if ($?)
{
    ## If secretive is installed
    if ( Test-Path ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/ )
    {
	$env:SSH_AUTH_SOCK = "${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
    }	
}

function pbcopy () {
    $input | /usr/bin/pbcopy $args
}

## Add /usr/local/bin to $PATH
$env:PATH = "/opt/homebrew/bin:/usr/local/bin:" + $env:PATH

## Add tfenv to $PATH
$env:PATH = "${HOME}/bin/tfenv/bin:" + $env:PATH

## Nix on Darwin stuff
$env:PATH = "/run/current-system/sw/bin:" + $env:PATH

function darbuild {
    git -C ${HOME}/opt/nixos-configs pull origin master 
    darwin-rebuild switch --flake ${HOME}/opt/nixos-configs#$(hostname)
}

$env:__NIX_DARWIN_SET_ENVIRONMENT_DONE = 1
$env:NIX_PATH = "darwin-config=$env:HOME/.nixpkgs/darwin-configuration.nix:/nix/var/nix/profiles/per-user/root/channels:$env:HOME/.nix-defexpr/channels"
$env:NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
$env:XDG_CONFIG_DIRS = "$env:HOME/.nix-profile/etc/xdg:/etc/profiles/per-user/$env:USER/etc/xdg:/run/current-system/sw/etc/xdg:/nix/var/nix/profiles/default/etc/xdg"
$env:XDG_DATA_DIRS = "$env:HOME/.nix-profile/share:/etc/profiles/per-user/$env:USER/share:/run/current-system/sw/share:/nix/var/nix/profiles/default/share"
$env:NIX_USER_PROFILE_DIR = "/nix/var/nix/profiles/per-user/$env:USER"
$env:NIX_PROFILES = "/nix/var/nix/profiles/default /run/current-system/sw /etc/profiles/per-user/$env:USER $env:HOME/.nix-profile"
