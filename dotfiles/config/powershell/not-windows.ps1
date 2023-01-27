function ls {
    $ls_bin = get-command -commandtype application ls | select-object -expandproperty source -First 1;
    invoke-expression "${ls_bin} --color=tty $args"
}

function start-ssh-agent () {
    $ssh_agent_output = $(ssh-agent -s)    
    $env:SSH_AUTH_SOCK = $ssh_agent_output | grep SSH_AUTH_SOCK | cut -d "=" -f 2 | cut -d ";" -f1
    $env:SSH_AGENT_PID = $ssh_agent_output | grep SSH_AGENT_PID | cut -d "=" -f 2 | cut -d ";" -f1
}
