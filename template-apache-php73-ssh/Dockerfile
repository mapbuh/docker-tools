FROM debian:testing-slim
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server apache2 php7.3-fpm php7.3-curl php7.3-gd php7.3-json php7.3-mysql rsync vim composer php7.3-zip php7.3-mbstring php7.3-xml sudo wget php7.3-bcmath php7.3-soap php7.3-intl php7.3-mbstring 
RUN a2enmod proxy_fcgi setenvif rewrite remoteip
RUN a2enconf php7.3-fpm
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
RUN mkdir /run/php
#RUN useradd -m -d /home/genius genius -p '$x$12345678$xxxx.'
COPY apache.conf /etc/apache2/sites-available/001-${NAME}.conf
RUN a2dissite '*'
RUN a2ensite 001-${NAME}
COPY php-fpm.conf /etc/php/7.3/fpm/pool.d/www.conf

