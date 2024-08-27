#!/bin/bash

moneroVersion="v0.18.3.4"
moneroArm="monero-linux-armv8-v0.18.3.4.tar.bz2"
moneroAmd64="monero-linux-x64-v0.18.3.4.tar.bz2"

# get monero cli
arch="$(dpkg --print-architecture)";
case "$arch" in \arm64)
  curl -fsSLO https://downloads.getmonero.org/cli/${moneroArm} ;;
\amd64)
  curl -fsSLO https://downloads.getmonero.org/cli/${moneroAmd64} ;;
esac;

# fetch, import and trust monero signing gpg key
curl -fsSL https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/binaryfate.asc  -o  key.asc;
gpg --import key.asc
gpg --list-keys --fingerprint --with-colons | sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' | gpg --import-ownertrust

# get hashes and signed hashes for monero
curl -fsSL https://www.getmonero.org/downloads/hashes.txt -o mhashes

# verify that monero matches a signed hash and the hash is legitimately signed
gpg --keyid-format long --verify  mhashes
sha256sum -c --ignore-missing mhashes
echo "verified signed archive"

# clean up hashes and gpg keys
rm key.asc
rm mhashes
sleep 10

# extract monero
mkdir monero
case "$arch" in \arm64)
  tar -xvjf ${moneroArm} --strip-component=1 -C monero
  rm -rf ${moneroArm} ;;
\amd64)
  tar -xvjf ${moneroAmd64} --strip-component=1 -C monero
  rm -rf ${moneroAmd64} ;;
esac;
cp monero/monerod /usr/local/bin/monerod
cp monero/monero-gen-ssl-cert /usr/local/bin/monero-gen-ssl-cert
cp monero/monero-wallet-rpc /usr/local/bin/monero-wallet-rpc
cp monero/monero-wallet-cli /usr/local/bin/monero-wallet-cli
cp monero/monero-gen-trusted-multisig /usr/local/bin/monero-gen-trusted-multisig
cp monero/monero-blockchain-usage /usr/local/bin/monero-blockchain-usage
cp monero/monero-blockchain-stats /usr/local/bin/monero-blockchain-stats
cp monero/monero-blockchain-prune /usr/local/bin/monero-blockchain-prune
cp monero/monero-blockchain-import /usr/local/bin/monero-blockchain-import
cp monero/monero-blockchain-export /usr/local/bin/monero-blockchain-export
cp monero/monero-blockchain-depth /usr/local/bin/monero-blockchain-depth
cp monero/monero-blockchain-ancestry /usr/local/bin/monero-blockchain-ancestry
cp monero/monero-blockchain-mark-spent-outputs /usr/local/bin/monero-blockchain-mark-spent-outputs
cp monero/monero-blockchain-prune-known-spent-data /usr/local/bin/monero-blockchain-prune-known-spent-data
rm -rf monero
echo "Monero is installed!"
