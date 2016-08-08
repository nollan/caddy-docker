FROM alpine:latest
MAINTAINER patric@zro.se

## Update and install needed extras
#RUN apk update && apk upgrade --no-cache --available
RUN apk add --update tar curl musl tini libcap ca-certificates \

## Install Caddy application and user
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=" \
    | tar --no-same-owner -C /usr/sbin/ -xz caddy \
 && adduser -Du 1000 caddyuser \
 && setcap cap_net_bind_service=+ep /usr/sbin/caddy \
 && chmod 0755 /usr/sbin/caddy \
 && /usr/sbin/caddy -version \
 && mkdir /web \
 && chmod 0755 /web

## Data
VOLUME /web
# Caddyfile is just an "example.com" domain, so it will not work
COPY Caddyfile /etc/Caddyfile

## Security
USER caddyuser
EXPOSE 80 443

## Start
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/caddy", "--conf", "/etc/Caddyfile"]

## NOTES
# Command line for exposing ports and to keep the Let's Encrypt certs
# outside the container (to prevent regeneration each time it's started)
# docker run -p80:80 -p443:443 -v $(pwd)/.caddy:/home/caddyuser/.caddy
