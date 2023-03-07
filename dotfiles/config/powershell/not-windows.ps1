function bm {
    # If `~/opt/bookmarks` doesn't exist, run `git clone git@github.com:heywoodlh/bookmarks.git ~/opt/bookmarks`
    if (-not (Test-Path ~/opt/bookmarks)) {
        git clone git@github.com:heywoodlh/bookmarks ~/opt/bookmarks  
    }
    open ~/opt/bookmarks/index.html
}

function ls {
    $ls_bin = get-command -commandtype application ls | select-object -expandproperty source -First 1;
    invoke-expression "${ls_bin} --color=tty $args"
}

function md2() {
    $help_message = "usage: md2${format} infile${in_suffix} outfile${out_suffix}"

    $mderror = "false"
    if (-not ${file_out}) {
        write-output $help_message
        $mderror = "true"
    }

    if (-not ($mderror -eq "true")) {
        pandoc -f gfm -t ${format} "${file_in}" -o "${file_out}" ${extra_pandoc_args}
    } 

}

function md2html() { 
    $format = "html"
    $in_suffix = ".md"
    $out_suffix = ".${format}"
    $file_in = $args[0]
    $file_out = $args[1]
    # Get the pandoc templates with this command: docker run -it --rm --entrypoint=ls heywoodlh/pandoc /pandoc/templates
    $extra_pandoc_args = ""

    md2
}

## Inject --no-ssh-pty into mosh commands
function mosh() {
    $mosh_bin = get-command -commandtype application mosh | select-object -expandproperty source -First 1;
    invoke-expression "${mosh_bin} --no-ssh-pty $args"
}

# Append the nix-kube-cluster config to the current kubeconfig
function nix-kube-cluster {
    # Only move forward if nix-kube context does not exist
    if (-not (kubectl config get-contexts | grep -iq nix-kube)) {
        New-Item -ItemType Directory -Path ~/.kube -ErrorAction SilentlyContinue
        bw get notes nix-kube-cluster/config > ~/.kube/nix-cluster-config
        if (-not (test-path ~/.kube/config)) {
            $env:KUBECONFIG="$HOME/.kube/nix-cluster-config"
        } else {
            $env:KUBECONFIG="$HOME/.kube/config:$HOME/.kube/nix-cluster-config"
        }
        kubectl config view --flatten > ~/.kube/config-merged
        rm ~/.kube/config
        mv ~/.kube/config-merged ~/.kube/config
        $env:KUBECONFIG="$HOME/.kube/config"
        rm ~/.kube/nix-cluster-config
    }
}

function start-ssh-agent () {
    $ssh_agent_output = $(ssh-agent -s)    
    $env:SSH_AUTH_SOCK = $ssh_agent_output | grep SSH_AUTH_SOCK | cut -d "=" -f 2 | cut -d ";" -f1
    $env:SSH_AGENT_PID = $ssh_agent_output | grep SSH_AGENT_PID | cut -d "=" -f 2 | cut -d ";" -f1
}

function url2md () {
    $url = $args[0]
    $help_message = "usage: url2md [url]"

    if (${url} -ne $null) { 
        pandoc -f html -t markdown ${url}
    } else {
        write-output ${help_message}
    }
}
