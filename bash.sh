#!/bin/bash

/etc/init.d/postgresql restart
sudo -u postgres createuser osm
sudo -u postgres createdb transilien -O osm
sudo -u postgres psql transilien <<-EOL
 transilien=# CREATE EXTENSION postgis;
 transilien=# CREATE EXTENSION hstore;
EOL

osm2pgsql -G -U osm -d transilien ile-de-france-latest.osm.pbf --hstore --create
osm2pgsql -G -U osm -d transilien path/to/picardie-latest.osm.pbf --hstore --append


