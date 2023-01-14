FROM ubuntu:20.04
LABEL maintainer="Christophe Antoniewski <drosofff@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  && \
    \
    \
    echo "===> Allow start of services"  && \
    echo "exit 0" > /usr/sbin/policy-rc.d  && \
    \
    apt-get install -qq --no-install-recommends \
    apt-transport-https software-properties-common \
    apt-utils proftpd proftpd-mod-pgsql git nano \
    locales python3-pip

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     


RUN apt-get install sudo -o Dpkg::Options::="--force-confold" && \
    echo 'root ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
    echo 'postgres ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ONBUILD  RUN  DEBIAN_FRONTEND=noninteractive  apt-get update   && \
              echo "===> Updating TLS certificates..."         && \
              apt-get install -y openssl ca-certificates


COPY  .  /setup
WORKDIR /setup

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

# install ansible 2.10.1 environment
RUN python3 -m pip install -U pip && python3 -m pip install ansible==2.10.1

EXPOSE :80
EXPOSE :21
EXPOSE :8800
EXPOSE :9002

RUN apt update && \
    ansible-galaxy install -r requirements.yml -p roles -f && \
    ansible-playbook -i environments/Docker/hosts -c local playbook.yml

# CMD ["bash", "/setup/inventory_files/docker"]
