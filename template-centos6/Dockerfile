FROM centos:6
ARG NAME
CMD /root/start.sh
RUN yum update -y
COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh
