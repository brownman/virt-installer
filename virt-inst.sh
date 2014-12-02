#!/bin/sh
source env.sh

function build_hostname() {
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
     esac 
     ;;
esac
}



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
read -p "[INPUT] MapR version ["$MAPR_VERSION"]:" ANSWER
if [[ -n $ANSWER ]]
then  
    if [[ $ANSWER != 1 && $ANSWER != 2 ]]
    then  echo '[ERROR] Wrong MapR version :'$ANSWER'. Possible input 1 or 2.' 
          exit 1
    fi

    if [[ $ANSWER == 1 ]]
    then MAPR_VERSION='3.1.1'
    fi

    if [[ $ANSWER == 2 ]]
    then MAPR_VERSION='4.0.1'
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


read -p "[INPUT] Image size ["$OS_IMAGE_SIZE"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_SIZE=$ANSWER
fi


OS_IMAGE_HOST_NAME=$(build_hostname $OS_TYPE $MAPR_VERSION).com

read -p "[INPUT] Image hostname ["$OS_IMAGE_HOST_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_HOST_NAME=$ANSWER
fi


read -p "[INPUT] Lets rock'n'roll (1 - yes, 0 - no)? ["$LETS_ROCK_N_ROLL"]: " ANSWER
if [[ -n $ANSWER ]]
then LETS_ROCK_N_ROLL=$ANSWER
fi

if [[ $ANSWER != 1 ]]
then exit 0
fi


if [[ $OS_TYPE == 'Centos66' && $MAPR_VERSION == '3.1.1' ]]
then sudo virt-builder centos-6 --output $OS_IMAGE_DIR/c66v311-new.qcow2 --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,syslinux,lsb,sdparm,nc,java-1.7.0-openjdk-devel.x86_64,mysql-connector-java,createrepo --root-password password:$OS_IMAGE_ROOT_PASSWD --size $OS_IMAGE_SIZE --run c66v311.sh
fi

if [[ $OS_TYPE == 'Ubuntu14.04' && $MAPR_VERSION == '4.0.1' ]]
then sudo virt-builder ubuntu-14.04 --output $OS_IMAGE_DIR/u1404v401.qcow2 --verbose --format $OS_IMAGE_FORMAT --hostname $OS_IMAGE_HOST_NAME --install openssh-server,openjdk-7-jdk,syslinux,lsb,sdparm,dpkg-dev --root-password password:$OS_IMAGE_ROOT_PASSWD --size $OS_IMAGE_SIZE --run u1404v401.sh 
fi




