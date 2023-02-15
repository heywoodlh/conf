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

function start-ssh-agent () {
    $ssh_agent_output = $(ssh-agent -s)    
    $env:SSH_AUTH_SOCK = $ssh_agent_output | grep SSH_AUTH_SOCK | cut -d "=" -f 2 | cut -d ";" -f1
    $env:SSH_AGENT_PID = $ssh_agent_output | grep SSH_AGENT_PID | cut -d "=" -f 2 | cut -d ";" -f1
}