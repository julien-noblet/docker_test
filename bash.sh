#!/bin/bash
set -e
/etc/init.d/postgresql restart

sudo -u postgres createuser osm
sudo -u postgres createdb -O osm transilien
sudo -u postgres psql -d transilien -c 'CREATE EXTENSION hstore; CREATE EXTENSION postgis;'
sudo -u postgres psql -d transilien -c 'CREATE EXTENSION postgis; ALTER TABLE geometry_columns OWNER TO username; ALTER TABLE spatial_ref_sys OWNER TO username;'

sudo -u postgres psql -d transilien -c 'GRANT ALL ON DATABASE transilien TO osm;'

#sudo -u postgres psql -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql -d gis
#sudo -u postgres psql -d transilien -c "ALTER TABLE geometry_columns OWNER TO osm; ALTER TABLE spatial_ref_sys OWNER TO osm;"
/etc/init.d/postgresql restart

osm2pgsql -G -d transilien ile-de-france-latest.osm.pbf --hstore --create
osm2pgsql -G -d transilien picardie-latest.osm.pbf --hstore --append


