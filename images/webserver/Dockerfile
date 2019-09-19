FROM ubuntu:16.04

RUN apt-get update && apt-get install -y vim less curl wget apache2

# Configure Apache
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD ports.conf /etc/apache2/ports.conf

RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod rewrite

# RUN cd /var/www/html \
#     && chown -R www-data:www-data /var/www/html

# Antidote user
# RUN mkdir -p /home/antidote
# RUN useradd antidote -p antidotepassword
# RUN chown antidote:antidote /home/antidote
# RUN chsh antidote --shell=/bin/bash
# RUN echo 'antidote:antidotepassword' | chpasswd
# USER antidote
# WORKDIR /home/antidote

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]