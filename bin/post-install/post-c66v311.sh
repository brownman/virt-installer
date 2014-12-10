#!/bin/sh

set -x

OS_IMAGE_CLUSTER_NAME=mrv2.mapr.cluster

# Adding hostname to /etc/hosts...
IP_ETH0=`ifconfig eth0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1`
HOST_NAME=
HOST_ALIAS=
cat >> /etc/hosts << EOF

# Host name
$IP_ETH0  $HOST_NAME  $HOST_ALIAS
EOF

# Configuring cluster..
/opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -f --create-user -F /mapr-disks/disks.list
