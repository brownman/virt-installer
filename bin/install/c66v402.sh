#!/bin/sh

HBASE_VERSION='0.98.4'
OS_IMAGE_CLUSTER_NAME=mrv2.mapr.cluster

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v4.0.2 packages...
cd /root/mapr-repo && wget -r -l1 -A.rpm 'http://osayankin:OsayCanUC!@stage.mapr.com/beta/cybervision/v4.0.2/redhat/'


case $HBASE_VERSION in
'0.94.21')
    # Downloading HBase-0.94.21...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-internal-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-master-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-regionserver-0.94.21.27795.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbasethrift-0.94.21.27795-1.noarch.rpm'

    ;;
'0.98.4')
    # Downloading HBase-0.98...
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-0.98.4.27323.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-internal-0.98.4.27323.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-master-0.98.4.27323.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbase-regionserver-0.98.4.27323.GA-1.noarch.rpm'
    cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hbasethrift-0.98.4.27323-1.noarch.rpm'
;;
esac

# Downloading Hive-0.13...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hive-0.13.201411180959-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hivemetastore-0.13.201411180959-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem-4.x/redhat/mapr-hiveserver2-0.13.201411180959-1.noarch.rpm'


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
yum install -y mapr-cldb mapr-fileserver mapr-nodemanager mapr-zookeeper mapr-resourcemanager mapr-tasktracker mapr-jobtracker mapr-historyserver mapr-hbase-master mapr-hbase-regionserver mapr-hive mapr-hivemetastore mapr-hiveserver2

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


# Creating /opt/mapr/hostname file...
hostname --fqdn > /opt/mapr/hostname

# Configuring warden.conf. Setting mfs.heapsize.percent=10'
sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf

# Configuring cluster...
#/opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -a -v -RM localhost -HS localhost -f --create-user
