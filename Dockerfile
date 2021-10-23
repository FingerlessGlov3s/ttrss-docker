FROM debian:latest

# install required debian packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  curl git nginx php-cli php-curl php-fpm php-gd php-intl php-json php-mbstring \
  php-mysql php-opcache php-pdo php-pgsql php-xml sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /run/php/

# add custom nginx configuration file
ADD ttrss.conf /etc/nginx/sites-available/ttrss.conf
RUN ln -s /etc/nginx/sites-available/ttrss.conf /etc/nginx/sites-enabled/ttrss.conf && rm /etc/nginx/sites-enabled/default

# install ttrss from git repo
WORKDIR /var/www/html
RUN rm * && git clone https://git.tt-rss.org/fox/tt-rss . \
  && cp config.php-dist config.php

# expose nginx port
EXPOSE 80

# copy in DockerEntry file and run it
ADD dockerentry.sh /dockerentry.sh
RUN chmod +x /dockerentry.sh
CMD /dockerentry.sh