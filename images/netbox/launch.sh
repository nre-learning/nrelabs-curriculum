#!/usr/bin/env bash


ip address change 10.10.50.10/24 dev net1
ip route add 10.0.0.0/8 via 10.10.50.1 dev net1


su - postgres -c "/usr/pgsql-9.6/bin/pg_ctl start -w -D /var/lib/pgsql/9.6/data"
cd cd /opt/netbox/netbox
python3 manage.py runserver 0.0.0.0:8000 --insecure


