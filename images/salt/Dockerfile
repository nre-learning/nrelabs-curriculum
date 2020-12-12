FROM antidotelabs/utility

# Because tzdata comes with an interactive installer wizard to configure
# your timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

RUN wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
    echo "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main" >> /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y
RUN apt-get --auto-remove --yes remove python-openssl
RUN pip3 install -r requirements.txt

RUN apt-get install -y salt-master salt-minion

# configure minion and proxy
COPY ./salt_configs/master /etc/salt
COPY ./salt_configs/minion /etc/salt
COPY ./salt_configs/proxy /etc/salt

RUN service salt-minion restart
RUN service salt-master restart

# Add pillar file for vqfx1
RUN mkdir /srv/pillar
COPY ./salt_configs/vqfx1.sls /srv/pillar

# Add pillar file for top
COPY ./salt_configs/top.sls /srv/pillar

# Add salt file for infrastructure data
COPY ./salt_configs/infrastructure_data.sls /srv/pillar

# Add configuration template for vqfx1
RUN mkdir /srv/salt
COPY ./salt_configs/infrastructure_config.conf /srv/salt

# Add sls file to provision the configuration
COPY ./salt_configs/provision_infrastructure.sls /srv/salt

# set user permissions for Antidote user to run Salt
RUN chown -R antidote:antidote /etc/salt
RUN chown -R antidote:antidote /var/cache/salt
RUN chown -R antidote:antidote /srv
RUN chown -R antidote:antidote /var/log/salt
RUN chown -R antidote:antidote /var/run/salt
# RUN chown -R antidote:antidote /var/run/salt-master.pid
# RUN chmod -R 777 /var/run/salt-master.pid
RUN chown antidote:antidote /var/run
RUN chmod 777 /var/run
