FROM nginx:alpine
COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx
ENV PORT 80
