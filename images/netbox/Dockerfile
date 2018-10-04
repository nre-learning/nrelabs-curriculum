FROM centos

RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
    && yum install -y postgresql96 postgresql96-server postgresql96-devel \
    && yum install -y epel-release \
    && yum install -y gcc python34 python34-devel python34-setuptools libxml2-devel libxslt-devel libffi-devel graphviz openssl-devel redhat-rpm-config wget \
    && easy_install-3.4 pip \
    && wget https://github.com/digitalocean/netbox/archive/v2.4.5.tar.gz \
    && tar -xzf v2.4.5.tar.gz -C /opt \
    && cd /opt/ \
    && ln -s netbox-2.4.5/ netbox \
    && cd /opt/netbox/ \
    && pip3 --no-cache-dir install -r  requirements.txt \
    && pip3 --no-cache-dir install  napalm \
    && cd netbox/netbox/ \
    && cp configuration.example.py configuration.py \
    && sed -i "/^ALLOWED_HOSTS/s/\[\]/\['netbox'\]/" configuration.py \
    && sed -i "/PostgreSQL username/s/''/'netbox'/" configuration.py \
    && sed -i "/PostgreSQL password/s/''/'netbox'/" configuration.py \
    && sed -i "/^SECRET_KEY/s/''/'abcdefghijklmnopqrstuvwxyz0123456789ANTIDOTELABS!!'/" configuration.py \
    && sed -i "/^NAPALM_USERNAME/s/''/'vrnetlab'/" configuration.py \
    && sed -i "/^NAPALM_PASSWORD/s/''/'VR-netlab9'/" configuration.py \
    && sed -i "/^PREFER_IPV4/s/False/True/" configuration.py \
    && su - postgres -c "/usr/pgsql-9.6/bin/initdb -D /var/lib/pgsql/9.6/data" \
    && su - postgres -c "/usr/pgsql-9.6/bin/pg_ctl start -w -D /var/lib/pgsql/9.6/data" \
    && su - postgres -c "psql -c \"CREATE DATABASE netbox;\"" \
    && su - postgres -c "psql -c \"CREATE USER netbox WITH PASSWORD 'netbox';\"" \
    && su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox;\"" \
    && sed -i "/^host/s/trust/md5/" /var/lib/pgsql/9.6/data/pg_hba.conf \
    && cd /opt/netbox/netbox \
    && python3 manage.py migrate \
    && echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('netbox', 'netbox@netbox.com', 'netbox')" | python3 manage.py shell \
    && python3 manage.py collectstatic --no-input \
    && python3 manage.py loaddata initial_data \
    && su - postgres -c "/usr/pgsql-9.6/bin/pg_ctl stop -D /var/lib/pgsql/9.6/data" \
    && yum erase -y epel-release postgresql96-devel gcc python34-devel python34-setuptools libxml2-devel libxslt-devel openssl-devel redhat-rpm-config wget \
    && yum -y autoremove \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY launch.sh /root/launch.sh

EXPOSE 8080

CMD ["/root/launch.sh"]

