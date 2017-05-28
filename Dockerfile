FROM alpine:latest
MAINTAINER patric@zro.se

## Update and install needed extras
#RUN apk update && apk upgrade --no-cache --available
#RUN apk add --update tar curl musl tini libcap ca-certificates
RUN apk add --no-cache tar curl musl tini libcap ca-certificates

## Install Caddy application and user
ONBUILD RUN curl --silent --show-error --fail --location \
                 --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
                 "https://caddyserver.com/download/linux/amd64" \
                 | tar --no-same-owner -C /usr/sbin/ -xz caddy \
            && adduser -Du 1000 caddyuser \
            && setcap cap_net_bind_service=+ep /usr/sbin/caddy \
            && chmod 0755 /usr/sbin/caddy \
            && /usr/sbin/caddy -version \
            && mkdir /web \
            && chmod 0755 /web

## Security
RUN delgroup ping

## Cleanup APK cache
RUN rm -rf /var/cache/apk/ /var/lib/apt/lists/
