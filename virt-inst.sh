#!/bin/sh
source ./conf/env.sh
source ./bin/get-ip.sh
source ./bin/util.sh
source ./bin/input-data.sh

ENV_FILE=$1

if [[ -n $ENV_FILE ]]
then if [[  -f $ENV_FILE ]]
     then
         source $ENV_FILE
     else
        echo '[ERROR] No file found '$ENV_FILE
        exit 0
     fi
else
     get_input_from_console
fi


if [[ $LETS_ROCK_N_ROLL != 1 ]]
then exit 0
fi

OS_IMAGE_INSTALL_SCRIPT_FULL_PATH=./bin/install/$(build_os_mapr_token $OS_TYPE $MAPR_VERSION).sh
OS_IMAGE_POST_INSTALL_SCRIPT_NAME=post-$(build_os_token $OS_TYPE).sh
OS_IMAGE_SECURE_SCRIPT_FULL_PATH=./bin/post-install/post-$(build_os_token $OS_TYPE)-$CLUSTER_SECURE-secure.sh
OS_IMAGE_POST_INSTALL_SCRIPT_FULL_PATH=./bin/post-install/$OS_IMAGE_POST_INSTALL_SCRIPT_NAME
OS_IMAGE_FULL_PATH=$OS_IMAGE_DIR/$OS_IMAGE_FILE_NAME

set_hbase_version_in_script $HBASE_VERSION $OS_IMAGE_INSTALL_SCRIPT_FULL_PATH
set_hive_version_in_script $HIVE_VERSION $OS_IMAGE_INSTALL_SCRIPT_FULL_PATH
set_cluster_name_in_script $OS_IMAGE_CLUSTER_NAME $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
set_hostname_in_script $OS_IMAGE_HOST_NAME $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
set_hostalias_in_script $OS_IMAGE_HOST_ALIAS $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
set_hostname_in_script $OS_IMAGE_HOST_NAME $OS_IMAGE_POST_INSTALL_SCRIPT_FULL_PATH
set_hostalias_in_script $OS_IMAGE_HOST_ALIAS $OS_IMAGE_POST_INSTALL_SCRIPT_FULL_PATH
set_run_configure_sh_after_install_in_script $RUN_CONFIGURE_SH_AFTER_INSTALL $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
set_cluster_secure_in_script $CLUSTER_SECURE $OS_IMAGE_POST_INSTALL_SCRIPT_FULL_PATH

case $CLUSTER_SECURE in
 none)
 ;;
 mapr)
 ;;
 kerberos)
 set_krb_default_realm_in_script $KRB_DEFAULT_REALM  $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
 set_krb_database_passwd_in_script $KRB_DATABASE_PASSWD $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
 set_krb_admin_user_passwd_in_script $KRB_ADMIN_USER_PASSWD $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
 set_krb_mapr_user_passwd_in_script $KRB_MAPR_USER_PASSWD  $OS_IMAGE_SECURE_SCRIPT_FULL_PATH
 ;;
esac

echo '[INFO] Create dir '$OS_IMAGE_DIR
mkdir -p $OS_IMAGE_DIR

case $OS_TYPE in

    'Centos66' )
    sudo bash "$LIBGUESTFS_HOME"/run virt-builder centos-6  --output $OS_IMAGE_FULL_PATH --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,syslinux,lsb,sdparm,nc,java-1.7.0-openjdk-devel.x86_64,mysql-connector-java,createrepo --root-password password:$OS_IMAGE_ROOT_PASSWD --size ${OS_IMAGE_SIZE}G --run $OS_IMAGE_INSTALL_SCRIPT_FULL_PATH

    if [[ $? -eq 0 ]]
    then
        virt-install --name $OS_IMAGE_HOST_ALIAS --memory $OS_IMAGE_MEMORY --vcpus $OS_IMAGE_VIRT_CPU --disk path=$OS_IMAGE_FULL_PATH,size=${OS_IMAGE_SIZE}   --virt-type kvm --os-type=linux  --os-variant=rhel6 --import --noautoconsole
    else
        echo '[ERROR] No vm file created.'
        exit 0
    fi
    ;;
    'Ubuntu14.04' )
    sudo bash "$LIBGUESTFS_HOME"/run virt-builder ubuntu-14.04  --output $OS_IMAGE_FULL_PATH --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,openjdk-7-jdk,syslinux,lsb,sdparm,dpkg-dev --root-password password:$OS_IMAGE_ROOT_PASSWD --size ${OS_IMAGE_SIZE}G --run $OS_IMAGE_INSTALL_SCRIPT_FULL_PATH

    if [[ $? -eq 0 ]]
    then
         virt-install --name $OS_IMAGE_HOST_ALIAS --memory $OS_IMAGE_MEMORY --vcpus $OS_IMAGE_VIRT_CPU --disk path=$OS_IMAGE_FULL_PATH,size=${OS_IMAGE_SIZE}   --virt-type kvm --os-type=linux  --os-variant=ubuntuprecise --import --noautoconsole
    else
        echo '[ERROR] No vm file created.'
        exit 0
    fi
    ;;
esac

echo '[INFO] Set new IP in /etc/hosts'
OS_IMAGE_IP=$(get_ip $OS_IMAGE_HOST_ALIAS)
while [[ -z $OS_IMAGE_IP ]]; do
    echo '[INFO] Waiting while vm is booting...'
    sleep 1
    OS_IMAGE_IP=$(get_ip $OS_IMAGE_HOST_ALIAS)
done

echo '[INFO] IP address of '$OS_IMAGE_HOST_ALIAS' is :' $OS_IMAGE_IP

update_etc_hosts $OS_IMAGE_HOST_NAME $OS_IMAGE_HOST_ALIAS $OS_IMAGE_IP

ssh-keygen -f "$USER_HOME/.ssh/known_hosts" -R $OS_IMAGE_HOST_ALIAS

RESULT=-1

while [[ $RESULT -ne 0 ]]; do
    ssh-copy-id -i $SSH_ID_RSA_PUB root@$OS_IMAGE_HOST_ALIAS
    RESULT=$?
    echo '[INFO] Waiting for ssh connection...'
    sleep 1
done

echo '[INFO] Copy and run post install script.'
scp $OS_IMAGE_POST_INSTALL_SCRIPT_FULL_PATH $OS_IMAGE_SECURE_SCRIPT_FULL_PATH root@$OS_IMAGE_HOST_ALIAS:/root/
ssh root@$OS_IMAGE_HOST_ALIAS 'bash /root/'$OS_IMAGE_POST_INSTALL_SCRIPT_NAME
