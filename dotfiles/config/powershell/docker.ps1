function amap() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux amap $args }

function amass() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp caffix/amass $args }

# Reminder: ${HOME}/.guerrillamail within the container is a config _file_ not a directory
function anon-mail() { New-Item -ItemType Directory -Path ${HOME}/.local/guerrillamail/ 2> $null && docker run -it --rm -v ${HOME}/.local/guerrillamail:/root/ heywoodlh/guerrillamail $args }

function archinstall() { docker run --rm -it --name archinstall --privileged -v /dev/bus/usb:/dev/bus/usb heywoodlh/archinstall $args }

function arpspoof() { docker run -it --rm --net host -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux arpspoof -i eth0 $args }	

function assetfinder() { docker run --rm -i heywoodlh/tomnomnom-tools:latest assetfinder $args }

function beef() {
    new-item -erroraction silentlycontinue -itemtype directory -path ${HOME}/.local/beef
    if (! (test-path ~/.local/beef/config.yaml)) {
	write-output "downloading generic beef config"
        curl --silent https://gist.github.com/heywoodlh/5d503e14f91ff9e5d6d4794aeffda652/raw/c64c4a2cec92d7af36bdb908ebe98fd42926b98c/config.yaml -o ${HOME}/.local/beef/config.yaml
    }
    docker run -it --rm -p 3000:3000 -p 6789:6789 -p 61985 -p 61986 -v "${HOME}/.local/beef/config.yaml:/beef/config.yaml" heywoodlh/beef $@
}

function bettercap() { docker run -it --privileged --net=host bettercap/bettercap $args }

Set-Alias -Name centos -Value "docker run -it --rm centos bash"

function cloud_enum() { docker run -it --rm -w /data -v "$((get-location).path):/data" heywoodlh/cloud_enum $args }

function cme() { crackmapexec $args }

function commix() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux commix $args }

function crackmapexec() { 
    new-item -itemtype directory -path ${HOME}/.local/share/cme -erroraction silentlycontinue
    docker run -v ${HOME}/.local/share/cme:/root/.cme -it --rm heywoodlh/crackmapexec $args 
}

function dirb() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux dirb $args }

function dnschef() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --net host heywoodlh/kali-linux dnschef $args }

function dnsenum() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux dnsenum $args }

function dnsmap() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux dnsmap $args }

function dnsrecon() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux dnsrecon $args }

function dnswalk() { docker run -it --rm heywoodlh/kali-linux dnswalk $args }

function elinks() { New-Item -ItemType Directory -Path ${HOME}/.config/elinks && docker run -v ${HOME}/Downloads:/home/links/Downloads -v ${HOME}/.config/elinks:/home/elinks/.elinks -it --rm heywoodlh/elinks:latest $args }

function evilginx() { docker run --name evilginx -it --rm -p 53:53 -p 80:80 -p 443:443 heywoodlh/evilginx2 $args }

function freyr() { docker run -it --rm -v "$((get-location).path):/data" -w /data freyrcli/freyrjs $args }

function gf() { docker run --rm -it heywoodlh/tomnomnom-tools:latest gf $args }

function gomuks { 
    New-Item -ItemType Directory -Path ${HOME}/tmp 2> $null
    New-Item -ItemType Directory -Path ${HOME}/Downloads 2> $null
    New-Item -ItemType Directory -Path ${HOME}/.local/gomuks/config 2> $null
    New-Item -ItemType Directory -Path ${HOME}/.local/gomuks/cache 2> $null 
    New-Item -ItemType Directory -Path ${HOME}/.local/gomuks/share 2> $null

    docker run --rm -it -e TZ=America/Denver -e TMUX='' -v ${HOME}/.local/gomuks/cache:/home/gomuks/.cache/gomuks -v ${HOME}/.local/gomuks/share:/home/gomuks/.local/share/gomuks -v ${HOME}/.local/gomuks/config:/home/gomuks/.config/gomuks -v ${HOME}/Downloads:/home/gomuks/Downloads -v ${HOME}/tmp:/tmp heywoodlh/gomuks $args 
}

