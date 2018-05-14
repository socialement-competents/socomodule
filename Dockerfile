FROM node:9.11.1-alpine as build
LABEL maintainer="Thomas Sauvajon <thomas.sauvajon.dev@gmail.com>"
WORKDIR /tmp/socomodule
COPY . .
RUN yarn
RUN yarn build

FROM nginx:1.13.12-alpine
COPY --from=build /tmp/socomodule/dist /usr/share/nginx/html

EXPOSE 80
