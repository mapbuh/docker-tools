FROM debian:stable-slim
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y proftpd vim procps
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
RUN useradd -m -d /home/ftpuser ftpuser -p 'ftpuser' -s '/bin/true'

