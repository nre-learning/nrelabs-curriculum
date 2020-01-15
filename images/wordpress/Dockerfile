FROM ubuntu:16.04

RUN apt-get update && apt-get install -y vim less curl wget apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql \
    php7.0-curl php7.0-mbstring php7.0-gd php7.0-xml php7.0-xmlrpc php7.0-intl php7.0-soap php7.0-zip

# Install MySQL Server in a Non-Interactive mode. Default root password will be "juniper2019"
RUN echo "mysql-server-5.7 mysql-server/root_password password juniper2019" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password juniper2019" | debconf-set-selections
RUN apt-get -y install mysql-server-5.7

# Configure Apache
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD ports.conf /etc/apache2/ports.conf

RUN cd /var/www/html \
    && wget -c https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/www/html/latest.tar.gz \
    && mv wordpress/* . \
    && rm -rf wordpress/ \
    rm index.html

ADD wp-config.php /var/www/html/wp-config.php
ADD functions.php /var/www/html/wp-content/themes/twentynineteen

# https://wp-cli.org/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Antidote user
# RUN mkdir -p /home/antidote
# RUN useradd antidote -p antidotepassword
# RUN chown antidote:antidote /home/antidote
# RUN chsh antidote --shell=/bin/bash
# RUN echo 'antidote:antidotepassword' | chpasswd
# USER antidote
# WORKDIR /home/antidote

ADD start-wp.sh /home/antidote/start-wp.sh
CMD ["/home/antidote/start-wp.sh"]