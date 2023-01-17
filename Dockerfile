FROM artbio_postgre:latest
LABEL maintainer="Christophe Antoniewski <drosofff@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update  && \
    \
    \
    echo "===> Allow start of services"  && \
    echo "exit 0" > /usr/sbin/policy-rc.d  && \
    \
    apt-get install -qq --no-install-recommends \
    apt-transport-https software-properties-common \
    apt-utils proftpd proftpd-mod-pgsql git nano \
    locales dirmngr python3-virtualenv

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

RUN mkdir /etc/ssl/private-copy /var/lib/postgresql-copy && \
    mv /var/lib/postgresql/* /var/lib/postgresql-copy && \
    mv /etc/ssl/private/* /etc/ssl/private-copy/ && \
    rm -R /var/lib/postgresql /etc/ssl/private/ && \
    mv /var/lib/postgresql-copy /var/lib/postgresql && \
    mv /etc/ssl/private-copy /etc/ssl/private && \
    chmod -R 0700 /var/lib/postgresql /etc/ssl/private && \
    chown -R postgres:postgres /var/lib/postgresql /var/run/postgresql \
    /var/log/postgresql /etc/ssl/private /etc/postgresql


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

EXPOSE :80
EXPOSE :21
EXPOSE :8800
EXPOSE :9002

RUN mkdir -p /setup/.ansible/tmp && chmod 777 /setup/.ansible/tmp && \
    echo "remote_tmp = /setup/.ansible/tmp" >> ansible.cfg && \
    service postgresql start && \
    ansible --version && \
    ansible-galaxy install -r requirements.yml -p roles -f && \
    ansible-playbook -i environments/Docker/hosts -c local playbook.yml

CMD service supervisord start && service postgresql start && service nginx start
