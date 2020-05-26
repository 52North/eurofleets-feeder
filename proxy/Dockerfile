FROM nginx:alpine

COPY upstream.conf /etc/nginx/upstream.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/upstream.conf.template > /etc/nginx/upstream.conf && exec nginx -g 'daemon off;'"]