## Quickstart

Assuming you have PowerShell Core 7.2+ and [Peru](https://github.com/buildinspace/peru) installed:

```
git clone --depth=1 https://github.com/heywoodlh/conf ~/opt/conf
cd ~/opt/conf
pwsh -executionpolicy bypass -file $HOME/opt/conf/setup.ps1 
python3 -m peru sync
```

Or if you just want to test out the environment, run [the container](https://hub.docker.com/r/heywoodlh/conf):

```
docker run -it --rm -w /home/heywoodlh heywoodlh/conf
```

### Windows:

Run the following PowerShell snippet to install my Windows environment:

```
if (-not (test-path $HOME\opt\conf\setup.ps1)) {
    Invoke-WebRequest -Uri "https://github.com/heywoodlh/conf/archive/refs/heads/master.zip" -OutFile "$HOME\Downloads\conf.zip"
    Expand-Archive -Force -Path "$HOME\Downloads\conf.zip" -DestinationPath "$HOME\Downloads\"
    Remove-Item "$HOME\Downloads\conf.zip"
    New-Item -ItemType Directory -ErrorAction SilentlyContinue -Path "$HOME\opt\"
    Move-Item -Path "$HOME\Downloads\conf-master" -Destination "$HOME\opt\conf"
}
powershell.exe -ExecutionPolicy Bypass -File $HOME\opt\conf\dependencies\windows\install.ps1
```