function gron() { docker run --rm -i heywoodlh/tomnomnom-tools:latest gron $args }

function grype() { 
    new-item -itemtype Directory -path ${HOME}/.docker -erroraction silentlycontinue
    docker run -v ${HOME}/.docker:/root/.docker -v "$((get-location).path):/data" -w /data -it --rm anchore/grype $args 
}

function gscript() { docker run -it --rm -v ${HOME}/tmp:/tmp -v "$((get-location).path):/root/gscript" -w /root/gscript gen0cide/gscript:v1 /root/go/bin/gscript $args }

function guerrillamail() { anon-mail $args }

function hping3() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux hping3 $args }

function httping() { docker run --rm bretfisher/httping $args }

function httprobe() { docker run --rm -i heywoodlh/tomnomnom-tools:latest httprobe $args }

function httrack() { docker run --rm -it --net host -v "$((get-location).path)":/app -w /app heywoodlh/httrack $args }

function hydra() { docker run --rm --net host -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --privileged heywoodlh/kali-linux hydra $args }

function inim() { docker run -it --rm -v "$((get-location).path)":/app -w /app heywoodlh/inim $args }

function jekyll() { docker run --rm -it -p 4000:4000 -v "$((get-location).path)":/srv/jekyll jekyll/jekyll:3.8 jekyll $args }

function kali() { docker run -it --rm --net host --privileged heywoodlh/kali-linux /bin/bash $args }

function lacework() { docker run -i --rm heywoodlh/lacework-cli:latest $args }

function links() { docker run -v ${HOME}/Downloads:/home/links/Downloads -it --rm heywoodlh/links:latest $args }

function marp() { docker run --rm -v "$((get-location).path)":/home/marp/app/ -e LANG=$LANG marpteam/marp-cli $args }

function masscan() { docker run --rm --net host -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --privileged heywoodlh/telnet masscan $args }

function medusa() { docker run -i --rm heywoodlh/kali-linux medusa $args }

function meg() { docker run -v "$((get-location).path):/data" -w /data --rm -it heywoodlh/tomnomnom-tools:latest meg $args }

Set-Alias -Name metasploitable -Value 'docker run -it --rm --name vulnerable --net=host heywoodlh/vulnerable'

function mitmproxy() { docker run --rm -it -p 8080:8080 -p 127.0.0.1:8081:8081 mitmproxy/mitmproxy mitmweb --web-iface 0.0.0.0 $args }

function msfconsole() { 
    New-Item -ItemType Directory -Path ${HOME}/.local/metasploit -erroraction silentlycontinue
    docker run -it --rm --net host -v ${HOME}/.local/metasploit/:/root/.msf4 -w /root/session -v "$((get-location).path):/root/session" heywoodlh/metasploit msfconsole $args 
}

function msfvenom() { 
    New-Item -ItemType Directory -Path ${HOME}/.local/metasploit -erroraction silentlycontinue 
    docker run -it --rm -v ${HOME}/.local/metasploit/:/root/.msf4 -w /root/session -v "$((get-location).path):/root/session" heywoodlh/metasploit msfvenom $args
}

function nc() { docker run --rm -i --net host heywoodlh/telnet nc $args }

function netcat() { docker run --rm -i --net host heywoodlh/telnet nc $args }

function netscan() { docker run -it --rm --net host heywoodlh/netscan $args }

function netdiscover() { docker run -it --rm --net host -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux netdiscover }

function nikto() { docker run -it --rm --net host -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/nikto $args }

function nim() { docker run -it --rm -v "$((get-location).path):/app" -w /app heywoodlh/nim nim $args }

function nimble() { docker run -it --rm -v "$((get-location).path):/app" -w /app heywoodlh/nim nimble $args }

function nmap() {
    docker run --rm -v "$((get-location).path):/data" -w /data --net host --privileged heywoodlh/telnet nmap $args 
}

