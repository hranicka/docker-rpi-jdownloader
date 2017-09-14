FROM larmog/armhf-alpine-java:jdk-8u73

LABEL maintainer="Jaroslav Hranicka <me@hranicka.cz>"

# JDownloader
RUN mkdir /opt/jdownloader

# Archive extraction uses sevenzipjbinding library which is compiled against libstdc++
RUN apk add --update \
    libstdc++

RUN apk add --update \
    wget --virtual .build-deps && \
	wget -O /opt/jdownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/jdownloader/JDownloader.jar && \
	wget -O /sbin/tini "https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-armhf" --no-check-certificate && \
	chmod +x /sbin/tini && \
	apk del wget --purge .build-deps

ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib

ADD daemon.sh /opt/jdownloader/
ADD default-config.json.dist /opt/jdownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
ADD configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/jdownloader/cfg

# VPN
RUN apk add --update openvpn

ADD configure-vpn.sh /usr/bin/configure-vpn

VOLUME /etc/openvpn

# Finish
WORKDIR /opt/jdownloader

CMD ["/sbin/tini", "--", "/opt/jdownloader/daemon.sh"]
