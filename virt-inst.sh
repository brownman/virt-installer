#!/bin/sh
source ./conf/env.sh
source ./bin/get-ip.sh
source ./bin/util.sh


echo '[INFO] Select OS'
echo '[INFO] 1 Centos 6.6'
echo '[INFO] 2 Ubuntu 14.04'
read -p "[INPUT] OS type ["$OS_TYPE"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 ]]
    then  echo '[ERROR] Wrong OS type :'$ANSWER'. Possible input 1 or 2.'
          exit 1
    fi

    if [[ $ANSWER == 1 ]]
    then OS_TYPE='Centos66'
    fi

    if [[ $ANSWER == 2 ]]
    then OS_TYPE='Ubuntu14.04'
    fi
fi


echo '[INFO] Select Mapr version'
echo '[INFO] 1 MapR-3.1.1'
echo '[INFO] 2 MapR-4.0.1'
echo '[INFO] 3 MapR-4.0.2'
read -p "[INPUT] MapR version ["$MAPR_VERSION"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 && $ANSWER != 3 ]]
    then  echo '[ERROR] Wrong MapR version :'$ANSWER'. Possible input 1, 2 or 3.'
          exit 1
    fi

    if [[ $ANSWER == 1 ]]
    then MAPR_VERSION='3.1.1'
    fi

    if [[ $ANSWER == 2 ]]
    then MAPR_VERSION='4.0.1'
    fi

    if [[ $ANSWER == 3 ]]
    then MAPR_VERSION='4.0.2'
    fi
fi

read -p "[INPUT] Image dir ["$OS_IMAGE_DIR"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_DIR=$ANSWER
fi

read -p "[INPUT] Image format ["$OS_IMAGE_FORMAT"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_FORMAT=$ANSWER
fi

if [[ $OS_IMAGE_FORMAT != raw && $OS_IMAGE_FORMAT != qcow2 ]]
then  echo '[ERROR] Wrong image format :'$ANSWER'. Possible input raw or qcow2.'
      exit 1
fi

read -p "[INPUT] Image root password ["$OS_IMAGE_ROOT_PASSWD"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_ROOT_PASSWD=$ANSWER
fi


read -p "[INPUT] Image size (GB) ["$OS_IMAGE_SIZE"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_SIZE=$ANSWER
fi

OS_IMAGE_HOST_NAME=$(build_token $OS_TYPE $MAPR_VERSION).com

read -p "[INPUT] Image hostname ["$OS_IMAGE_HOST_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_HOST_NAME=$ANSWER
fi

OS_IMAGE_HOST_ALIAS=$(build_token $OS_TYPE $MAPR_VERSION)

read -p "[INPUT] Image host alias ["$OS_IMAGE_HOST_ALIAS"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_HOST_ALIAS=$ANSWER
fi

OS_IMAGE_FILE_NAME=$(build_token $OS_TYPE $MAPR_VERSION).$OS_IMAGE_FORMAT

read -p "[INPUT] Image filename ["$OS_IMAGE_FILE_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_FILE_NAME=$ANSWER
fi


read -p "[INPUT] MapR cluster name ["$OS_IMAGE_CLUSTER_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_CLUSTER_NAME=$ANSWER
fi


echo '[INFO] Select Hbase version'
echo '[INFO] 1 0.94.21'
echo '[INFO] 2 0.98.4'
read -p "[INPUT] Hbase version ["$HBASE_VERSION"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 ]]
    then  echo '[ERROR] Wrong Hbase version :'$ANSWER'. Possible input 1 or 2.'
          exit 1
    fi

    if [[ $ANSWER == 1 ]]
    then HBASE_VERSION='0.94.21'
    fi

    if [[ $ANSWER == 2 ]]
    then HBASE_VERSION='0.98.4'
    fi
fi


read -p "[INPUT] Lets rock'n'roll (1 - yes, 0 - no)? ["$LETS_ROCK_N_ROLL"]: " ANSWER
if [[ -n $ANSWER ]]
then LETS_ROCK_N_ROLL=$ANSWER
fi

if [[ $LETS_ROCK_N_ROLL != 1 ]]
then exit 0
fi

OS_IMAGE_SCRIPT_NAME=./bin/install/$(build_token $OS_TYPE $MAPR_VERSION).sh
OS_IMAGE_FULL_PATH=$OS_IMAGE_DIR/$OS_IMAGE_FILE_NAME

set_hbase_version_in_script $HBASE_VERSION $OS_IMAGE_SCRIPT_NAME
set_hostname_in_script $OS_IMAGE_HOST_NAME $OS_IMAGE_SCRIPT_NAME
set_hostalias_in_script $OS_IMAGE_HOST_ALIAS $OS_IMAGE_SCRIPT_NAME
set_cluster_name_in_script $OS_IMAGE_CLUSTER_NAME $OS_IMAGE_SCRIPT_NAME

case $OS_TYPE in
    'Centos66' )
    sudo virt-builder centos-6  --output $OS_IMAGE_FULL_PATH --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,syslinux,lsb,sdparm,nc,java-1.7.0-openjdk-devel.x86_64,mysql-connector-java,createrepo --root-password password:$OS_IMAGE_ROOT_PASSWD --size ${OS_IMAGE_SIZE}G --run $OS_IMAGE_SCRIPT_NAME
    virt-install --name $OS_IMAGE_HOST_ALIAS --memory 8192 --vcpus 3 --disk path=$OS_IMAGE_FULL_PATH,size=${OS_IMAGE_SIZE}   --virt-type kvm --os-type=linux  --os-variant=rhel6 --import --noautoconsole
     ;;
    'Ubuntu14.04' )
     sudo virt-builder ubuntu-14.04  --output $OS_IMAGE_FULL_PATH --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,openjdk-7-jdk,syslinux,lsb,sdparm,dpkg-dev --root-password password:$OS_IMAGE_ROOT_PASSWD --size ${OS_IMAGE_SIZE}G --run $OS_IMAGE_SCRIPT_NAME
     virt-install --name $OS_IMAGE_HOST_ALIAS --memory 8192 --vcpus 3 --disk path=$OS_IMAGE_FULL_PATH,size=${OS_IMAGE_SIZE}   --virt-type kvm --os-type=linux  --os-variant=ubuntuprecise --import --noautoconsole
     ;;
esac

# Set new IP in /etc/hosts
OS_IMAGE_IP=$(get_ip $OS_IMAGE_HOST_ALIAS)
echo $OS_IMAGE_IP

