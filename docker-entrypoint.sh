#!/bin/bash
set -e

if [ "$1" = 'supervisord' ]; then
  # Set correct permissions over $APPDATA 
  # https://github.com/maciekrb/docker-mapserver/blob/master/Dockerfile
  chown -R www-data "$APPDATA"

  exec supervisord 
fi

exec "$@"
