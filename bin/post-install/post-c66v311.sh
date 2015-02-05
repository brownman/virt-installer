#!/bin/sh

set -x

OS_IMAGE_CLUSTER_NAME=mrv2.mapr.cluster
RUN_CONFIGURE_SH_AFTER_INSTALL=

# Adding hostname to /etc/hosts...
IP_ETH0=`ifconfig eth0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1`
HOST_NAME=
HOST_ALIAS=
cat >> /etc/hosts << EOF

# Host name
$IP_ETH0  $HOST_NAME  $HOST_ALIAS
EOF

# Setup storage
losetup /dev/loop0 /mapr-disks/disk0

# Configuring cluster..
if [ $RUN_CONFIGURE_SH_AFTER_INSTALL -eq 1 ]; then
   /opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -f --create-user
fi

# Formating storage to maprfs
/opt/mapr/server/disksetup -F /mapr-disks/disks.list

# Configuring warden.conf. Setting mfs.heapsize.percent=10'
if [ $RUN_CONFIGURE_SH_AFTER_INSTALL -eq 1 ]; then
    sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf
fi