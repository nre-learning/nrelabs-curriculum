#!/usr/bin/env bash


ip address flush dev net1
ip address add 10.10.300.10/24 dev net1
ip route add 10.10.0.0/16 via 10.10.300.1 dev net1


su - postgres -c "/usr/pgsql-9.6/bin/pg_ctl start -w -D /var/lib/pgsql/9.6/data"
cd cd /opt/netbox/netbox
python3 manage.py runserver 0.0.0.0:8000 --insecure