function nuclei() { 
    New-Item -ItemType Directory -Path ${HOME}/.local/nuclei/templates -erroraction silentlycontinue
    New-Item -ItemType Directory -Path ${HOME}/.local/nuclei/config -erroraction silentlycontinue
    docker run --rm -v ${HOME}/.local/nuclei/templates:/root/nuclei-templates -v ${HOME}/.local/nuclei/config:/root/.config/nuclei -v "$((get-location).path):/data" -w /data --net host -it projectdiscovery/nuclei $args 
}

function pacu() { docker run -it --rm heywoodlh/pacu $args}

function padbuster() { docker run -it --rm heywoodlh/kali-linux padbuster $args }

function poezio() { 
    new-item -itemtype directory -path $HOME/.config/poezio -erroraction silentlycontinue
    new-item -itemtype directory -path $HOME/.local/share/poezio -erroraction silentlycontinue
    docker run -it --rm -v $HOME/.config/poezio:/home/poezio-user/.config/poezio -v $HOME/.local/share/poezio:/home/poezio-user/.local/share/poezio poezio/poezio
}

function powershell() { docker run -v ${HOME}/.config/powershell:/root/.config/powershell -it --rm heywoodlh/powershell }

function pret() { docker run -it --rm slothdotexe/pret-docker /home/user/PRET/pret.py $args }

function pyoxidizer() { docker run -it --rm -v "$((get-location).path):/data" -w /data heywoodlh/pyoxidizer:latest $args }

function reaver() { docker run -it --rm --net host --privileged -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux reaver $args }

function responder() { docker run -it --rm --net host heywoodlh/kali-linux responder $args }

function searchsploit() { docker run --rm heywoodlh/kali-linux searchsploit $args }

function setoolkit() { docker run -it --rm --net host -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux setoolkit $args }

function shodan() { 
    New-Item -ItemType Directory -Path ${HOME}/.local/shodan -erroraction silentlycontinue
    docker run -v "$((get-location).path):/data" -w /data --rm -it -v ${HOME}/.local/shodan:/root/.shodan heywoodlh/shodan-cli $args
}

function sniper() { docker run --rm -ti menzo/sn1per-docker sniper $args }

function sqlmap() { docker run -it --rm --net host -w /data -v ${HOME}/.sqlmap:/root/.sqlmap -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux sqlmap $args }

function socat() { docker run --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --net host heywoodlh/kali-linux socat $args }

function speedtest() { docker run --rm -it heywoodlh/speedtest-cli $args }

function sublist3r() { docker run -it --rm heywoodlh/sublist3r:latest $args }

function syft() { docker run -v "$((get-location).path):/data" -w /data -it --rm anchore/syft $args }

function takeover() { docker run -it --rm -w /data -v "$((get-location).path):/data" heywoodlh/takeover $args}

function telnet() { docker run --rm -i heywoodlh/telnet telnet $args }

function theharvester() { docker run --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux theHarvester $args }

function traceroute() { docker run --rm -it --net host jess/traceroute $args }

function trivy() { docker run -v "$((get-location).path)":/app -w /app -it --rm aquasec/trivy $args }

function trufflehog() { docker run -it -w /data -v "$((get-location).path):/data" trufflesecurity/trufflehog:latest $args }

function tshark() { docker run --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --net host --privileged heywoodlh/kali-linux tshark $args }

Set-Alias -Name ubuntu -Value "docker run -it --rm ubuntu bash"

function unfurl() { docker run --rm -i heywoodlh/tomnomnom-tools:latest unfurl $args }

function vulnscan() { docker run --rm --net host -v "$((get-location).path):/data" -w /data --privileged heywoodlh/telnet nmap -sV --script=vulners.nse $args }

function wash() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp --net host --privileged heywoodlh/kali-linux wash $args }

function wifite() { docker run -it --rm --net host --privileged -w /tmp/wifite -v "$((get-location).path)":/tmp/wifite heywoodlh/wifite $args }

function wpscan() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux wpscan $args }

function yersinia() { docker run -it --rm -w /data -v "$((get-location).path):/data" -v ${HOME}/tmp:/tmp heywoodlh/kali-linux yersinia $args }

