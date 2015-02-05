#!/bin/sh

function build_token() {
local OS_TYPE=$1
local MAPR_VERSION=$2

case $OS_TYPE in
    'Centos66' )
     case $MAPR_VERSION in
         '3.1.1' )
          echo 'c66v311'
          ;;
         '4.0.1' )
          echo 'c66v401'
          ;;
         '4.0.2' )
          echo 'c66v402'
          ;;
     esac
     ;;
    'Ubuntu14.04' )
     case $MAPR_VERSION in
         '3.1.1' )
          echo 'u1404v311'
          ;;
         '4.0.1' )
          echo 'u1404v401'
          ;;
         '4.0.2' )
          echo 'u1404v402'
          ;;
     esac
     ;;
esac
}

function set_hbase_version_in_script(){
local HBASE_VERSION=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*HBASE_VERSION=.*/HBASE_VERSION='$HBASE_VERSION'/g" $PATH_TO_SCRIPT
}


function set_hostname_in_script(){
local OS_IMAGE_HOST_NAME=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*HOST_NAME=.*/HOST_NAME=$OS_IMAGE_HOST_NAME/g" $PATH_TO_SCRIPT
}

function set_hostalias_in_script(){
local OS_IMAGE_HOST_ALIAS=$1
local PATH_TO_SCRIPT=$2
sed -i "s/.*HOST_ALIAS=.*/HOST_ALIAS=$OS_IMAGE_HOST_ALIAS/g" $PATH_TO_SCRIPT
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
