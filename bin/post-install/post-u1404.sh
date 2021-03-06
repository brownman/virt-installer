#!/bin/sh

set -x

CLUSTER_SECURE=

# Adding hostname to /etc/hosts...
IP_ETH0=`ifconfig eth0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1`
OS_IMAGE_HOST_NAME=
OS_IMAGE_HOST_ALIAS=
cat >> /etc/hosts << EOF

# Host name
$IP_ETH0  $OS_IMAGE_HOST_NAME  $OS_IMAGE_HOST_ALIAS
EOF

# Setup timezone
echo "Europe/Kiev" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Setup storage
losetup /dev/loop0 /mapr-disks/disk0

case $CLUSTER_SECURE in
    none) bash ./post-u1404-none-secure.sh ;;
    mapr) bash ./post-u1404-mapr-secure.sh ;;
    kerberos) bash ./post-u1404-kerberos-secure.sh ;;
esac