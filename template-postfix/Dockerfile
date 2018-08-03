FROM debian:stable-slim
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends vim sudo postfix postfix-mysql postgrey  procps less postfixadmin dovecot-imapd dovecot-mysql rsyslog net-tools spamassassin dovecot-sieve dovecot-managesieved dovecot-pop3d tcpd xml-core libdbd-mysql-perl libdbi-perl bzip2 file rename libterm-readkey-perl
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
