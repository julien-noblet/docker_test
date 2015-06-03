FROM ubuntu:14.04
RUN apt-get update \
      && apt-get install -y postgresql-client-9.3 postgresql-9.3-postgis-2.1 osm2pgsql

RUN sudo -u postgres pg_ctl -w start
RUN sudo -u postgres createuser osm
RUN sudo -u postgres createdb transilien -O osm
RUN sudo -u postgres psql transilien <<-EOL
 transilien=# CREATE EXTENSION postgis;
 transilien=# CREATE EXTENSION hstore;
EOL

RUN wget http://download.geofabrik.de/europe/france/ile-de-france-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/picardie-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/centre-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/haute-normandie-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/champagne-ardenne-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/bourgogne-latest.osm.pbf

RUN osm2pgsql -G -U osm -d transilien ile-de-france-latest.osm.pbf --hstore --create
RUN osm2pgsql -G -U osm -d transilien path/to/picardie-latest.osm.pbf --hstore --append

