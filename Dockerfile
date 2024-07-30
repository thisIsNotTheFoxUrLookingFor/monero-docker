FROM ubuntu:latest AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq \
  && apt-get -yq install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-all-dev libsqlite3-dev net-tools \
  git dnsutils htop wget curl libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev libssl-dev cmake pkg-config libpgm-dev libnorm-dev libunbound-dev libsodium-dev \
  libunwind8-dev liblzma-dev libreadline6-dev libexpat1-dev libgtest-dev ccache doxygen graphviz qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev psmisc sudo nano \
  libprotobuf-dev protobuf-compiler libudev-dev && cd /usr/src/gtest && cmake . && make && cd /usr/src/gtest && cmake . && mv lib/libg* /usr/lib/ && cd ~ \
  && git clone https://github.com/monero-project/monero.git && cd monero && git checkout v0.18.3.3 && git submodule init && git submodule update \
  && cmake -S "/root/monero" -D STACK_TRACE=OFF -DCMAKE_BUILD_TYPE=Release && make -j 8 && cp ~/monero/bin/* /usr/bin && rm -rf ~/monero

ENTRYPOINT ["sh","/config/init.sh"]
