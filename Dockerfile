FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
ENV PORT 80
