function vultr-unlock {
    if (!$env:VULTR_API_KEY) {
        $env:VULTR_API_KEY = bw get password 2eb34e09-f5b4-4fc2-9c65-ace7013dd1b4
    }
    $env:TF_VAR_vultr_api_key = $env:VULTR_API_KEY 
}

function vultr-cli {
    $vultr_cli_bin = (get-command vultr-cli -type application).path
    vultr-unlock
    $cmd = "& ${vultr_cli_bin} $args"
    invoke-expression $cmd
    #start-process -filepath "${vultr_cli_bin}" -argumentlist "${args}" -PassThru
}

function vultr {
    vultr-unlock
    docker run -it --rm -e VULTR_API_KEY="$env:VULTR_API_KEY" heywoodlh/vultr $args
}
