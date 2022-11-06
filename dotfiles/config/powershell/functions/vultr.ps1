function vultr-unlock {
    if (!$env:VULTR_API_KEY) {
        $env:VULTR_API_KEY = bw get password 2eb34e09-f5b4-4fc2-9c65-ace7013dd1b4 
    }   
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
    $actions="instance-create`ninstance-destroy`ninstance-list`ninstance-start`ninstance-reboot`ninstance-shutdown"
    
    $action = $args[0]
    
    if ( ${action} )
    {
        write-output ${action}
        if ( ${action} -eq '--help' )
        {
            write-output "./vultr.ps1 [instance-create instance-destroy instance-list instance-start instance-reboot instance-shutdown]"
        }
    } else {
        $action = "$(write-output "${actions}" | fzf)"
    }
    
    if ( ${action} -eq 'instance-create' )
    {
        $extra_args=""
        $plans_list="$(vultr-cli plans list | grep -vE '^ID' | sed -n '/^-eq=/q;p')"
        $regions_list="$(vultr-cli regions list | grep -vE '^ID' | sed -n '/^-eq=/q;p')"
        $regions_list="$(write-output "${regions_list}" | grep 'Los Angeles' && write-output "${regions_list}" | grep 'US' | grep -v 'Los Angeles' && write-output "${regions_list}" | grep -v 'US')"
        $os_list="$(vultr-cli os list | grep -vE '^ID' | grep -E 'Arch Linux|Debian 11|Ubuntu 22.04' | sed -n '/^-eq=/q;p')"
        $os_list="$(write-output "${os_list}" | grep -E 'Arch Linux' && write-output "${os_list}" | grep -vE 'Arch Linux')"
    
        do {
            $hostname = read-host -prompt "New instance hostname"
        } until ($hostname)
    
        $os_id="$(write-output "${os_list}" | fzf --prompt="OS:" | awk '{print $1}')"
        if ( -z ${os_id} )
        {
            os_id=$(vultr-cli os list | grep 'Arch Linux' | head -1 | awk '{print $1}')
        }
    
        $plan_id="$(write-output "${plans_list}" | fzf | awk '{print $1}')"
        if ( -z ${plan_id} )
        {
            $plan_id='vc2-1c-1gb'
        }
    
        $region_id="$(write-output "${regions_list}" | fzf | awk '{print $1}')"
        if ( -z ${region_id} )
        {
            $region_id='lax'
        }
    
        $private_network="$(write-output "false`ntrue" | fzf --prompt="Enable Private Network:" )"
        if ( -z ${private_network} )
        {
            $private_network='false'
        }
    
        $ddos_protection="$(write-output "false`ntrue" | fzf --prompt="Enable DDOS protection:" )"
        if ( -z ${ddos_protection} )
        {
            $ddos_protection='false'
        }
    
        $enable_ipv6="$(write-output "false`ntrue" | fzf --prompt="Enable IPv6:" )"
        if ( -z ${enable_ipv6} )
        {
            $enable_ipv6='false'
        }
    
        $use_ssh_keys="$(write-output "true`nfalse" | fzf --prompt="Use SSH key:" )"
        if ( -z ${use_ssh_keys} )
        {
            $use_ssh_keys="false"
        }
    
        if ( ${use_ssh_keys} -eq "true" )
        {
            ssh_key_list=$(vultr-cli ssh-key list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
            $ssh_key_id="$(write-output "${ssh_key_list}" | fzf | awk '{print $1}')"
    
            $extra_args+="--ssh-keys ${ssh_key_id} "
        }
    
        $use_script="$(write-output "true`nfalse" | fzf --prompt="Run script:" )"
        if ( -z ${use_script} )
        {
            $use_script='false'
        }
    
        if ( ${use_script} -eq "true" )
        {
            script_list=$(vultr-cli script list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
            $script_id="$(write-output "${script_list}" | fzf | awk '{print $1}')"
    
            extra_args+="--script-id ${script_id} "
        }
    
        $use_firewall_group="$(write-output "true`nfalse" | fzf --prompt="Add to firewall group:" )"
        if ( -z ${use_firewall_group} )
        {
            $use_firewall_group='false'
        }
    
        if ( ${use_firewall_group} -eq "true" )
        {
            firewall_list=$(vultr-cli firewall group list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
            $firewall_id="$(write-output "${firewall_list}" | fzf | awk '{print $1}')"
    
            extra_args+="--firewall-group ${firewall_id} "
        }
    
        write-output "`n`nCreate instance with following parameters: `nvultr-cli instance create \\ `n    --host ${hostname} \\ `n    --label ${hostname} \\ `n    --os ${os_id} \\ `n    --plan ${plan_id} \\ `n    --private-network ${private_network} \\ `n    --region ${region_id} \\ `n    --ipv6 ${enable_ipv6} \\ `n    --ddos ${ddos_protection} \\ `n    --notify false \\ `n    ${extra_args} `n`n"
        echo "Type YES to create instance"
        $input = read-host -prompt "Type YES to create instance"
    
        if ( ${input} -eq 'YES' )
        {
                vultr-cli instance create `
                    --host ${hostname} `
                    --label ${hostname} `
                    --os ${os_id} `
                    --plan ${plan_id} `
                    --private-network ${private_network} `
                    --region ${region_id} `
                    --ipv6 ${enable_ipv6} `
                    --ddos ${ddos_protection} `
                    --notify false `
                    ${extra_args}
        }
    
    }
    
    if ( ${action} -eq 'instance-list' )
    {
         vultr-cli instance list | sed -n '/^-eq=/q;p'    
    }
    
    if ( ${action} -eq 'instance-destroy' )
    {
        instance_list=$(vultr-cli instance list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
        $instance="$(write-output "${instance_list}" | fzf --prompt="Instance to delete:")"
    
        echo "Delete instance: ${instance}"
        echo "Type YES"
        read input
    
        $instance_id="$(write-output "${instance}" | awk '{print $1}')"
    
        ( ${input} -eq 'YES' ) && vultr-cli instance delete ${instance_id}
    }
    
    if ( ${action} -eq 'instance-reboot' )
    {
        instance_list=$(vultr-cli instance list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
        $instance="$(write-output "${instance_list}" | fzf --prompt="Instance to reboot:")"
        $instance_id="$(write-output "${instance}" | awk '{print $1}')"
    
        ( -n ${instance_id} ) && vultr-cli instance restart ${instance_id}
    }
    
    if ( ${action} -eq 'instance-shutdown' )
    {
        instance_list=$(vultr-cli instance list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
        $instance="$(write-output "${instance_list}" | fzf --prompt="Instance to shutdown:")"
        $instance_id="$(write-output "${instance}" | awk '{print $1}')"
    
        ( -n ${instance_id} ) && vultr-cli instance stop ${instance_id}
    }
    
    if ( ${action} -eq 'instance-start' )
    {
        instance_list=$(vultr-cli instance list | grep -vE '^ID' | sed -n '/^-eq=/q;p')
        $instance="$(write-output "${instance_list}" | fzf --prompt="Instance to start:")"
        $instance_id="$(write-output "${instance}" | awk '{print $1}')"
    
        ( -n ${instance_id} ) && vultr-cli instance start ${instance_id}
    }
}
