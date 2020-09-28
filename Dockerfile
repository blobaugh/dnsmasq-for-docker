FROM alpine:3.11

LABEL maintainer "Ben Lobaugh ben@lobaugh.net"

##
# Setup dnsmasq
##
RUN apk --no-cache add dnsmasq

#VOLUME /etc/dnsmasq

ADD dnsmasq.conf /etc/dnsmasq.conf

##
# Setup docker-gen
# Monitors Docker for new containers
##
ENV DOCKER_HOST unix:///tmp/docker.sock

ENV DOCKER_GEN_VERSION 0.7.4

RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

ADD dnsmasq.tmpl /etc/dnsmasq.tmpl

ADD docker-gen.conf /etc/docker-gen.conf
##
# Add the file that powers the whole setup
##
ADD zonewatch.sh /zonewatch.sh

##
# Open up the DNS port
##
EXPOSE 53 53/udp

##
# Fire up the whole kit-n-kaboodle
##
ENTRYPOINT ["/zonewatch.sh" ]
