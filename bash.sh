#!/bin/bash
set -e

sudo -u postgres postgres --single -jE <<-EOL
  CREATE USER osm;
EOL

sudo -u postgres postgres --single -jE <<-EOL
  CREATE DATABASE transilien;
EOL

sudo -u postgres postgres --single -jE <<-EOL
  GRANT ALL ON DATABASE transilien TO osm;
EOL
#sudo -u postgres psql -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql -d gis
#sudo -u postgres psql -d transilien -c "ALTER TABLE geometry_columns OWNER TO osm; ALTER TABLE spatial_ref_sys OWNER TO osm;"
/etc/init.d/postgresql restart

sudo -u postgres psql transilien <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  ALTER TABLE geometry_columns OWNER TO osm;
  ALTER TABLE spatial_ref_sys OWNER TO osm;
EOL

osm2pgsql -G -U osm -d transilien ile-de-france-latest.osm.pbf --hstore --create
osm2pgsql -G -U osm -d transilien picardie-latest.osm.pbf --hstore --append


