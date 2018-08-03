FROM debian:stable-slim
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https lsb-release ca-certificates wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server apache2 php5.6-fpm php5.6-curl php5.6-gd php5.6-json php5.6-mysql rsync vim composer php5.6-zip php5.6-mbstring php5.6-xml sudo wget
RUN a2enmod proxy_fcgi setenvif rewrite remoteip
RUN a2enconf php5.6-fpm
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
RUN mkdir /run/php
#RUN useradd -m -d /home/genius genius -p '$x$12345678$xxxx.'
COPY apache.conf /etc/apache2/sites-available/001-${NAME}.conf
RUN a2dissite '*'
RUN a2ensite 001-${NAME}
COPY php-fpm.conf /etc/php/5.6/fpm/pool.d/www.conf

