FROM golang:buster AS go-build

COPY ./scripts /scripts

RUN /scripts/kind.sh \
    && /scripts/k9s.sh

FROM heywoodlh/powershell
LABEL MAINTAINER=heywoodlh

## Install packages 
RUN apt-get update && apt-get install -y \
    docker.io \
    curl \
    tmux \
    git \
    openssh-client \
    python3-pip \
    vim \
    sudo 

## Install stuff not included in apt repos
COPY ./scripts /scripts

## peru install
RUN /scripts/peru.sh

## ansible install
RUN /scripts/ansible.sh

## aws cli install
RUN /scripts/aws.sh
   
## kubectl install
RUN /scripts/kubectl.sh

## kind install
COPY --from=go-build /go/bin/kind /usr/local/bin/kind

## k9s install
COPY --from=go-build /go/bin/k9s /usr/local/bin/k9s

## helm install
RUN /scripts/helm.sh

## Clean up caches
RUN pip3 cache purge \
    && rm -rf /var/lib/apt/lists/* 
 
## Create heywoodlh
RUN useradd -m -s /usr/bin/pwsh heywoodlh \
    && mkdir -p /etc/sudoers.d/ && printf 'heywoodlh ALL=(ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers.d/heywoodlh \
    && mkdir -p /home/heywoodlh/opt

## Copy repo to target directory
COPY ../ /home/heywoodlh/opt/conf 
RUN chown -R heywoodlh /home/heywoodlh/opt

USER heywoodlh 

RUN pwsh -executionpolicy bypass -file /home/heywoodlh/opt/conf/setup.ps1 

ENTRYPOINT ["pwsh"]
