#!/bin/sh

set -x

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v4.0.1 packages...
cd /root/mapr-repo && wget -r -l2 -A.deb 'http://package.mapr.com/releases/v3.1.1/ubuntu/pool/optional/m/'

# Creating package info dir...
mkdir -p /root/mapr-repo/dists/binary/optional/binary-amd64

# Downloading HBase-0.94.21...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hbase-0.94.21.27795.GA_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hbase-internal-0.94.21.27795.GA_all.deb'  
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hbase-master-0.94.21.27795.GA_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hbase-regionserver-0.94.21.27795.GA_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hbasethrift_0.94.21.27795_all.deb'

# Downloading Hive-0.13...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hive_0.13.201411180948_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hivemetastore_0.13.201411180948_all.deb'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/ubuntu/dists/binary/mapr-hiveserver2_0.13.201411180948_all.deb'

# Creating package.gz...
cd /root/mapr-repo && dpkg-scanpackages . /dev/null | gzip -9c > ./dists/binary/optional/binary-amd64/Packages.gz

# Updating links...
cat > /etc/apt/sources.list.d/maprtech.list << EOF
deb [arch=amd64] file:/root/mapr-repo binary optional
EOF

sudo apt-get update

# Installing Mapr packages...
sudo apt-get --yes --force-yes install mapr-cldb mapr-fileserver mapr-zookeeper mapr-tasktracker mapr-jobtracker mapr-hbase-master mapr-hbase-regionserver mapr-hive mapr-hivemetastore mapr-hiveserver2 

# Create flat storage for MapR-FS instead of using entire disk
mkdir -m 777 -p /mapr-disks
#dd if=/dev/zero of=/mapr-disks/disk0 bs=1G count=10
#chmod 777 /mapr-disks/disk0

# Adding startup command for automatic mounting of created storage
#echo 'losetup /dev/loop0 /mapr-disks/disk0' > /etc/init.d/mapr-disk-mnt
#chmod 755 /etc/init.d/mapr-disk-mnt
#ln -s /etc/init.d/mapr-disk-mnt /etc/rc2.d/S69mapr-disk-mnt
#losetup /dev/loop0 /mapr-disks/disk0


# Adding hostname to /etc/hosts...
#IP_ETH0=`ifconfig eth0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1`
#HOST_NAME=u1404v401.com
#HOST_ALIAS=u1404v401
#cat >> /etc/hosts << EOF

# Host name
#$IP_ETH0  $HOST_NAME  $HOST_ALIAS
#EOF

# Creating /opt/mapr/hostname file...
#hostname --fqdn > /opt/mapr/hostname

# Configuring warden.conf. Setting mfs.heapsize.percent=10'
#sed -i 's/service.command.mfs.heapsize.percent=35/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf




