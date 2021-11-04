FROM ubuntu:18.04

LABEL maintainer="Ismael Dev"
LABEL description="Apache/PHP7.4 Docker"
LABEL version="2.0"

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

#utils
RUN apt-get update && \
    apt-get install -y nano \
    curl \
    net-tools \
    iputils-ping \
    unzip \ 
    git -y vim


# apache install
RUN apt-get install -y apache2
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod headers

# add apache config
ADD config/apache/000-default.conf /etc/apache2/sites-available/
# add apache2 service to supervisor
ADD config/supervisor/conf.d/apache2.conf /etc/supervisor/conf.d/

RUN chown -R www-data:www-data /var/www/html
ADD ./htdocs /var/www/html

#Install php e dependencies
RUN apt-get install -y software-properties-common && \ 
    add-apt-repository ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install -y php7.4 && \
    apt-get install -y php7.4-mysql \
    php7.4-mbstring \
    php7.4-mcrypt \
    php7.4-xml \
    php7.4-zip \
    php7.4-json \
    php7.4-curl \
    php7.4-gd \
    php7.4-pgsql \
    php-xdebug

# add php ini 
# comando para pegar php.ini do php atual e jogar na minha pasta.
#  sudo docker cp php7-0apache2:/etc/php/7.0/apache2/php.ini .
ADD config/php/php.ini /etc/php/7.4/apache2/

#install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

EXPOSE 80
EXPOSE 443
EXPOSE 8000

WORKDIR /var/www/html

CMD ["apachectl", "-D" ,"FOREGROUND"]

# comando para rodar docker 
# docker-compose up -d --build
