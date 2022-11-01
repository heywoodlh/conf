## Multistage build for bulkier stuff
FROM heywoodlh/trizen AS kind-build

RUN trizen -Sy --noconfirm gcc kind

FROM heywoodlh/trizen
LABEL MAINTAINER=heywoodlh

RUN trizen -Sy --noconfirm docker git openssh vim kubectl helm ansible peru powershell-bin sudo \
    && trizen -Scc

USER root

COPY --from=kind-build /usr/bin/kind /usr/bin/kind

## Delete Trizen user
RUN userdel -r trizen \
    && rm -rf /home/trizen

## Create heywoodlh
RUN useradd -m -s /usr/bin/pwsh heywoodlh \
    && mkdir -p /etc/sudoers.d/ && printf 'heywoodlh ALL=(ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers.d/heywoodlh

USER heywoodlh 
RUN mkdir -p /home/heywoodlh/opt
COPY . /home/heywoodlh/opt/conf 

WORKDIR /home/heywoodlh/opt/conf
RUN git remote remove origin && git remote add origin git@github.com:heywoodlh/conf 

RUN pwsh -C '. /home/heywoodlh/opt/conf/setup.ps1' 

ENTRYPOINT ["pwsh"]
