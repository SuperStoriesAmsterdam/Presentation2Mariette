FROM nginx:alpine
COPY . /usr/share/nginx/html
RUN echo 'server { listen 3000; location / { root /usr/share/nginx/html; index index.html; } }' > /etc/nginx/conf.d/default.conf
EXPOSE 3000
