#!/bin/bash


OS_IMAGE_CLUSTER_NAME=mrv2.mapr.cluster
RUN_CONFIGURE_SH_AFTER_INSTALL=

# Configuring cluster...
if [ $RUN_CONFIGURE_SH_AFTER_INSTALL -eq 1 ]; then
    /opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -a -v -RM localhost -HS localhost -f --create-user

    # Formating storage to maprfs
    /opt/mapr/server/disksetup -F /mapr-disks/disks.list

    # Configuring warden.conf. Setting mfs.heapsize.percent=10
    sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf
fi