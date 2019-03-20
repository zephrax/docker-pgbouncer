FROM debian:stretch-slim

MAINTAINER zephrax@gmail.com 

WORKDIR /
#RUN apk --update add git python py-pip build-base automake libtool m4 autoconf libevent-dev openssl-dev c-ares-dev
RUN apt-get update -y
RUN apt-get install -y build-essential \
  libtool python python-pip git
RUN pip install docutils
RUN git clone --depth=1 --branch pgbouncer_1_9_0 https://github.com/pgbouncer/pgbouncer.git src

WORKDIR /bin
RUN apt-get -y install m4 autotools-dev automake
RUN apt-get install -y pkg-config openssl libssl-dev libevent-2.0.5 libevent-dev libc-ares-dev libc-ares2 python-docutils
RUN ln -s ../usr/bin/rst2man.py rst2man
WORKDIR /src
RUN mkdir /pgbouncer
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN	./configure --prefix=/pgbouncer --with-libevent=/usr/lib  --with-pam=yes
RUN make
RUN make install
RUN ls -R /pgbouncer

FROM alpine:latest
#RUN apk --update add libevent openssl c-ares
WORKDIR /
ADD entrypoint.sh ./
ENTRYPOINT ["./entrypoint.sh"]

