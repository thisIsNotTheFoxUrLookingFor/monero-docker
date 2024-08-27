FROM ubuntu:latest AS build

COPY monero.sh /monero.sh

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq  \
  && apt-get -yq install supervisor net-tools git sudo tor curl gpg bzip2

RUN ["bash","-c","/monero.sh && rm /monero.sh"]

ENTRYPOINT ["sh","/config/init.sh"]
