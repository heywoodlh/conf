#!/usr/bin/env bash

apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

curl -L "https://awscli.amazonaws.com/awscli-exe-linux-$(arch).zip" -o "/opt/awscliv2.zip"

cd /opt/

unzip awscliv2.zip

/opt/aws/install
