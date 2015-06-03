#!/bin/bash
set -e
/etc/init.d/postgresql restart

sudo -u postgres createuser "$USER"
sudo -u postgres createdb -O "$USER" "$DB"
sudo -u postgres psql -d "$DB" -c 'CREATE EXTENSION hstore; CREATE EXTENSION postgis;'
sudo -u postgres psql -d "$DB" -c 'ALTER TABLE geometry_columns OWNER TO "$USER"; ALTER TABLE spatial_ref_sys OWNER TO "$USER";'

sudo -u postgres psql -d "$DB" -c 'GRANT ALL ON DATABASE "$DB" TO "$USER";'
echo "/etc/postgresql/9.3/main/pg_hba.conf"
sed s/peer/trust/ /etc/postgresql/9.3/main/pg_hba.conf > /tmp/pg_hba.conf
mv /tmp/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
cat /etc/postgresql/9.3/main/pg_hba.conf
echo "EOF /etc/postgresql/9.3/main/pg_hba.conf"
#sudo -u postgres psql -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql -d gis
#sudo -u postgres psql -d transilien -c "ALTER TABLE geometry_columns OWNER TO osm; ALTER TABLE spatial_ref_sys OWNER TO osm;"
/etc/init.d/postgresql restart

osm2pgsql -G -U "$USER" -d "$DB" ile-de-france-latest.osm.pbf --hstore --create
osm2pgsql -G -U "$USER" -d "$DB" picardie-latest.osm.pbf --hstore --append


