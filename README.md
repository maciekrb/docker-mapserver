# Apache + Mapserver + TileCache + Memcached #

This is a simple Apache2 image including Mapserver and TileCache running as FastCGI processes. Apache Includes
PHP, and php-mapscript extension.  To use this image effectively you should:

- The apache config contains an `Alias /ms_tmp /home/data/ms_tmp` (the mounted ms_tmp).
- The apache config contains an `Alias /data /home/data/ms_data` (the mounted ms_tmp).

This means that you mount a directory resembling the following structure in `/home/data`: 
```sh 
tree data_to_mount
data_to_mount
├── ms_data
│   ├── images
│   ├── legends
│   ├── mapfiles
│   ├── raster
│   ├── resources
│   ├── sessions
│   └── shapeFiles
├── ms_data
└── tilecache
```

MapServer runs under `http://[yourhost]/mapserver` once the image is ran.

- If you want to use the container to run an application, you must either mount your source code 
`-v /your/source:/var/www` at runtiem or `ADD your_source /var/www` in your `Dockerfile`. 

When something fancier is required, you can always create a VirtualHost configuration like the following:
```
# etc/apache2/sites-enabled/mysite.conf
<VirtualHost *:80>
  ServerName site.example.com.co
  DocumentRoot /var/www
  # more fancy confs
</VirtualHost>
```

In which case MapServer would run under `http://site.example.com.co/mapserver`.

## TileCache Config ##
TileCache config can be customized adding a `etc/tilecache.cfg` file. The tile cache server runs
under the `/tilecache` alias.


## Sample Dockerfile reusing the image ##
```
FROM maciekrb/apache-mapserver-fcgi

MAINTAINER Someone Else <someoneelse@example.com>

# --------- Add your own configs ------------
ADD etc /etc

# ---------- Add your app source ------------
ADD your_source /var/www
```

# References #
- http://www.mapserver.org/documentation.html
- http://tilecache.org/docs/README.html
