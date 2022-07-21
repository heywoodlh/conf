FROM alpine
LABEL MAINTAINER=heywoodlh

ENV SKIP_HOMEBREW_INSTALL='true'

RUN apk --no-cache add sudo zsh bash py3-pip git openssh-client shadow docker-cli

## Create heywoodlh
RUN useradd -m -s /bin/zsh heywoodlh \
    && mkdir -p /etc/sudoers.d/ && printf 'heywoodlh ALL=(ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers.d/heywoodlh

USER heywoodlh 
COPY . /home/heywoodlh/opt/conf
RUN sudo chown -R heywoodlh /home/heywoodlh/opt/conf

WORKDIR /home/heywoodlh/opt/conf
RUN ./setup.sh workstation \
    && sudo rm -rf /var/lib/apt/lists/*

RUN /home/heywoodlh/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install 

## Clear cache
RUN pip3 cache purge && sudo pip3 cache purge

ENTRYPOINT ["zsh"]
