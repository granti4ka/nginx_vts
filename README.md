# Docker nginx with VTS module
## Compiling NGINX with virtual host traffic status module for use in Docker

I have made some changes:
- I'd prefer to use https to download the nginx sources; instead of using http
-  I have replaced make && make install with make modules. You can then copy the module from the directory /usr/src/nginx-$NGINX_VERSION/objs/ in the builder image. 
- all .so will be available on the root ( / ), you can get it with

Note that you can speed up the docker image build by compiling only the dynamic module.
On my dated laptop this decreases the image build time to about 5%.

COPY --from=builder /ngx_http_vhost_traffic_status_module.so /usr/local/nginx/modules/nginx-module-vts.so

