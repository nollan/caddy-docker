# Caddy distroless #

## Example Dockerfile ##

``` dockerfile
FROM nollan/caddy-distroless

LABEL maintainer="patric@zro.se"

# Webpage data location
VOLUME /web

# Net
EXPOSE 80 443

# Webpage data
COPY public_html /web/
COPY Caddyfile /etc/Caddyfile

## Start application
ENTRYPOINT ["/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
```

## Example Caddyfile ##

```
## Redirect from HTTP to HTTPS
:80 {
      log stdout
      errors stderr
      redir https://{host}{uri} 301
}

# ## Domains
https://example.com {
      # For Let's Encrypt
      tls yourname@example.com

      # Webpage location
      root /web

      # Compress just a bit
      gzip {
            level 1
      }

      # Logs
      log / stdout "{combined} {mitm}"
      errors stdout
}
```
