FROM alpine
LABEL MAINTAINER=heywoodlh

ENV SKIP_HOMEBREW_INSTALL='true'

RUN apk --no-cache add sudo zsh bash py3-pip git openssh-client shadow docker-cli
RUN apk --no-cache add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing ansible kubectl helm kind

## Create heywoodlh
RUN useradd -m -s /bin/zsh heywoodlh \
    && mkdir -p /etc/sudoers.d/ && printf 'heywoodlh ALL=(ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers.d/heywoodlh

USER heywoodlh 
RUN mkdir -p /home/heywoodlh/opt \
    && git clone --depth=1 https://github.com/heywoodlh/conf /home/heywoodlh/opt/conf 

WORKDIR /home/heywoodlh/opt/conf
RUN git remote remove origin && git remote add origin git@github.com:heywoodlh/conf 

RUN ./setup.sh workstation 

## Setup gitstatusd
RUN /home/heywoodlh/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install 

## Clear cache
RUN pip3 cache purge && sudo pip3 cache purge

ENTRYPOINT ["zsh"]
