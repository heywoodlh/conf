#!/usr/bin/env bash

git clone --depth=1 https://github.com/derailed/k9s /opt/k9s
cd /opt/k9s
make build
cp ./execs/k9s /usr/local/bin/k9s
cd
rm -rf /opt/k9s
