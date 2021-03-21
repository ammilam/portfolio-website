FROM nginx:alpine
COPY . /usr/share/nginx/html
ENV PORT 80
