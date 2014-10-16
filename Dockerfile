FROM ubuntu:latest
MAINTAINER Maciek Ruckgaber <maciekrb@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# -------- Install Packages and dependencies --------
RUN apt-get update && apt-get install -y python-dev python-setuptools supervisor apache2 php5 \
libapache2-mod-fcgid mapserver-bin php5-mapscript tilecache memcached && a2enmod actions

RUN easy_install flup Paste supervisor-stdout

# ------------- Cleanup all apt database ------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ---------------- Add Config Files -----------------
ADD etc /etc

# --------- SymLink Mapserver to cgi-path ----------
RUN mkdir -p /var/mapserver && ln -s /usr/bin/mapserv /var/mapserver/mapserv.fcgi

# --------- Mounts mapserver data volume -----------
VOLUME ["/home/data"]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
