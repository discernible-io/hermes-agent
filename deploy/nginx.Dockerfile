# Pinned base (tag + manifest-list digest). Bump both when upgrading nginx.
FROM docker.io/nginx:1.31.3-alpine@sha256:4a73073bd557c65b759505da037898b61f1be6cbcc3c2c3aeac22d2a470c1752

ARG INGRESS_PORT=11443

RUN apk add --no-cache openssl \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /app/certs /etc/nginx/inc

# Runtime nginx.conf is mounted from the app dir (rendered by render-nginx-conf.sh).
# Ship includes into the image so they are always available.
COPY nginx/inc/ /etc/nginx/inc/

RUN printf '%s\n' \
  'user nginx;' \
  'worker_processes auto;' \
  'error_log /var/log/nginx/error.log warn;' \
  'pid /tmp/nginx.pid;' \
  'events { worker_connections 1024; }' \
  'http { include /etc/nginx/mime.types; default_type application/octet-stream;' \
  '  return 503 "nginx.conf not mounted — run ./hermes.sh start in pod mode\n"; }' \
  > /etc/nginx/nginx.conf \
 && chown -R nginx:nginx /etc/nginx/nginx.conf /etc/nginx/inc /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /app

USER nginx
EXPOSE ${INGRESS_PORT}

CMD ["nginx", "-g", "daemon off;"]
