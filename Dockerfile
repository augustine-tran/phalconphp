FROM tutum/apache-php

MAINTAINER Khanh Tran <khanh.tq@geekup.vn>

# Install modules
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:phalcon/legacy
RUN apt-get update; apt-get install -y php5-dev git libpq-dev libmemcached-dev libicu-dev wget && apt-get clean
RUN apt-get install -y   php5-mysql php5-intl php5-phalcon php5-gd
RUN pecl install -f xdebug

# checkout, compile and install recent Phalcon extension
# enable Apache's mod_rewrite and change document root to: /var/www/html/public
RUN cd /etc/apache2/mods-enabled && ln -s ../mods-available/rewrite.load rewrite.load
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g' /etc/apache2/apache2.conf
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g' /etc/apache2/sites-available/*.conf

# add config and dummy content
COPY var/www /var/www/html
COPY etc /usr/local/etc

RUN rm -rf /app
WORKDIR /var/www/html

# add entrypoint run script
ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]

CMD ["apache2-foreground"]
