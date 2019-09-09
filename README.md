# Docker nginx with VTS module
## Compiling NGINX with virtual host traffic status module for use in Docker

Monitoring nginx status<br><br>

## Version
This document describes Compiling NGINX with nginx-module-vts v0.1.18 released on 22 Jun 2018.

## Dependencies
nginx


## Installation
* Clone the git repository. 
```bash 
shell> git clone https://github.com/granti4ka/nginx_vts.git
```

* Build New Docker Image
```bash 
docker build -t nginx_vts:latest .
```

* Create New Container Based on it.
```bash 
docker run -d --name nginx_vts --hostname nginx_vts_host -p 80:80 nginx_vts:latest
```

* Check nginx status
```bash 
http://domain.com/status
http://domain.com/status/format/prometheus  (html, json, jsonp, prometheus)
http://domain.com/statuszone/control?cmd=status&group=server&zone=localhost
```
## Synopsis
```
http {
    # Basic configuration for vts module
    vhost_traffic_status_zone;

    ...

    server {

        ...

        location /status {
            vhost_traffic_status_display;
            vhost_traffic_status_display_format html;
        }
    }
}
```

## Description
This is an Nginx module that provides access to virtual host status information. It contains the current status such as servers, upstreams, caches. This is similar to the live activity monitoring of nginx plus. The built-in html is also taken from the demo page of old version.

First of all, the directive `vhost_traffic_status_zone` is required, and then if the directive `vhost_traffic_status_displayis` set, can be access to as follows:

- /status/format/json
   - If you request /status/format/json, will respond with a JSON document containing the current activity data for using in live dashboards and third-party monitoring tools.
- /status/format/html
   - If you request /status/format/html, will respond with the built-in live dashboard in HTML that requests internally to /status/format/json.
- /status/format/jsonp
   - If you request /status/format/jsonp, will respond with a JSONP callback function containing the current activity data for using in live dashboards and third-party monitoring tools.
- /status/format/prometheus
   - If you request /status/format/prometheus, will respond with a prometheus document containing the current activity data.
- /status/control
   - If you request /status/control, will respond with a JSON document after it reset or delete zones through a query string. See the Control.

## Link
https://github.com/vozlt/nginx-module-vts  
https://hub.docker.com/r/sophos/nginx-vts-exporter/  
https://hub.docker.com/r/xcgd/nginx-vts/dockerfile  
https://gist.github.com/hermanbanken/96f0ff298c162a522ddbba44cad31081  
https://github.com/Parli/nginx-vts-docker
