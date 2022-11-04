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

function darbuild {
    darwin-rebuild switch -I "darwin-config=$HOME/opt/nixos-builds/darwin/darwin-configuration.nix"
}
