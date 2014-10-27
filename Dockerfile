# vim:set ft=dockerfile
# MapServer GIS stack including TileCache and Memecached
# MapServer and TileCache running as Apache2 FastCGI
#
# Version 1.0
#
FROM ubuntu:latest
MAINTAINER Maciek Ruckgaber <maciekrb@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# -------- Install Packages and dependencies --------
RUN apt-get update && apt-get install -y python-dev python-setuptools apache2 php5 \
locales libapache2-mod-fcgid mapserver-bin php5-mapscript php5-memcache postgis tilecache memcached \
&& a2enmod actions

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
&& apt-get install -y php5-pgsql

# ------- We run everything using supervisor ---------
RUN easy_install supervisor flup Paste supervisor-stdout && mkdir /var/log/supervisor
ENV PATH /usr/local/bin:$PATH

# grab gosu for easy step-down from root
#ADD https://github.com/tianon/gosu/releases/download/1.1/gosu /usr/local/bin/gosu
#RUN chmod +x /usr/local/bin/gosu

# ------------- Cleanup all apt database ------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ---------------- Add Config Files -----------------
ADD etc /etc

# --------- SymLink Mapserver to cgi-path ----------
RUN mkdir -p /var/mapserver && ln -s /usr/bin/mapserv /var/mapserver/mapserv.fcgi

# --------- Mounts mapserver data volume -----------
ENV APPDATA /home/data
VOLUME ["/home/data"]

# ---------- Add Entry Point Script --------------
COPY ./docker-entrypoint.sh /
RUN chmod +x ./docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord"]
