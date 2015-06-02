FROM ubuntu:14.04
RUN apt-get update \
      && apt-get install -y postgresql-client-9.3 postgresql-9.3-postgis-2.1 osm2pgsql


