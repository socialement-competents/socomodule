FROM nginx:1.13.12-alpine
LABEL maintainer="thomas.sauvajon.dev@gmail.com"
COPY dist /usr/share/nginx/html

EXPOSE 80
