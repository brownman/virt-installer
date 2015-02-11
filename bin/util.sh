#!/bin/sh

function build_os_token(){
local OS_TYPE=$1
case $OS_TYPE in
    'Centos66' )
    echo 'c66'
    ;;
    'Ubuntu14.04' )
    echo 'u1404'
    ;;
esac    
}

function build_os_mapr_token() {
local OS_TYPE=$1
local MAPR_VERSION=$2

case $MAPR_VERSION in
    '3.1.1' )
    echo `build_os_token $OS_TYPE`v311
    ;;
    '4.0.1' )
    echo `build_os_token $OS_TYPE`v401
    ;;
    '4.0.2' )
    echo `build_os_token $OS_TYPE`v402
    ;;
esac
}


function build_os_mapr_secure_token() {
local OS_TYPE=$1
local MAPR_VERSION=$2
local CLUSTER_SECURE=$3

case $CLUSTER_SECURE in
    none)
    echo `build_os_mapr_token $OS_TYPE $MAPR_VERSION`
    ;;
    mapr) 
    echo `build_os_mapr_token $OS_TYPE $MAPR_VERSION`mapr
    ;;
    kerberos)
    echo `build_os_mapr_token $OS_TYPE $MAPR_VERSION`krb
    ;;
esac
}


function set_hbase_version_in_script(){
local HBASE_VERSION=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*HBASE_VERSION=.*/HBASE_VERSION='$HBASE_VERSION'/g" $PATH_TO_SCRIPT
}


function set_hive_version_in_script(){
local HIVE_VERSION=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*HIVE_VERSION=.*/HIVE_VERSION='$HIVE_VERSION'/g" $PATH_TO_SCRIPT
}

function set_hostname_in_script(){
local OS_IMAGE_HOST_NAME=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*OS_IMAGE_HOST_NAME=.*/OS_IMAGE_HOST_NAME=$OS_IMAGE_HOST_NAME/g" $PATH_TO_SCRIPT
}

function set_hostalias_in_script(){
local OS_IMAGE_HOST_ALIAS=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*OS_IMAGE_HOST_ALIAS=.*/OS_IMAGE_HOST_ALIAS=$OS_IMAGE_HOST_ALIAS/g" $PATH_TO_SCRIPT
}

function set_cluster_name_in_script(){
local OS_IMAGE_CLUSTER_NAME=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*OS_IMAGE_CLUSTER_NAME=.*/OS_IMAGE_CLUSTER_NAME=$OS_IMAGE_CLUSTER_NAME/g" $PATH_TO_SCRIPT
}


function set_run_configure_sh_after_install_in_script(){
local RUN_CONFIGURE_SH_AFTER_INSTALL=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*RUN_CONFIGURE_SH_AFTER_INSTALL=.*/RUN_CONFIGURE_SH_AFTER_INSTALL=$RUN_CONFIGURE_SH_AFTER_INSTALL/g" $PATH_TO_SCRIPT
}

function set_cluster_secure_in_script(){
local CLUSTER_SECURE=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*CLUSTER_SECURE=.*/CLUSTER_SECURE=$CLUSTER_SECURE/g" $PATH_TO_SCRIPT
}


function set_krb_default_realm_in_script(){
local KRB_DEFAULT_REALM=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*KRB_DEFAULT_REALM=.*/KRB_DEFAULT_REALM=$KRB_DEFAULT_REALM/g" $PATH_TO_SCRIPT
}

function set_krb_database_passwd_in_script(){
local KRB_DATABASE_PASSWD=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*KRB_DATABASE_PASSWD=.*/KRB_DATABASE_PASSWD=$KRB_DATABASE_PASSWD/g" $PATH_TO_SCRIPT
}

function set_krb_admin_user_passwd_in_script(){
local KRB_ADMIN_USER_PASSWD=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*KRB_ADMIN_USER_PASSWD=.*/KRB_ADMIN_USER_PASSWD=$KRB_ADMIN_USER_PASSWD/g" $PATH_TO_SCRIPT
}

function set_krb_mapr_user_passwd_in_script(){
local KRB_MAPR_USER_PASSWD=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*KRB_MAPR_USER_PASSWD=.*/KRB_MAPR_USER_PASSWD=$KRB_MAPR_USER_PASSWD/g" $PATH_TO_SCRIPT
}

function update_etc_hosts(){
local OS_IMAGE_HOST_NAME=$1
local OS_IMAGE_HOST_ALIAS=$2
local OS_IMAGE_IP=$3

if  sudo grep -q $OS_IMAGE_HOST_NAME /etc/hosts ; then
    sudo sed -i "s/.*$OS_IMAGE_HOST_NAME.*/$OS_IMAGE_IP $OS_IMAGE_HOST_NAME $OS_IMAGE_HOST_ALIAS/g" /etc/hosts
else
    echo "$OS_IMAGE_IP  $OS_IMAGE_HOST_NAME  $OS_IMAGE_HOST_ALIAS" | sudo tee --append /etc/hosts
fi
}
