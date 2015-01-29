#!/bin/sh

set -x

HBASE_VERSION='0.98.4'
OS_IMAGE_CLUSTER_NAME=mrv2.mapr.cluster

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v4.0.1 packages...
cd /root/mapr-repo && wget -r -l2 -A.deb 'http://package.mapr.com/releases/v4.0.1/ubuntu/pool/optional/m/'

# Creating package info dir...
mkdir -p /root/mapr-repo/dists/binary/optional/binary-amd64

case $HBASE_VERSION in
'0.94.21')
    # Downloading HBase-0.94...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-0.94.21.27795.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-internal-0.94.21.27795.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-master-0.94.21.27795.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbase-regionserver-0.94.21.27795.GA_all.deb'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hbasethrift_0.94.21.27795_all.deb'

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


# Downloading Hive-0.13...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hive_0.13.201501201824_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hivemetastore_0.13.201501201824_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/ubuntu/dists/binary/mapr-hiveserver2_0.13.201501201824_all.deb'

# Creating package.gz...
cd /root/mapr-repo && dpkg-scanpackages . /dev/null | gzip -9c > ./dists/binary/optional/binary-amd64/Packages.gz

# Updating links...
cat > /etc/apt/sources.list.d/maprtech.list << EOF
deb [arch=amd64] file:/root/mapr-repo binary optional
EOF

sudo apt-get update

# Installing Mapr packages..."
sudo apt-get --yes --force-yes  install mapr-cldb mapr-fileserver mapr-nodemanager mapr-zookeeper mapr-resourcemanager mapr-tasktracker mapr-jobtracker mapr-historyserver mapr-hbase-master mapr-hbase-regionserver mapr-hive mapr-hivemetastore mapr-hiveserver2 

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


# Permit root login
sed -i 's/.*PermitRootLogin.*/PermitRootLogin Yes/g' /etc/ssh/sshd_config