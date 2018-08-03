FROM pblaszczyk/debian-lenny
ARG NAME
CMD /root/start.sh
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php-fpm php-curl php-gd php-json php-mysql rsync vim composer php-zip php-mbstring php-xml sudo wget
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes apache2 rsync vim sudo wget libapache2-mod-php5 php5-mysql
RUN a2enmod setenvif rewrite # remoteip proxy_fcgi 
# RUN a2enconf php-fpm
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
#RUN mkdir /run/php
#RUN useradd -m -d /home/genius genius -p '$x$12345678$xxxx.'
COPY apache.conf /etc/apache2/sites-available/001-${NAME}.conf
RUN a2dissite '*'
RUN a2ensite 001-${NAME}.conf
# COPY php-fpm.conf /etc/php/5.2/fpm/pool.d/www.conf

