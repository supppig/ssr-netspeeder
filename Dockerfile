FROM       ubuntu:14.04.3
MAINTAINER supppig <supppig@gmail.com>

# pre
RUN apt-get update && \
apt-get clean  && \
apt-get install -y openssh-server python python-pip python-m2crypto libnet1-dev libpcap0.8-dev git gcc && \
apt-get clean

# ssh
RUN mkdir /var/run/sshd
RUN echo 'supppig:supppig' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD    ["/usr/sbin/sshd", "-D"]

# SSR
RUN git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git ssr
RUN mv ssr /root/

# net-speeder
RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh
RUN mv net_speeder /root/
RUN chmod 777 -R /root/net-speeder


