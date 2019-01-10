FROM ubuntu:18.04
ARG NAME
CMD /root/start.sh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y vim
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
