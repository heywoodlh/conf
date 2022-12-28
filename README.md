## Quickstart

```
git clone --depth=1 https://github.com/heywoodlh/conf ~/opt/conf
cd ~/opt/conf
pwsh -executionpolicy bypass -file $HOME/opt/conf/setup.ps1 
```

Or if you just want to test out the environment, run [the container](https://hub.docker.com/r/heywoodlh/conf):

```
docker run -it --rm heywoodlh/conf
```
