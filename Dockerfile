FROM nginx:alpine AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
# ENV NGINX_VERSION 1.15.0

# Our VTS version
ENV VTS_VERSION 0.1.18

# Download sources
RUN wget "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/vozlt/nginx-module-vts/archive/v$VTS_VERSION.tar.gz" -O nginx-modules-vts.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  bash \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer/-Os} && \
        mkdir /usr/src && \
	tar -zxC /usr/src -f nginx.tar.gz && \
        tar -xzvf "nginx-modules-vts.tar.gz" && \
  VTSDIR="$(pwd)/nginx-module-vts-$VTS_VERSION" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  ./configure --with-compat $CONFARGS --add-dynamic-module=$VTSDIR  && \
#  make && make install
  make modules && \
  mv ./objs/*.so /

FROM nginx:alpine
# Extract the dynamic module VTS from the builder image

COPY --from=builder /ngx_http_vhost_traffic_status_module.so /usr/lib/nginx/modules/nginx-module-vts.so

#COPY --from=builder /usr/lib/nginx/modules/ngx_http_vhost_traffic_status_module.so /usr/local/nginx/modules/nginx-module-vts.so
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
