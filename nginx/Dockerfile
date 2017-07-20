FROM nginx:alpine
WORKDIR /etc/nginx

COPY enable_php.conf /etc/nginx/


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && adduser -D -H -u 1000 -s /bin/bash www-data
#CMD ["nginx"]
EXPOSE 80 443