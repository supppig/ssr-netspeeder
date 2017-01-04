FROM       ubuntu:14.04.3
MAINTAINER supppig <supppig@gmail.com>

ENV KCPTUN_VERSION 20161222

# pre
RUN apt-get update && \
apt-get clean  && \
apt-get install -y openssh-server python python-pip python-m2crypto libnet1-dev libpcap0.8-dev git gcc wget && \
apt-get clean

# ssh
RUN mkdir /var/run/sshd
RUN echo 'root:supppig' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD    ["/usr/sbin/sshd", "-D"]

# SSR
RUN git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git ssr
RUN mv ssr /root/
WORKDIR /root/ssr
RUN cp ./config.json ./user-config.json
RUN sed -ri 's/^.*password.*/    \"password\": \"supppig\",/' ./user-config.json
RUN sed -ri 's/^.*method.*/    \"method\": \"rc4-md5\",/' ./user-config.json
RUN sed -ri 's/^.*protocol.*/    \"protocol\": \"auth_sha1_v2_compatible\",/' ./user-config.json
RUN sed -ri 's/^.*obfs.*/    \"obfs\": \"tls1.2_ticket_auth_compatible\",/' ./user-config.json
RUN sed -ri 's/^.*fast_open.*/    \"fast_open\": true/' ./user-config.json
RUN nohup python ./shadowsocks/server.py -d start

# net-speeder
#RUN git clone https://github.com/snooda/net-speeder.git net-speeder
#RUN mv net-speeder /root/
#WORKDIR /root/net-speeder
#RUN chmod 777 -R /root/net-speeder
#RUN sh build.sh

# KCPtun
RUN mkdir /root/kcp
WORKDIR /root/kcp
RUN wget https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz
RUN tar -zxvf kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz
