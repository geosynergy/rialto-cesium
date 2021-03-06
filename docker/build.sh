#!/bin/bash

set -e

#
# base libs
#
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y update
yum -y install \
    java-1.6.0-openjdk-devel \
    gcc-c++ \
    nginx \
    nodejs \
    tar \
    unzip

#
# Ant
#
curl -L http://psg.mtu.edu/pub/apache/ant/binaries/apache-ant-1.9.5-bin.tar.gz -o /tmp/ant.tar.gz
tar xvf /tmp/ant.tar.gz -C /tmp
rm -rf /tmp/ant.tar.gz

#
# Rialto's Cesium
#
curl -L https://github.com/radiantbluetechnologies/rialto-cesium/archive/$BRANCH.zip -o /tmp/cesium.zip
unzip -o -d /tmp /tmp/cesium.zip
mv /tmp/rialto-cesium-$BRANCH /tmp/cesium
/tmp/apache-ant-1.9.5/bin/ant combine -buildfile /tmp/cesium
mkdir -p /opt/cesium-build
cp -r /tmp/cesium/Build/* /opt/cesium-build/

#
# deploy
#
mkdir -p /opt/www
cp -r /tmp/cesium/* /opt/www/

#
# cleanup
#
rm -rf \
    /tmp/apache-ant-1.9.5 \
    /tmp/cesium/ \
    /tmp/cesium.zip
