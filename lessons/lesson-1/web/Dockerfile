FROM ubuntu:latest

USER root

RUN apt-get update
RUN apt-get install -y nginx
RUN rm -v /etc/nginx/nginx.conf
ADD lesson-1/web/nginx.conf /etc/nginx/

ADD lesson-1/web/index.html /usr/share/nginx/html/
# ADD web /var/www/html/

EXPOSE 90
CMD service nginx start
