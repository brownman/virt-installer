#!/bin/bash

set -x

KRB_DEFAULT_REALM=
HOST_NAME=
KRB_DATABASE_PASSWD=
KRB_ADMIN_USER_PASSWD=
KRB_MAPR_USER_PASSWD=
OS_IMAGE_CLUSTER_NAME=
RUN_CONFIGURE_SH_AFTER_INSTALL=

# Install Kerberos packages
export DEBIAN_FRONTEND=noninteractive
apt-get -y install krb5-kdc krb5-admin-server krb5-user libpam-krb5 libpam-ccreds auth-client-config ntp haveged


cat >> /etc/krb5.conf << EOF
[logging]
    default = FILE:/var/log/krb5libs.log
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmind.log

[libdefaults]
    default_realm = $KRB_DEFAULT_REALM
    dns_lookup_realm = false
    ns_lookup_kdc = false
    ticket_lifetime = 24h
    forwardable = true

[realms] 
    $KRB_DEFAULT_REALM = {
    kdc = $HOST_NAME
    admin_server = $HOST_NAME
    default_domain = $HOST_NAME
    acl_file = /etc/krb5kdc/kadm5.acl
}

[domain_realm] 
    .$HOST_NAME = $KRB_DEFAULT_REALM
    $HOST_NAME = $KRB_DEFAULT_REALM

EOF

# Create KDC database
kdb5_util create -s -r $KRB_DEFAULT_REALM -P $KRB_DATABASE_PASSWD

echo "*/admin@$KRB_DEFAULT_REALM    *"  > /etc/krb5kdc/kadm5.acl

# Create principals for admin user
echo "addprinc -pw $KRB_ADMIN_USER_PASSWD root/admin@$KRB_DEFAULT_REALM" | kadmin.local

# Restart Kerberos server and KDC
service krb5-kdc restart
service krb5-admin-server restart

# Create principal for mapr user
echo "addprinc -randkey mapr/$OS_IMAGE_CLUSTER_NAME" | kadmin -p root/admin -w $KRB_MAPR_USER_PASSWD

#create keytab for mapr user
echo "ktadd -k /opt/mapr/conf/mapr.keytab mapr/$OS_IMAGE_CLUSTER_NAME@$KRB_DEFAULT_REALM" | kadmin -p root/admin -w $KRB_MAPR_USER_PASSWD

# Restart Kerberos server and KDC
service krb5-kdc restart
service krb5-admin-server restart

# Configuring cluster...
if [ $RUN_CONFIGURE_SH_AFTER_INSTALL -eq 1 ]; then
    /opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -RM localhost -HS localhost -f --create-user -F /mapr-disks/disks.list -secure -genkeys -kerberosEnable

    # Formating storage to maprfs
    /opt/mapr/server/disksetup -F /mapr-disks/disks.list

    # Configuring warden.conf. Setting mfs.heapsize.percent=10'
    sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf

    kinit -kt /opt/mapr/conf/mapr.keytab mapr/$OS_IMAGE_CLUSTER_NAME@$KRB_DEFAULT_REALM

    maprlogin kerberos
fi

