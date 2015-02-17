#!/bin/sh

HBASE_VERSION='0.94.21'
HIVE_VERSION=

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v3.1.1 packages...
cd /root/mapr-repo && wget -r -l1 -A.rpm 'http://package.mapr.com/releases/v3.1.1/redhat/'

case $HBASE_VERSION in
'0.94.21')
    # Downloading HBase-0.94.21...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-internal-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-master-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-regionserver-0.94.21.27795.GA-1.noarch.rpm'
    ;;
'0.98.4')
    # Downloading HBase-0.98...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-0.98.4.27323.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-internal-0.98.4.27323.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-master-0.98.4.27323.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-regionserver-0.98.4.27323.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbasethrift_0.98.4.27323_all.deb'
    ;;
esac

case $HIVE_VERSION in
'0.12')
    # Downloading Hive-0.12...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hive-0.12.201502021326-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hivemetastore-0.12.201502021326-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hiveserver2-0.12.201502021326-1.noarch.rpm'
;;
'0.13')
    # Downloading Hive-0.13...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hive-0.13.201501201838-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hivemetastore-0.13.201501201838-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hiveserver2-0.13.201501201838-1.noarch.rpm'
;;
esac

# Creating package
createrepo /root/mapr-repo

# Configuring repository...
cat >> /etc/yum.conf << EOF
[maprtech]
name=MapR Technologies, Inc.
baseurl=file:/root/mapr-repo
enabled=1
gpgcheck=0
EOF

# Installing Mapr packages...
yum install -y mapr-cldb mapr-fileserver mapr-zookeeper mapr-tasktracker mapr-jobtracker mapr-hbase-master mapr-hbase-regionserver


# Create flat storage for MapR-FS instead of using entire disk
mkdir -m 777 -p /mapr-disks
dd if=/dev/zero of=/mapr-disks/disk0 bs=1M count=10000
chmod 777 /mapr-disks/disk0

# Adding startup command for automatic mounting of created storage
echo 'losetup /dev/loop0 /mapr-disks/disk0' > /etc/init.d/mapr-disk-mnt
chmod 755 /etc/init.d/mapr-disk-mnt
ln -s /etc/init.d/mapr-disk-mnt /etc/rc2.d/S69mapr-disk-mnt

# Formating storage to maprfs...
echo /dev/loop0 > /mapr-disks/disks.list

# Configuring warden.conf. Setting mfs.heapsize.percent=10'
sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf

