#!/usr/bin/env bash

apt-get update && apt-get install -y ca-certificates curl 
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B53DC80D13EDEF05
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl
rm -rf /var/lib/apt/lists/*
