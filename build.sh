#!/bin/bash

git reset --hard
git clean -xfd

wget --no-check-certificate -qO- https://matt.ucc.asn.au/dropbear/releases/dropbear-2019.78.tar.bz2 | tar -xvj --strip=1 --exclude='debian' -C .

debian_version_number=`cat /etc/debian_version | cut -f1 -d'.'`
sed -i "s/deb#VERSION#/deb${debian_version_number}/g" debian/changelog

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get install -y autotools-dev build-essential debhelper devscripts dpkg-dev quilt zlib1g-dev

patch svr-chansession.c < env.patch
patch svr-session.c < log_ip.patch

debuild --no-tgz-check -i -us -uc -b
