FROM python AS peru-build
COPY ./scripts /scripts

RUN /scripts/peru.sh

# Download repo and run peru
RUN git clone --depth=1 https://github.com/heywoodlh/conf /opt/conf \
    && cd /opt/conf \
    && printf "PERU VERSION: $(peru --version)" \
    && peru sync

## Clean up caches
RUN pip3 cache purge \
    && rm -rf /var/lib/apt/lists/* 

FROM golang:buster AS go-build

COPY ./scripts /scripts

RUN /scripts/kind.sh \
    && /scripts/k9s.sh

FROM heywoodlh/powershell
LABEL MAINTAINER=heywoodlh

## Install packages 
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker.io \
    curl \
    tmux \
    git \
    openssh-client \
    vim \
    gnupg \
    sudo 

## Install stuff not included in apt repos
COPY ./scripts /scripts

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
RUN rm -rf /var/lib/apt/lists/* 
 
## Create heywoodlh
RUN useradd -m -s /usr/bin/pwsh heywoodlh \
    && mkdir -p /etc/sudoers.d/ && printf 'heywoodlh ALL=(ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers.d/heywoodlh \
    && mkdir -p /home/heywoodlh/opt

## For Docker in Docker
RUN usermod -aG docker heywoodlh

RUN chown -R heywoodlh /home/heywoodlh/opt

USER heywoodlh 

## Copy repo from peru-build to  
COPY --from=peru-build /opt/conf /home/heywoodlh/opt/conf

RUN pwsh -executionpolicy bypass -file /home/heywoodlh/opt/conf/setup.ps1

ENTRYPOINT ["ssh-agent", "pwsh"]
