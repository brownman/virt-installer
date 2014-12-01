#!/bin/sh

set -x

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v3.1.1 packages...
cd /root/mapr-repo && wget -r -l1 -A.rpm 'http://package.mapr.com/releases/v3.1.1/redhat/'

# Downloading HBase-0.94...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-0.94.21.27795.GA-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-internal-0.94.21.27795.GA-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-master-0.94.21.27795.GA-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hbase-regionserver-0.94.21.27795.GA-1.noarch.rpm'

# Downloading Hive-0.13...
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hive-0.13.201411180959-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hivemetastore-0.13.201411180959-1.noarch.rpm'
cd /root/mapr-repo && wget 'http://package.mapr.com/releases/ecosystem/redhat/mapr-hiveserver2-0.13.201411180959-1.noarch.rpm'


# Creating package
createrepo /root/mapr-repo

# Configuring repository...'
cat >> /etc/yum.conf << EOF
[maprtech]
name=MapR Technologies, Inc.
baseurl=file:/root/mapr-repo
enabled=1
gpgcheck=0
EOF

# Installing Mapr packages..."
yum install -y mapr-cldb mapr-fileserver mapr-zookeeper mapr-tasktracker mapr-jobtracker mapr-hbase-master mapr-hbase-regionserver

