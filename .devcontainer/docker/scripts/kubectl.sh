#!/usr/bin/env bash

apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(arch)/kubectl" -o /usr/local/bin/kubectl
