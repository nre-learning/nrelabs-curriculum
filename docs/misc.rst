# old postgres stuff that we don't need now that we're not using the original guac frontend


```
gcloud compute scp initdb.sql db0:~
```


```
sudo cp initdb.sql /var/lib/pgsql
sudo -i -u postgres
createuser -P -s -e guacuser
#guacuser/guac

createdb guacamole_db

psql -f initdb.sql guacamole_db
```



CREATE DATABASE guacamole_db;  

psql -d guacamole_db -a -f initdb.sql

psql -d guacamole_db

\d

CREATE USER guacadmin WITH PASSWORD 'guacadmin';
CREATE USER guac_user WITH PASSWORD 'guac';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO guac_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO guacadmin;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO guac_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO guacadmin;


list databases
\l

list tables in this database
\dt

Quit
\q

connect remotely
psql -h db0 -p 5432 -U guac_user -d guacamole_db -W