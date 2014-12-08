#!/bin/sh

#Do not delete this comment. Hbase version auto inserted after it.
HBASE_VERSION='0.94.21'

# Creating dir: /root/mapr-repo...
mkdir /root/mapr-repo

# Dwonloading MapR v3.1.1 packages...
cd /root/mapr-repo && wget -r -l1 -A.rpm 'http://osayankin:Al3ks3y7!@stage.mapr.com/beta/cybervision/v4.0.2/redhat/'


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

