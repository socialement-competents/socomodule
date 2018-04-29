FROM nginx:1.13.12-alpine
COPY dist /usr/share/nginx/html

EXPOSE 80
