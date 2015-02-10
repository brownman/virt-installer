#!/bin/bash

#TODO: Test this scriprt

KRB_DEFAULT_REALM=
OS_IMAGE_HOST_NAME=
KRB_DATABASE_PASSWD=
KRB_ADMIN_USER_PASSWD=
KRB_MAPR_USER_PASSWD=
OS_IMAGE_CLUSTER_NAME=
RUN_CONFIGURE_SH_AFTER_INSTALL=

yum install krb5-server krb5-libs krb5-auth-dialog  krb5-workstation -y

cat > /etc/krb5.conf << EOF
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
    kdc = $OS_IMAGE_HOST_NAME
    admin_server = $OS_IMAGE_HOST_NAME
    default_domain = $OS_IMAGE_HOST_NAME
    acl_file = /etc/krb5kdc/kadm5.acl
}

[domain_realm] 
    .$OS_IMAGE_HOST_NAME = $KRB_DEFAULT_REALM
    $OS_IMAGE_HOST_NAME = $KRB_DEFAULT_REALM

EOF


# Create KDC database
kdb5_util create -s -r $KRB_DEFAULT_REALM -P $KRB_DATABASE_PASSWD

echo "*/admin@$KRB_DEFAULT_REALM    *"  > /etc/krb5kdc/kadm5.acl

# Create principals for admin user
echo "addprinc -pw $KRB_ADMIN_USER_PASSWD root/admin@$KRB_DEFAULT_REALM" | kadmin.local

# Restart Kerberos server and KDC
/sbin/service krb5kdc restart
/sbin/service kadmin restart

# Create principal for mapr user
echo "addprinc -randkey mapr/$OS_IMAGE_CLUSTER_NAME" | kadmin -p root/admin -w $KRB_MAPR_USER_PASSWD

#create keytab for mapr user
echo "ktadd -k /opt/mapr/conf/mapr.keytab mapr/$OS_IMAGE_CLUSTER_NAME@$KRB_DEFAULT_REALM" | kadmin -p root/admin -w $KRB_MAPR_USER_PASSWD

# Restart Kerberos server and KDC
/sbin/service krb5kdc restart
/sbin/service kadmin restart


# Configuring cluster...
if [ $RUN_CONFIGURE_SH_AFTER_INSTALL -eq 1 ]; then
    /opt/mapr/server/configure.sh -C localhost -Z localhost -N $OS_IMAGE_CLUSTER_NAME -a -v -RM localhost -HS localhost -f --create-user -secure -genkeys -kerberosEnable

    # Formating storage to maprfs
    /opt/mapr/server/disksetup -F /mapr-disks/disks.list

    # Configuring warden.conf. Setting mfs.heapsize.percent=10
    sed -i 's/.*service.command.mfs.heapsize.percent=.*/service.command.mfs.heapsize.percent=10/g' /opt/mapr/conf/warden.conf
    
    kinit -kt /opt/mapr/conf/mapr.keytab mapr/$OS_IMAGE_CLUSTER_NAME@$KRB_DEFAULT_REALM

    maprlogin kerberos

fi