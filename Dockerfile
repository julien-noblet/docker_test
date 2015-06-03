FROM ubuntu:14.04

ENV POSTGRES=9.3
ENV user=osm
ENV db=transilien


    
RUN apt-get update \
      && apt-get install -y wget postgresql-client-9.3 postgresql-9.3-postgis-2.1 \
      proj-bin libgeos-dev osm2pgsql \
      git unzip curl build-essential software-properties-common
    
COPY bash.sh /bash.sh

RUN wget http://download.geofabrik.de/europe/france/ile-de-france-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/picardie-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/centre-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/haute-normandie-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/champagne-ardenne-latest.osm.pbf
RUN wget http://download.geofabrik.de/europe/france/bourgogne-latest.osm.pbf

RUN chmod +x /bash.sh
RUN /bash.sh

