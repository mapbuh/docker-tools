FROM debian:testing-slim
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apache2 vim sudo wget postfixadmin ssl-cert ca-certificates libglib2.0-data shared-mime-info xdg-user-dirs krb5-locales publicsuffix libsasl2-modules libdbd-mysql-perl libdbi-perl libterm-readkey-perl bzip2 file xz-utils netbase courier-authlib-mysql
RUN a2enmod proxy_fcgi setenvif rewrite remoteip
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
#RUN useradd -m -d /home/genius genius -p '$x$12345678$xxxx.'
COPY apache.conf /etc/apache2/sites-available/001-${NAME}.conf
RUN a2dissite '*'
RUN a2ensite 001-${NAME}
RUN chown www-data:www-data /usr/share/postfixadmin/templates_c
